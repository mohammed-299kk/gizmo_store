/**
 * Firebase Admin User Creation Script
 * 
 * SECURITY WARNING: This script is for development/testing purposes only.
 * Never use hardcoded credentials in production environments.
 * 
 * Prerequisites:
 * 1. Install Firebase Admin SDK: npm install firebase-admin
 * 2. Download service account key from Firebase Console
 * 3. Set environment variables for security
 */

const admin = require('firebase-admin');
const readline = require('readline');

// Initialize Firebase Admin SDK
// Replace with your actual service account key path
const serviceAccount = require('./gizmostore-2a3ff-firebase-adminsdk.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'gizmostore-2a3ff'
});

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

/**
 * Securely prompt for user input
 */
function promptUser(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer);
    });
  });
}

/**
 * Hide password input (basic implementation)
 */
function promptPassword(question) {
  return new Promise((resolve) => {
    process.stdout.write(question);
    process.stdin.setRawMode(true);
    process.stdin.resume();
    process.stdin.setEncoding('utf8');
    
    let password = '';
    process.stdin.on('data', function(char) {
      char = char + '';
      
      switch(char) {
        case '\n':
        case '\r':
        case '\u0004':
          process.stdin.setRawMode(false);
          process.stdin.pause();
          process.stdout.write('\n');
          resolve(password);
          break;
        case '\u0003':
          process.exit();
          break;
        default:
          password += char;
          process.stdout.write('*');
          break;
      }
    });
  });
}

/**
 * Create admin user with proper error handling
 */
async function createAdminUser() {
  try {
    console.log('🔐 Firebase Admin User Creation Tool');
    console.log('=====================================\n');
    
    // Get user input securely
    const email = await promptUser('Enter admin email: ');
    const password = await promptPassword('Enter admin password: ');
    const displayName = await promptUser('Enter display name (optional): ');
    
    console.log('\n🔄 Creating user account...');
    
    // Validate input
    if (!email || !password) {
      throw new Error('Email and password are required');
    }
    
    if (password.length < 6) {
      throw new Error('Password must be at least 6 characters long');
    }
    
    // Check if user already exists
    try {
      const existingUser = await admin.auth().getUserByEmail(email);
      console.log(`⚠️  User with email ${email} already exists (UID: ${existingUser.uid})`);
      
      const updateExisting = await promptUser('Do you want to update existing user to admin? (y/n): ');
      if (updateExisting.toLowerCase() === 'y') {
        await admin.auth().setCustomUserClaims(existingUser.uid, { 
          admin: true,
          role: 'admin',
          updatedAt: new Date().toISOString()
        });
        console.log(`✅ User ${email} successfully assigned admin privileges`);
        return;
      } else {
        console.log('❌ Operation cancelled');
        return;
      }
    } catch (error) {
      if (error.code !== 'auth/user-not-found') {
        throw error;
      }
      // User doesn't exist, continue with creation
    }
    
    // Create new user
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
      displayName: displayName || 'Admin User',
      emailVerified: true
    });
    
    console.log(`✅ User created successfully: ${email}`);
    console.log(`   UID: ${userRecord.uid}`);
    
    // Set admin custom claims
    await admin.auth().setCustomUserClaims(userRecord.uid, {
      admin: true,
      role: 'admin',
      createdAt: new Date().toISOString()
    });
    
    console.log(`✅ Admin privileges assigned to ${email}`);
    
    // Also create user document in Firestore
    await admin.firestore().collection('users').doc(userRecord.uid).set({
      email: email,
      role: 'admin',
      isAdmin: true,
      fullName: displayName || 'Admin User',
      isActive: true,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastLogin: null
    });
    
    console.log(`✅ User document created in Firestore`);
    
    console.log('\n🎉 Admin user setup completed successfully!');
    console.log('\nUser can now login with:');
    console.log(`   Email: ${email}`);
    console.log(`   Role: admin`);
    console.log(`   Custom Claims: { admin: true, role: "admin" }`);
    
  } catch (error) {
    console.error('\n❌ Error creating admin user:', error.message);
    
    // Provide specific error guidance
    switch (error.code) {
      case 'auth/email-already-exists':
        console.log('💡 Tip: Use a different email or update the existing user');
        break;
      case 'auth/invalid-email':
        console.log('💡 Tip: Please provide a valid email address');
        break;
      case 'auth/weak-password':
        console.log('💡 Tip: Password should be at least 6 characters long');
        break;
      default:
        console.log('💡 Tip: Check your Firebase configuration and permissions');
    }
  } finally {
    rl.close();
    process.exit();
  }
}

/**
 * Verify admin user can be retrieved
 */
async function verifyAdminUser(email) {
  try {
    const user = await admin.auth().getUserByEmail(email);
    const customClaims = user.customClaims || {};
    
    console.log('\n🔍 User Verification:');
    console.log(`   Email: ${user.email}`);
    console.log(`   UID: ${user.uid}`);
    console.log(`   Admin Claim: ${customClaims.admin || false}`);
    console.log(`   Role: ${customClaims.role || 'none'}`);
    
    return customClaims.admin === true;
  } catch (error) {
    console.error('❌ Error verifying user:', error.message);
    return false;
  }
}

// Main execution
if (require.main === module) {
  createAdminUser();
}

module.exports = { createAdminUser, verifyAdminUser };
