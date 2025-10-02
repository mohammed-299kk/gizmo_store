import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, deleteDoc, doc, writeBatch } from 'firebase/firestore';

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

async function deleteAllProducts() {
  try {
    console.log('🔄 جاري حذف جميع المنتجات...');
    
    // Get all products
    const productsSnapshot = await getDocs(collection(db, 'products'));
    
    if (productsSnapshot.empty) {
      console.log('❌ لا توجد منتجات للحذف!');
      return;
    }
    
    console.log(`📦 تم العثور على ${productsSnapshot.size} منتج للحذف`);
    
    // Delete in batches (Firestore batch limit is 500)
    const batchSize = 500;
    const batches = [];
    let currentBatch = writeBatch(db);
    let operationCount = 0;
    
    productsSnapshot.docs.forEach((docSnapshot) => {
      currentBatch.delete(doc(db, 'products', docSnapshot.id));
      operationCount++;
      
      if (operationCount === batchSize) {
        batches.push(currentBatch);
        currentBatch = writeBatch(db);
        operationCount = 0;
      }
    });
    
    // Add the last batch if it has operations
    if (operationCount > 0) {
      batches.push(currentBatch);
    }
    
    // Execute all batches
    console.log(`🔄 تنفيذ ${batches.length} دفعة حذف...`);
    
    for (let i = 0; i < batches.length; i++) {
      await batches[i].commit();
      console.log(`✅ تم حذف الدفعة ${i + 1}/${batches.length}`);
    }
    
    console.log('✅ تم حذف جميع المنتجات بنجاح!');
    
  } catch (error) {
    console.error('❌ خطأ في حذف المنتجات:', error);
  } finally {
    process.exit(0);
  }
}

deleteAllProducts();