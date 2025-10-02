import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, doc, updateDoc } from 'firebase/firestore';

// إعداد Firebase
const firebaseConfig = {
  apiKey: "AIzaSyBGl7rHkP5nzQg5ShHa3NvjZONKOo5LHQY",
  appId: "1:1062701951007:web:a5b8fc2729fdc029dc1985",
  messagingSenderId: "1062701951007",
  projectId: "gizmostore-2a3ff",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  measurementId: "G-YGWN9QZPJL"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// صور عالية الجودة من Unsplash
const specificProductImages = {
  // هواتف ذكية
  'iPhone 15 Pro Max': 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800&h=800&fit=crop&crop=center',
  'Samsung Galaxy S24 Ultra': 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800&h=800&fit=crop&crop=center',
  'Google Pixel 8 Pro': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800&h=800&fit=crop&crop=center',
  'Samsung Galaxy S24': 'https://images.unsplash.com/photo-1567581935884-3349723552ca?w=800&h=800&fit=crop&crop=center',

  // أجهزة لابتوب
  'MacBook Pro M3': 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800&h=800&fit=crop&crop=center',
  'Dell XPS 13': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&h=800&fit=crop&crop=center',
  'HP Spectre x360': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&h=800&fit=crop&crop=center',

  // سماعات
  'AirPods Pro 2': 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=800&h=800&fit=crop&crop=center',
  'Sony WH-1000XM5': 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=800&h=800&fit=crop&crop=center',
  'Bose QuietComfort 45': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&h=800&fit=crop&crop=center',

  // ساعات ذكية
  'Apple Watch Series 9': 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=800&h=800&fit=crop&crop=center',
  'Samsung Galaxy Watch 6': 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=800&h=800&fit=crop&crop=center',

  // أجهزة لوحية
  'iPad Pro 12.9': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800&h=800&fit=crop&crop=center',
  'Samsung Galaxy Tab S9': 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=800&h=800&fit=crop&crop=center',

  // إكسسوارات
  'Wireless Charger': 'https://images.unsplash.com/photo-1609592806596-b43bada2e3c9?w=800&h=800&fit=crop&crop=center',
  'Phone Case': 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=800&h=800&fit=crop&crop=center',
  'Screen Protector': 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=800&h=800&fit=crop&crop=center',
  'USB-C Cable': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=800&fit=crop&crop=center',
  'MagSafe Charger': 'https://images.unsplash.com/photo-1609592806596-b43bada2e3c9?w=800&h=800&fit=crop&crop=center',
  'Spigen Tough Armor Case': 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=800&h=800&fit=crop&crop=center'
};

// صور افتراضية حسب الفئة
const categoryImages = {
  smartphones: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800&h=800&fit=crop&crop=center',
  laptops: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&h=800&fit=crop&crop=center',
  headphones: 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=800&h=800&fit=crop&crop=center',
  smartwatches: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=800&h=800&fit=crop&crop=center',
  tablets: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800&h=800&fit=crop&crop=center',
  accessories: 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=800&h=800&fit=crop&crop=center'
};

// دالة لتحديث قاعدة البيانات
async function updateProductInDatabase(productId, imageUrl) {
  try {
    const productRef = doc(db, 'products', productId);
    await updateDoc(productRef, {
      imageUrl: imageUrl
    });
    console.log(`✅ تم تحديث المنتج ${productId} برابط الصورة الجديد`);
    return true;
  } catch (error) {
    console.error(`❌ خطأ في تحديث قاعدة البيانات للمنتج ${productId}:`, error);
    return false;
  }
}

// دالة رئيسية لمعالجة جميع المنتجات
async function processAllProducts() {
  try {
    console.log('🚀 بدء معالجة المنتجات...');
    
    // الحصول على جميع المنتجات من قاعدة البيانات
    const productsRef = collection(db, 'products');
    const snapshot = await getDocs(productsRef);
    
    console.log(`📦 تم العثور على ${snapshot.size} منتج`);
    
    let updatedCount = 0;
    
    for (const docSnap of snapshot.docs) {
      const product = docSnap.data();
      const productId = docSnap.id;
      const productName = product.name;
      const productCategory = product.category;
      
      console.log(`\n🔄 معالجة المنتج: ${productName} (${productCategory})`);
      
      // تحديد الصورة المناسبة
      let imageUrl;
      
      // أولاً: البحث عن صورة محددة للمنتج
      if (specificProductImages[productName]) {
        imageUrl = specificProductImages[productName];
        console.log(`🎯 استخدام صورة محددة للمنتج`);
      }
      // ثانياً: استخدام صورة افتراضية حسب الفئة
      else if (categoryImages[productCategory]) {
        imageUrl = categoryImages[productCategory];
        console.log(`📂 استخدام صورة افتراضية للفئة: ${productCategory}`);
      }
      // ثالثاً: استخدام صورة افتراضية عامة
      else {
        imageUrl = 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=800&h=800&fit=crop&crop=center';
        console.log(`🔧 استخدام صورة افتراضية عامة`);
      }
      
      // تحديث قاعدة البيانات
      const success = await updateProductInDatabase(productId, imageUrl);
      if (success) {
        updatedCount++;
      }
      
      // انتظار قصير لتجنب تجاوز حدود API
      await new Promise(resolve => setTimeout(resolve, 500));
    }
    
    console.log(`\n📊 ملخص العملية:`);
    console.log(`==================`);
    console.log(`📦 إجمالي المنتجات: ${snapshot.size}`);
    console.log(`✅ المنتجات المحدثة: ${updatedCount}`);
    console.log(`📈 معدل النجاح: ${((updatedCount / snapshot.size) * 100).toFixed(1)}%`);
    console.log(`\n🎉 تم الانتهاء من معالجة جميع المنتجات!`);
    
  } catch (error) {
    console.error('❌ خطأ في معالجة المنتجات:', error);
  }
}

// تشغيل السكريبت
processAllProducts().catch(console.error);