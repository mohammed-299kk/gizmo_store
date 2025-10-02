// Simple script to update products using Firebase web SDK
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, updateDoc, doc } from 'firebase/firestore';

// Firebase configuration from the project
const firebaseConfig = {
  apiKey: 'AIzaSyAo4-Ge1dC4LnIyG_wUjYgWc9KHCxEYUxM',
  authDomain: 'gizmostore-2a3ff.firebaseapp.com',
  projectId: 'gizmostore-2a3ff',
  storageBucket: 'gizmostore-2a3ff.firebasestorage.app',
  messagingSenderId: '32902740595',
  appId: '1:32902740595:web:7de8f1273a64f9f28fc806',
  measurementId: 'G-WF0Z8EKYMX'
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function updateAllProductsStock() {
  console.log('🚀 بدء تحديث حالة المخزون للمنتجات...');
  
  try {
    // Get all products
    console.log('📦 جلب جميع المنتجات...');
    const productsRef = collection(db, 'products');
    const snapshot = await getDocs(productsRef);
    
    console.log(`📊 تم العثور على ${snapshot.size} منتج`);
    
    if (snapshot.empty) {
      console.log('⚠️ لا توجد منتجات في قاعدة البيانات');
      return;
    }
    
    let updatedCount = 0;
    let errorCount = 0;
    
    // Process each product
    for (const docSnapshot of snapshot.docs) {
      try {
        const data = docSnapshot.data();
        const productName = data.name || data.title || 'منتج غير معروف';
        const currentStock = data.stock || data.stockQuantity || 0;
        const isAvailable = data.isAvailable;
        
        console.log(`🔄 تحديث المنتج: ${productName}`);
        console.log(`   المخزون الحالي: ${currentStock}, متوفر: ${isAvailable}`);
        
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
        errorCount++;
      }
    }
    
    console.log('\n🎉 اكتمل تحديث المخزون!');
    console.log(`✅ تم تحديث ${updatedCount} منتج بنجاح`);
    if (errorCount > 0) {
      console.log(`❌ فشل في تحديث ${errorCount} منتج`);
    }
    
    // Verify the updates
    console.log('\n🔍 التحقق من التحديثات...');
    const verifySnapshot = await getDocs(productsRef);
    
    let availableCount = 0;
    let totalStock = 0;
    
    verifySnapshot.forEach(docSnapshot => {
      const data = docSnapshot.data();
      const isAvailable = data.isAvailable;
      const stock = data.stock || data.stockQuantity || 0;
      
      if (isAvailable && stock > 0) {
        availableCount++;
      }
      totalStock += stock;
    });
    
    console.log('📊 النتائج النهائية:');
    console.log(`   المنتجات المتوفرة: ${availableCount} من ${verifySnapshot.size}`);
    console.log(`   إجمالي المخزون: ${totalStock} قطعة`);
    
    if (availableCount === verifySnapshot.size) {
      console.log('🎯 ممتاز! جميع المنتجات أصبحت متوفرة في المخزون');
    } else {
      console.log(`⚠️ تحذير: ${verifySnapshot.size - availableCount} منتج لا يزال غير متوفر`);
    }
    
  } catch (error) {
    console.error('❌ خطأ عام:', error.message);
    console.error('تفاصيل الخطأ:', error);
    
    if (error.message.includes('permission')) {
      console.log('\n💡 نصيحة: تأكد من أن لديك صلاحيات الكتابة في Firestore');
    }
  }
  
  console.log('\n✨ انتهى السكريپت!');
  process.exit(0);
}

// Run the update
updateAllProductsStock().catch(console.error);