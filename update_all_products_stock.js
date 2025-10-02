// Simple script to update all products to be in stock
// Run this in browser console or as a Node.js script

const { initializeApp } = require('firebase/app');
const { getFirestore, collection, getDocs, updateDoc, doc } = require('firebase/firestore');

// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDvzKKWzKOLKOLKOLKOLKOLKOLKOLKOLKOL",
  authDomain: "gizmo-store-2024.firebaseapp.com",
  projectId: "gizmo-store-2024",
  storageBucket: "gizmo-store-2024.firebasestorage.app",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdefghijklmnop"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function updateAllProductsStock() {
  console.log('🚀 بدء تحديث حالة المخزون للمنتجات...');
  
  try {
    // Get all products
    const productsRef = collection(db, 'products');
    const snapshot = await getDocs(productsRef);
    
    console.log(`📦 تم العثور على ${snapshot.size} منتج`);
    
    let updatedCount = 0;
    
    // Update each product
    for (const docSnapshot of snapshot.docs) {
      try {
        const data = docSnapshot.data();
        const productName = data.name || 'منتج غير معروف';
        const currentStock = data.stock || data.stockQuantity || 0;
        
        console.log(`🔄 تحديث المنتج: ${productName} (المخزون الحالي: ${currentStock})`);
        
        // Determine new stock quantity
        let newStock;
        if (currentStock <= 0) {
          newStock = 25; // Default stock for out-of-stock items
        } else if (currentStock < 10) {
          newStock = currentStock + 20; // Add 20 to low stock items
        } else {
          newStock = Math.max(currentStock, 15); // Ensure minimum 15 items
        }
        
        // Update the product
        const productRef = doc(db, 'products', docSnapshot.id);
        await updateDoc(productRef, {
          stock: newStock,
          stockQuantity: newStock,
          isAvailable: true,
          inStock: true,
          updatedAt: new Date()
        });
        
        console.log(`   ✅ تم التحديث - المخزون الجديد: ${newStock}`);
        updatedCount++;
        
        // Small delay to avoid overwhelming Firestore
        await new Promise(resolve => setTimeout(resolve, 100));
        
      } catch (error) {
        console.error(`   ❌ خطأ في تحديث المنتج: ${error.message}`);
      }
    }
    
    console.log(`\n🎉 تم تحديث ${updatedCount} منتج بنجاح!`);
    console.log('✨ جميع المنتجات أصبحت متوفرة في المخزون');
    
  } catch (error) {
    console.error('❌ خطأ عام:', error.message);
  }
}

// Run the update
updateAllProductsStock();