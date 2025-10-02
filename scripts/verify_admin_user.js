/**
 * Firebase Admin User Verification Script
 * 
 * This script verifies that an admin user exists and has proper claims
 */

const admin = require('firebase-admin');
const readline = require('readline');

// Initialize Firebase Admin SDK
const serviceAccount = require('./gizmostore-2a3ff-firebase-adminsdk.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'gizmostore-2a3ff'
});

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function promptUser(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer);
    });
  });
}

async function verifyAdminUser() {
  try {
    console.log('🔍 Firebase Admin User Verification Tool');
    console.log('=========================================\n');
    
    const email = await promptUser('Enter admin email to verify: ');
    
    if (!email) {
      throw new Error('Email is required');
    }
    
    console.log(`\n🔄 Checking user: ${email}...`);
    
    // Get user from Firebase Auth
    const userRecord = await admin.auth().getUserByEmail(email);
    
    console.log('\n📋 User Information:');
    console.log(`   Email: ${userRecord.email}`);
    console.log(`   UID: ${userRecord.uid}`);
    console.log(`   Display Name: ${userRecord.displayName || 'Not set'}`);
    console.log(`   Email Verified: ${userRecord.emailVerified}`);
    console.log(`   Disabled: ${userRecord.disabled}`);
    console.log(`   Created: ${new Date(userRecord.metadata.creationTime).toLocaleString()}`);
    console.log(`   Last Sign In: ${userRecord.metadata.lastSignInTime ? new Date(userRecord.metadata.lastSignInTime).toLocaleString() : 'Never'}`);
    
    // Check custom claims
    const customClaims = userRecord.customClaims || {};
    console.log('\n🏷️  Custom Claims:');
    console.log(`   Admin: ${customClaims.admin || false}`);
    console.log(`   Role: ${customClaims.role || 'none'}`);
    
    if (Object.keys(customClaims).length > 0) {
      console.log('   All Claims:', JSON.stringify(customClaims, null, 2));
    }
    
    // Check Firestore document
    try {
      const userDoc = await admin.firestore().collection('users').doc(userRecord.uid).get();
      
      if (userDoc.exists) {
        const userData = userDoc.data();
        console.log('\n📄 Firestore Document:');
        console.log(`   Role: ${userData.role || 'none'}`);
        console.log(`   Is Admin: ${userData.isAdmin || false}`);
        console.log(`   Is Active: ${userData.isActive || false}`);
        console.log(`   Full Name: ${userData.fullName || 'Not set'}`);
      } else {
        console.log('\n⚠️  No Firestore document found for this user');
      }
    } catch (firestoreError) {
      console.log('\n❌ Error checking Firestore document:', firestoreError.message);
    }
    
    // Verify admin status
    const isAdmin = customClaims.admin === true;
    const hasAdminRole = customClaims.role === 'admin';
    
    console.log('\n🎯 Admin Status Summary:');
    if (isAdmin && hasAdminRole) {
      console.log('   ✅ User has proper admin privileges');
      console.log('   ✅ Can access admin features');
    } else if (isAdmin || hasAdminRole) {
      console.log('   ⚠️  User has partial admin setup');
      console.log('   💡 Consider updating claims for full admin access');
    } else {
      console.log('   ❌ User does not have admin privileges');
      console.log('   💡 Use create_admin_user.js to grant admin access');
    }
    
    // Test token generation (optional)
    try {
      const customToken = await admin.auth().createCustomToken(userRecord.uid);
      console.log('\n🔑 Custom Token Generation: ✅ Success');
    } catch (tokenError) {
      console.log('\n🔑 Custom Token Generation: ❌ Failed');
      console.log(`   Error: ${tokenError.message}`);
    }
    
  } catch (error) {
    console.error('\n❌ Error verifying user:', error.message);
    
    switch (error.code) {
      case 'auth/user-not-found':
        console.log('💡 Tip: User does not exist. Create the user first.');
        break;
      case 'auth/invalid-email':
        console.log('💡 Tip: Please provide a valid email address');
        break;
      default:
        console.log('💡 Tip: Check your Firebase configuration and permissions');
    }
  } finally {
    rl.close();
    process.exit();
  }
}

// List all admin users
async function listAdminUsers() {
  try {
    console.log('👥 Listing all admin users...\n');
    
    const listUsersResult = await admin.auth().listUsers();
    const adminUsers = [];
    
    for (const userRecord of listUsersResult.users) {
      const customClaims = userRecord.customClaims || {};
      if (customClaims.admin === true || customClaims.role === 'admin') {
        adminUsers.push({
          email: userRecord.email,
          uid: userRecord.uid,
          displayName: userRecord.displayName,
          claims: customClaims
        });
      }
    }
    
    if (adminUsers.length === 0) {
      console.log('❌ No admin users found');
    } else {
      console.log(`✅ Found ${adminUsers.length} admin user(s):\n`);
      adminUsers.forEach((user, index) => {
        console.log(`${index + 1}. ${user.email}`);
        console.log(`   UID: ${user.uid}`);
        console.log(`   Name: ${user.displayName || 'Not set'}`);
        console.log(`   Claims: ${JSON.stringify(user.claims)}\n`);
      });
    }
    
  } catch (error) {
    console.error('❌ Error listing admin users:', error.message);
  }
}

// Main execution
async function main() {
  const action = process.argv[2];
  
  if (action === 'list') {
    await listAdminUsers();
  } else {
    await verifyAdminUser();
  }
}

if (require.main === module) {
  main();
}

module.exports = { verifyAdminUser, listAdminUsers };
