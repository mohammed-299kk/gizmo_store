// Script to create admin user in Firestore
const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function createAdminUser() {
  try {
    const adminUserData = {
      uid: 'Hj11wZ1FlANccDf5xoi9ujdZiFM2',
      email: 'admin@gmail.com',
      name: 'Admin User',
      userType: 'admin',
      isAdmin: true,
      isActive: true,
      preferences: {
        language: 'en',
        notifications: true,
        theme: 'light'
      },
      profile: {
        firstName: 'Admin',
        lastName: 'User',
        avatar: null,
        phone: null,
        address: null,
        dateOfBirth: null
      },
      stats: {
        totalOrders: 0,
        totalSpent: 0,
        favoriteProducts: [],
        cartItems: []
      },
      createdAt: admin.firestore.Timestamp.now(),
      lastLoginAt: admin.firestore.Timestamp.now()
    };

    await db.collection('users').doc('Hj11wZ1FlANccDf5xoi9ujdZiFM2').set(adminUserData);
    console.log('Admin user created successfully!');
  } catch (error) {
    console.error('Error creating admin user:', error);
  }
}

createAdminUser();