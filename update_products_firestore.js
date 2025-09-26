// Script to update all products to be in stock
// This script uses Firebase Admin SDK

import admin from 'firebase-admin';

// Initialize Firebase Admin with default credentials
// Make sure you're logged in with Firebase CLI
try {
  admin.initializeApp({
    projectId: 'gizmostore-2a3ff'
  });
} catch (error) {
  console.log('Firebase already initialized or error:', error.message);
}

const db = admin.firestore();

async function updateAllProductsStock() {
  console.log('🚀 بدء تحديث حالة المخزون للمنتجات...');
  
  try {
    // Get all products
    console.log('📦 جلب جميع المنتجات...');
    const snapshot = await db.collection('products').get();
    
    console.log(`📊 تم العثور على ${snapshot.size} منتج`);
    
    if (snapshot.empty) {
      console.log('⚠️ لا توجد منتجات في قاعدة البيانات');
      return;
    }
    
    let updatedCount = 0;
    let errorCount = 0;
    
    // Process each product
    for (const doc of snapshot.docs) {
      try {
        const data = doc.data();
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
        await doc.ref.update({
          stock: newStock,
          stockQuantity: newStock, // For compatibility
          isAvailable: true,
          inStock: true, // For compatibility
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        
        console.log(`   ✅ تم التحديث - المخزون الجديد: ${newStock}`);
        updatedCount++;
        
        // Small delay to avoid overwhelming Firestore
        await new Promise(resolve => setTimeout(resolve, 50));
        
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
    const verifySnapshot = await db.collection('products').get();
    
    let availableCount = 0;
    let totalStock = 0;
    
    verifySnapshot.forEach(doc => {
      const data = doc.data();
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
      console.log('   يمكنك تشغيل: firebase login');
    }
  }
  
  console.log('\n✨ انتهى السكريپت!');
  process.exit(0);
}

// Run the update
updateAllProductsStock().catch(console.error);