const admin = require('firebase-admin');

// Initialize Firebase Admin
const serviceAccount = {
  "type": "service_account",
  "project_id": "gizmo-store-2024",
  "private_key_id": "your-private-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-xxxxx@gizmo-store-2024.iam.gserviceaccount.com",
  "client_id": "your-client-id",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-xxxxx%40gizmo-store-2024.iam.gserviceaccount.com"
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://gizmo-store-2024-default-rtdb.firebaseio.com"
});

const db = admin.firestore();

async function updateStockAvailability() {
  console.log('🚀 بدء تحديث حالة المخزون للمنتجات...');
  
  try {
    // Get all products
    console.log('📦 جلب جميع المنتجات...');
    const snapshot = await db.collection('products').get();
    
    console.log(`📊 تم العثور على ${snapshot.size} منتج`);
    
    let updatedCount = 0;
    let errorCount = 0;
    
    // Process products in batches
    const batch = db.batch();
    let batchCount = 0;
    const BATCH_SIZE = 500;
    
    for (const doc of snapshot.docs) {
      try {
        const data = doc.data();
        const productName = data.name || 'منتج غير معروف';
        const currentStock = data.stock || data.stockQuantity || 0;
        const isAvailable = data.isAvailable || false;
        
        console.log(`🔄 تحديث المنتج: ${productName}`);
        console.log(`   المخزون الحالي: ${currentStock}`);
        console.log(`   متوفر حالياً: ${isAvailable}`);
        
        // Determine new stock quantity based on current stock
        let newStock;
        if (currentStock <= 0) {
          newStock = 25; // Default stock for out-of-stock items
        } else if (currentStock < 10) {
          newStock = currentStock + 20; // Add 20 to low stock items
        } else {
          newStock = currentStock; // Keep current stock if adequate
        }
        
        // Add update to batch
        batch.update(doc.ref, {
          stock: newStock,
          stockQuantity: newStock, // For compatibility
          isAvailable: true,
          inStock: true, // For compatibility
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        
        console.log(`   ✅ سيتم التحديث - المخزون الجديد: ${newStock}`);
        updatedCount++;
        batchCount++;
        
        // Commit batch when it reaches the limit
        if (batchCount >= BATCH_SIZE) {
          console.log(`💾 تنفيذ دفعة من ${batchCount} منتج...`);
          await batch.commit();
          batchCount = 0;
        }
        
      } catch (e) {
        console.log(`   ❌ خطأ في تحديث المنتج: ${e.message}`);
        errorCount++;
      }
    }
    
    // Commit remaining updates
    if (batchCount > 0) {
      console.log(`💾 تنفيذ الدفعة الأخيرة من ${batchCount} منتج...`);
      await batch.commit();
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
      const isAvailable = data.isAvailable || false;
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
    process.exit(1);
  }
  
  console.log('\n✨ انتهى السكريبت بنجاح!');
  process.exit(0);
}

// Run the update
updateStockAvailability();