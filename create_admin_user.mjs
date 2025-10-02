import admin from 'firebase-admin';
import { readFileSync } from 'fs';

// Initialize Firebase Admin SDK
let serviceAccount;
try {
  serviceAccount = JSON.parse(readFileSync('./admin_auth.json', 'utf8'));
  serviceAccount.project_id = 'gizmostore-2a3ff'; // إضافة project_id
} catch (error) {
  // Fallback service account
  serviceAccount = {
    type: "service_account",
    project_id: "gizmostore-2a3ff",
    private_key_id: "your_private_key_id",
    private_key: "your_private_key",
    client_email: "firebase-adminsdk@gizmostore-2a3ff.iam.gserviceaccount.com",
    client_id: "your_client_id",
    auth_uri: "https://accounts.google.com/o/oauth2/auth",
    token_uri: "https://oauth2.googleapis.com/token"
  };
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://gizmostore-2a3ff-default-rtdb.firebaseio.com"
});

const auth = admin.auth();
const firestore = admin.firestore();

async function createAdminUser() {
  try {
    // Check if admin user already exists
    try {
      const existingUser = await auth.getUserByEmail('admin@gizmostore.com');
      console.log('Admin user already exists:', existingUser.uid);
      
      // Update user in Firestore with admin privileges
      await firestore.collection('users').doc(existingUser.uid).set({
        email: 'admin@gizmostore.com',
        displayName: 'Admin User',
        isAdmin: true,
        role: 'admin',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });
      
      console.log('Successfully updated admin user in Firestore');
      return;
    } catch (error) {
      if (error.code !== 'auth/user-not-found') {
        throw error;
      }
    }

    // Create user in Firebase Auth
    const userRecord = await auth.createUser({
      email: 'admin@gizmostore.com',
      password: 'Admin123!',
      displayName: 'Admin User',
      emailVerified: true
    });

    console.log('Successfully created new user:', userRecord.uid);

    // Add user to Firestore with admin privileges
    await firestore.collection('users').doc(userRecord.uid).set({
      email: 'admin@gizmostore.com',
      displayName: 'Admin User',
      isAdmin: true,
      role: 'admin',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });

    console.log('Successfully added admin user to Firestore');
    console.log('Admin credentials:');
    console.log('Email: admin@gizmostore.com');
    console.log('Password: Admin123!');

  } catch (error) {
    console.log('Error creating/updating admin user:', error);
  }
}

createAdminUser().then(() => {
  process.exit(0);
});