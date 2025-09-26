const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const auth = admin.auth();
const firestore = admin.firestore();

async function createAdminUser() {
  try {
    // Create user in Firebase Auth
    const userRecord = await auth.createUser({
      uid: 'q3x9weNlEmYpRnM4NSGB8I8kvd73',
      email: 'admin@gizmo.com',
      password: 'gizmo1234',
      displayName: 'Admin User',
      emailVerified: true,
      disabled: false
    });
    
    console.log('✅ Admin user created in Firebase Auth:', userRecord.uid);
    
    // Create user document in Firestore
    await firestore.collection('users').doc(userRecord.uid).set({
      uid: userRecord.uid,
      email: 'admin@gizmo.com',
      displayName: 'Admin User',
      isAdmin: true,
      role: 'admin',
      userType: 'admin',
      permissions: {
        users: true,
        products: true,
        orders: true,
        categories: true,
        reports: true,
        settings: true
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastLoginAt: admin.firestore.FieldValue.serverTimestamp(),
      isActive: true,
      preferences: {
        language: 'ar',
        notifications: true,
        theme: 'dark'
      }
    });
    
    console.log('✅ Admin user document created in Firestore');
    console.log('🎉 Admin user setup completed successfully!');
    console.log('📧 Email: admin@gizmo.com');
    console.log('🔑 Password: gizmo1234');
    
  } catch (error) {
    console.error('❌ Error creating admin user:', error);
  } finally {
    process.exit();
  }
}

createAdminUser();