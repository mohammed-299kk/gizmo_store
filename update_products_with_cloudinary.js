import admin from 'firebase-admin';

// Initialize Firebase Admin
admin.initializeApp({
  projectId: 'gizmostore-2a3ff'
});

const db = admin.firestore();

// روابط Cloudinary جاهزة للمنتجات
const cloudinaryImages = {
  // هواتف ذكية
  'iPhone 15 Pro Max': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone_15_pro_max_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone_15_pro_max_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone_15_pro_max_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone_15_pro_max_3.jpg'
    ]
  },
  'Samsung Galaxy S24 Ultra': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/samsung_galaxy_s24_ultra_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/samsung_galaxy_s24_ultra_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/samsung_galaxy_s24_ultra_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/samsung_galaxy_s24_ultra_3.jpg'
    ]
  },
  'Google Pixel 8 Pro': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/google_pixel_8_pro_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/google_pixel_8_pro_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/google_pixel_8_pro_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/google_pixel_8_pro_3.jpg'
    ]
  },
  'OnePlus 12': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/oneplus_12_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/oneplus_12_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/oneplus_12_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/oneplus_12_3.jpg'
    ]
  },
  'Xiaomi 14 Ultra': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/xiaomi_14_ultra_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/xiaomi_14_ultra_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/xiaomi_14_ultra_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/xiaomi_14_ultra_3.jpg'
    ]
  },
  
  // أجهزة لابتوب
  'MacBook Pro M3': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/macbook_pro_m3_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/macbook_pro_m3_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/macbook_pro_m3_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/macbook_pro_m3_3.jpg'
    ]
  },
  'Dell XPS 13': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/dell_xps_13_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/dell_xps_13_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/dell_xps_13_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/dell_xps_13_3.jpg'
    ]
  },
  'HP Spectre x360': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/hp_spectre_x360_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/hp_spectre_x360_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/hp_spectre_x360_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/hp_spectre_x360_3.jpg'
    ]
  },
  
  // سماعات
  'AirPods Pro 2': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/airpods_pro_2_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/airpods_pro_2_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/airpods_pro_2_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/airpods_pro_2_3.jpg'
    ]
  },
  'Sony WH-1000XM5': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sony_wh_1000xm5_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sony_wh_1000xm5_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sony_wh_1000xm5_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sony_wh_1000xm5_3.jpg'
    ]
  },
  
  // ساعات ذكية
  'Apple Watch Series 9': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/apple_watch_series_9_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/apple_watch_series_9_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/apple_watch_series_9_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/apple_watch_series_9_3.jpg'
    ]
  },
  'Samsung Galaxy Watch 6': {
    image: 'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/samsung_galaxy_watch_6_main.jpg',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/samsung_galaxy_watch_6_1.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/samsung_galaxy_watch_6_2.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/samsung_galaxy_watch_6_3.jpg'
    ]
  }
};

// دالة لتحديث منتج واحد
async function updateProductImages(productName) {
  try {
    const imageData = cloudinaryImages[productName];
    if (!imageData) {
      console.log(`⚠️ لا توجد صور Cloudinary للمنتج: ${productName}`);
      return false;
    }

    // البحث عن المنتج في قاعدة البيانات
    const querySnapshot = await db.collection('products')
      .where('name', '==', productName)
      .get();

    if (querySnapshot.empty) {
      console.log(`❌ لم يتم العثور على المنتج: ${productName}`);
      return false;
    }

    // تحديث كل مستند يطابق الاسم
    const batch = db.batch();
    querySnapshot.forEach(doc => {
      batch.update(doc.ref, {
        image: imageData.image,
        images: imageData.images
      });
    });

    await batch.commit();
    console.log(`✅ تم تحديث صور المنتج: ${productName}`);
    return true;
  } catch (error) {
    console.error(`❌ خطأ في تحديث المنتج ${productName}:`, error);
    return false;
  }
}

// دالة لتحديث جميع المنتجات
async function updateAllProducts() {
  console.log('🚀 بدء تحديث جميع المنتجات بروابط Cloudinary...');
  
  let successCount = 0;
  let totalCount = Object.keys(cloudinaryImages).length;
  
  for (const productName of Object.keys(cloudinaryImages)) {
    const success = await updateProductImages(productName);
    if (success) {
      successCount++;
    }
    
    // انتظار قصير بين التحديثات
    await new Promise(resolve => setTimeout(resolve, 500));
  }
  
  console.log(`✅ تم تحديث ${successCount} من ${totalCount} منتج بنجاح`);
  
  if (successCount === totalCount) {
    console.log('🎉 تم تحديث جميع المنتجات بنجاح!');
  } else {
    console.log(`⚠️ فشل في تحديث ${totalCount - successCount} منتج`);
  }
}

// تشغيل التحديث إذا تم استدعاء الملف مباشرة
if (import.meta.url === `file://${process.argv[1]}`) {
  updateAllProducts()
    .then(() => {
      console.log('انتهى التحديث');
      process.exit(0);
    })
    .catch(error => {
      console.error('خطأ في التحديث:', error);
      process.exit(1);
    });
}

export {
  updateProductImages,
  updateAllProducts,
  cloudinaryImages
};