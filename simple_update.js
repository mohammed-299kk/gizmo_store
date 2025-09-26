import admin from 'firebase-admin';

// Initialize Firebase Admin
admin.initializeApp({
  projectId: 'gizmostore-2a3ff'
});

const db = admin.firestore();

console.log('🚀 بدء تحديث المنتجات...');

// تحديث منتج واحد كمثال
async function updateSingleProduct() {
  try {
    const productName = 'iPhone 15 Pro Max';
    const newImageUrl = 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone_15_pro_max_main.jpg';
    const newImages = [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone_15_pro_max_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone_15_pro_max_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone_15_pro_max_3.jpg'
    ];

    console.log(`البحث عن المنتج: ${productName}`);
    
    const querySnapshot = await db.collection('products')
      .where('name', '==', productName)
      .get();

    if (querySnapshot.empty) {
      console.log(`❌ لم يتم العثور على المنتج: ${productName}`);
      return;
    }

    console.log(`✅ تم العثور على ${querySnapshot.size} منتج`);

    const batch = db.batch();
    querySnapshot.forEach(doc => {
      console.log(`تحديث المنتج ID: ${doc.id}`);
      batch.update(doc.ref, {
        image: newImageUrl,
        images: newImages
      });
    });

    await batch.commit();
    console.log(`✅ تم تحديث صور المنتج: ${productName}`);
    
  } catch (error) {
    console.error('❌ خطأ في التحديث:', error);
  }
}

updateSingleProduct()
  .then(() => {
    console.log('انتهى التحديث');
    process.exit(0);
  })
  .catch(error => {
    console.error('خطأ:', error);
    process.exit(1);
  });