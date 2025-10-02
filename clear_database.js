import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, deleteDoc, doc } from 'firebase/firestore';

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

async function clearProducts() {
  try {
    console.log('🗑️ Clearing existing products...');
    
    // Get all products
    const productsSnapshot = await getDocs(collection(db, 'products'));
    
    console.log(`Found ${productsSnapshot.docs.length} products to delete`);
    
    // Delete each product
    const deletePromises = productsSnapshot.docs.map(productDoc => 
      deleteDoc(doc(db, 'products', productDoc.id))
    );
    
    await Promise.all(deletePromises);
    
    console.log('✅ All products deleted successfully!');
    console.log('Now you can run the app and initialize the database with new products.');
    
  } catch (error) {
    console.error('❌ Error clearing products:', error);
  }
}

clearProducts();