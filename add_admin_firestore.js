const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'gizmostore-2a3ff'
  });
}

const db = admin.firestore();

async function createAdminUser() {
  try {
    const adminUserData = {
      uid: 'q3x9weNlEmYpRnM4NSGB8I8kvd73',
      email: 'admin@gizmo.com',
      displayName: 'Admin User',
      isAdmin: true,
      role: 'admin',
      userType: 'admin',
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    };

    await db.collection('users').doc('q3x9weNlEmYpRnM4NSGB8I8kvd73').set(adminUserData);
    
    console.log('✅ Admin user document created successfully in Firestore!');
    console.log('Document ID:', 'q3x9weNlEmYpRnM4NSGB8I8kvd73');
    console.log('Email:', 'admin@gizmo.com');
    console.log('User Type:', 'admin');
    
  } catch (error) {
    console.error('❌ Error creating admin user document:', error);
  }
}

createAdminUser().then(() => {
  console.log('Script completed.');
  process.exit(0);
}).catch((error) => {
  console.error('Script failed:', error);
  process.exit(1);
});