/**
 * Create Admin User Document in Firestore using Web SDK
 * This script creates the missing Firestore document for the admin user
 */

const { initializeApp } = require('firebase/app');
const { getFirestore, doc, setDoc, getDoc, serverTimestamp } = require('firebase/firestore');
const { getAuth, signInWithEmailAndPassword } = require('firebase/auth');

// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyAo4-Ge1dC4LnIyG_wUjYgWc9KHCxEYUxM",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  projectId: "gizmostore-2a3ff",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  messagingSenderId: "32902740595",
  appId: "1:32902740595:web:7de8f1273a64f9f28fc806"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);

async function createAdminDocument() {
  try {
    console.log('🔄 Creating admin user document in Firestore...');
    
    // Sign in as admin first
    const adminEmail = 'mohammedm17@gmail.com';
    const adminPassword = 'your_admin_password'; // You'll need to provide this
    
    console.log('🔐 Signing in as admin...');
    const userCredential = await signInWithEmailAndPassword(auth, adminEmail, adminPassword);
    const user = userCredential.user;
    
    console.log(`✅ Signed in successfully with UID: ${user.uid}`);
    
    // Create admin user document
    const adminDocRef = doc(db, 'users', user.uid);
    
    await setDoc(adminDocRef, {
      uid: user.uid,
      email: adminEmail,
      displayName: user.displayName || 'm',
      fullName: user.displayName || 'm',
      firstName: 'm',
      lastName: '',
      role: 'admin',
      isAdmin: true,
      userType: 'admin',
      isActive: true,
      emailVerified: user.emailVerified,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
      lastLogin: serverTimestamp(),
      preferences: {
        language: 'ar',
        theme: 'light',
        notifications: true
      },
      profile: {
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
      }
    });
    
    console.log('✅ Admin user document created successfully!');
    console.log(`   UID: ${user.uid}`);
    console.log(`   Email: ${adminEmail}`);
    console.log(`   Role: admin`);
    
    // Verify the document was created
    const docSnap = await getDoc(adminDocRef);
    if (docSnap.exists()) {
      const data = docSnap.data();
      console.log('\n🔍 Verification:');
      console.log(`   Document exists: ${docSnap.exists()}`);
      console.log(`   Role: ${data.role}`);
      console.log(`   Is Admin: ${data.isAdmin}`);
      console.log(`   User Type: ${data.userType}`);
    }
    
  } catch (error) {
    console.error('❌ Error creating admin document:', error.message);
    
    if (error.code === 'auth/wrong-password') {
      console.log('\n💡 Please update the admin password in the script.');
    } else if (error.code === 'auth/user-not-found') {
      console.log('\n💡 Admin user not found. Please create the admin user first.');
    }
  } finally {
    process.exit(0);
  }
}

// Run the script
createAdminDocument();