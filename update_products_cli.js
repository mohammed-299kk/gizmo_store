import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, doc, updateDoc, serverTimestamp } from 'firebase/firestore';

// إعدادات Firebase
const firebaseConfig = {
  apiKey: "AIzaSyBvOkBH0ImLHeiX0rOdyfLOknOw7VFIWKM",
  appId: "1:237882168823:web:b8c18e1e7c8a9c6c7b9c5a",
  messagingSenderId: "237882168823",
  projectId: "gizmostore-2a3ff",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  measurementId: "G-HNLGZQKJQX"
};

// تهيئة Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// صور المنتجات المحددة
const productImages = {
  'iphone-15-pro': 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=500&h=500&fit=crop&crop=center',
  'samsung-galaxy-s24': 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500&h=500&fit=crop&crop=center',
  'google-pixel-8': 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=500&h=500&fit=crop&crop=center',
  'macbook-pro-m3': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&h=500&fit=crop&crop=center',
  'dell-xps-13': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop&crop=center',
  'hp-spectre-x360': 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500&h=500&fit=crop&crop=center',
  'ipad-pro-12': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop&crop=center',
  'samsung-tab-s9': 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=500&h=500&fit=crop&crop=center',
  'apple-watch-series-9': 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=500&h=500&fit=crop&crop=center',
  'samsung-galaxy-watch-6': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop&crop=center',
  'airpods-pro-2': 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=500&h=500&fit=crop&crop=center',
  'sony-wh-1000xm5': 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500&h=500&fit=crop&crop=center',
  'bose-qc45': 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500&h=500&fit=crop&crop=center',
  'anker-powerbank': 'https://images.unsplash.com/photo-1609592806596-b5c2b1e6e1a7?w=500&h=500&fit=crop&crop=center',
  'belkin-wireless-charger': 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=500&h=500&fit=crop&crop=center',
  'spigen-phone-case': 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500&h=500&fit=crop&crop=center',
  'ugreen-usb-hub': 'https://images.unsplash.com/photo-1625842268584-8f3296236761?w=500&h=500&fit=crop&crop=center'
};

// صور افتراضية حسب الفئة
const categoryImages = {
  smartphones: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop&crop=center',
  laptops: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop&crop=center',
  tablets: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop&crop=center',
  smartwatches: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=500&h=500&fit=crop&crop=center',
  headphones: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500&h=500&fit=crop&crop=center',
  accessories: 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500&h=500&fit=crop&crop=center'
};

async function updateProductInDatabase(productId, imageUrl) {
  try {
    const productRef = doc(db, 'products', productId);
    await updateDoc(productRef, {
      imageUrl: imageUrl,
      updatedAt: serverTimestamp()
    });
    console.log(`✅ تم تحديث المنتج ${productId} بنجاح`);
    return true;
  } catch (error) {
    console.error(`❌ خطأ في تحديث قاعدة البيانات للمنتج ${productId}:`, error.message);
    return false;
  }
}

async function processAllProducts() {
  try {
    console.log('🚀 بدء معالجة المنتجات...\n');
    
    const productsSnapshot = await getDocs(collection(db, 'products'));
    const products = [];
    
    productsSnapshot.forEach(doc => {
      products.push({
        id: doc.id,
        ...doc.data()
      });
    });

    console.log(`📦 تم العثور على ${products.length} منتج\n`);

    let successCount = 0;
    
    for (const product of products) {
      console.log(`🔄 معالجة المنتج: ${product.name} (${product.category})`);
      
      let imageUrl;
      
      // التحقق من وجود صورة محددة للمنتج
      if (productImages[product.id]) {
        imageUrl = productImages[product.id];
        console.log('🎯 استخدام صورة محددة للمنتج');
      } else {
        // استخدام صورة افتراضية حسب الفئة
        imageUrl = categoryImages[product.category] || categoryImages.accessories;
        console.log('📂 استخدام صورة افتراضية للفئة');
      }
      
      const success = await updateProductInDatabase(product.id, imageUrl);
      if (success) {
        successCount++;
      }
      
      console.log(''); // سطر فارغ للتنسيق
    }
    
    console.log('📊 ملخص العملية:');
    console.log('==================');
    console.log(`📦 إجمالي المنتجات: ${products.length}`);
    console.log(`✅ المنتجات المحدثة: ${successCount}`);
    console.log(`📈 معدل النجاح: ${((successCount / products.length) * 100).toFixed(1)}%`);
    console.log('\n🎉 تم الانتهاء من معالجة جميع المنتجات!');
    
  } catch (error) {
    console.error('❌ خطأ في معالجة المنتجات:', error);
  }
}

// تشغيل السكريبت
processAllProducts().then(() => {
  process.exit(0);
}).catch(error => {
  console.error('❌ خطأ عام:', error);
  process.exit(1);
});