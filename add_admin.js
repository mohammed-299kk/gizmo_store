const { initializeApp } = require('firebase/app');
const { getFirestore, doc, setDoc, Timestamp } = require('firebase/firestore');

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyBKQJXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", // Replace with actual API key
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  projectId: "gizmostore-2a3ff",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  messagingSenderId: "32902740595",
  appId: "1:32902740595:web:7de8f1273a64f9f28fc806"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function addAdminUser() {
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
      createdAt: Timestamp.now(),
      lastLoginAt: Timestamp.now()
    };

    await setDoc(doc(db, 'users', 'Hj11wZ1FlANccDf5xoi9ujdZiFM2'), adminUserData);
    console.log('Admin user added successfully!');
  } catch (error) {
    console.error('Error adding admin user:', error);
  }
}

addAdminUser();