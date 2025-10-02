/**
 * Simple Admin User Creation Script
 * Creates an admin user directly using Firebase Auth and Firestore
 */

const admin = require('firebase-admin');

// Initialize Firebase Admin SDK with project ID only
// This will use Application Default Credentials or service account from environment
try {
  admin.initializeApp({
    projectId: 'gizmostore-2a3ff'
  });
} catch (error) {
  if (error.code !== 'app/duplicate-app') {
    console.error('Error initializing Firebase Admin:', error);
    process.exit(1);
  }
}

const auth = admin.auth();
const firestore = admin.firestore();

/**
 * Create admin user with provided credentials
 */
async function createAdminUser() {
  const email = 'admin@gizmo.com';
  const password = 'gizmo1234';
  const displayName = 'Admin User';

  try {
    console.log('Creating admin user...');
    
    // Create user in Firebase Auth
    const userRecord = await auth.createUser({
      email: email,
      password: password,
      displayName: displayName,
      emailVerified: true
    });

    console.log('User created successfully:', userRecord.uid);

    // Add admin role to Firestore
    await firestore.collection('users').doc(userRecord.uid).set({
      email: email,
      displayName: displayName,
      role: 'admin',
      isAdmin: true,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log('Admin role added to Firestore');
    
    // Set custom claims
    await auth.setCustomUserClaims(userRecord.uid, {
      admin: true,
      role: 'admin'
    });

    console.log('Custom claims set successfully');
    console.log('\n✅ Admin user created successfully!');
    console.log('Email:', email);
    console.log('Password:', password);
    console.log('UID:', userRecord.uid);
    
  } catch (error) {
    if (error.code === 'auth/email-already-exists') {
      console.log('User already exists. Updating admin privileges...');
      
      try {
        // Get existing user
        const userRecord = await auth.getUserByEmail(email);
        
        // Update Firestore document
        await firestore.collection('users').doc(userRecord.uid).set({
          email: email,
          displayName: displayName,
          role: 'admin',
          isAdmin: true,
          updatedAt: admin.firestore.FieldValue.serverTimestamp()
        }, { merge: true });
        
        // Set custom claims
        await auth.setCustomUserClaims(userRecord.uid, {
          admin: true,
          role: 'admin'
        });
        
        console.log('✅ Admin privileges updated successfully!');
        console.log('Email:', email);
        console.log('UID:', userRecord.uid);
        
      } catch (updateError) {
        console.error('Error updating admin privileges:', updateError);
      }
    } else {
      console.error('Error creating admin user:', error);
    }
  }
}

// Run the script
if (require.main === module) {
  createAdminUser().then(() => {
    console.log('\nScript completed.');
    process.exit(0);
  }).catch((error) => {
    console.error('Script failed:', error);
    process.exit(1);
  });
}

module.exports = { createAdminUser };