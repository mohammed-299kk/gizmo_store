// تحديث جميع المنتجات بروابط صور Amazon من ملف figma-design
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, doc, updateDoc, query, where } from 'firebase/firestore';

// إعداد Firebase
const firebaseConfig = {
  apiKey: 'AIzaSyAo4-Ge1dC4LnIyG_wUjYgWc9KHCxEYUxM',
  authDomain: 'gizmostore-2a3ff.firebaseapp.com',
  projectId: 'gizmostore-2a3ff',
  storageBucket: 'gizmostore-2a3ff.firebasestorage.app',
  messagingSenderId: '32902740595',
  appId: '1:32902740595:web:7de8f1273a64f9f28fc806',
  measurementId: 'G-WF0Z8EKYMX'
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// روابط صور Amazon للمنتجات
const productImages = {
  // سماعات
  'Sony WH-1000XM5': 'https://m.media-amazon.com/images/I/61+btTBs5jL._AC_SL1500_.jpg',
  'Bose QuietComfort 45': 'https://m.media-amazon.com/images/I/51JKhGKGNjL._AC_SL1500_.jpg',
  'Sennheiser Momentum 4': 'https://m.media-amazon.com/images/I/61Ks8RNBDOL._AC_SL1500_.jpg',
  'Audio-Technica ATH-M50xBT2': 'https://m.media-amazon.com/images/I/61Ks8RNBDOL._AC_SL1500_.jpg',
  'Marshall Major IV': 'https://m.media-amazon.com/images/I/61Ks8RNBDOL._AC_SL1500_.jpg',
  'Anker Soundcore Life Q30': 'https://m.media-amazon.com/images/I/61Ks8RNBDOL._AC_SL1500_.jpg',
  'HyperX Cloud Alpha': 'https://m.media-amazon.com/images/I/61Ks8RNBDOL._AC_SL1500_.jpg',

  // أجهزة لابتوب (Laptops)
  'Dell XPS 13 Plus': 'https://m.media-amazon.com/images/I/61VQxRxEcQL._AC_SL1500_.jpg',
  'Lenovo ThinkPad X1 Carbon': 'https://m.media-amazon.com/images/I/61jTIIqpxBL._AC_SL1500_.jpg',
  'ASUS ZenBook 14': 'https://m.media-amazon.com/images/I/61EADK3YGOL._AC_SL1500_.jpg',
  'Microsoft Surface Laptop 5': 'https://m.media-amazon.com/images/I/61VQxRxEcQL._AC_SL1500_.jpg',
  'Acer Predator Helios 300': 'https://m.media-amazon.com/images/I/71QKqZqK2bL._AC_SL1500_.jpg',
  'ASUS ROG Strix G15': 'https://m.media-amazon.com/images/I/61jTIIqpxBL._AC_SL1500_.jpg',

  // هواتف ذكية (Smartphones)
  'iPhone 15 Pro Max': 'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg',
  'Samsung Galaxy A54': 'https://m.media-amazon.com/images/I/71gm8v4uPBL._AC_SL1500_.jpg',
  'Google Pixel 8 Pro': 'https://m.media-amazon.com/images/I/61VQxRxEcQL._AC_SL1500_.jpg',
  'Xiaomi 14 Ultra': 'https://m.media-amazon.com/images/I/71QKqZqK2bL._AC_SL1500_.jpg',
  'Motorola Edge 40 Pro': 'https://m.media-amazon.com/images/I/61VQxRxEcQL._AC_SL1500_.jpg',

  // أجهزة لوحية (Tablets)
  'iPad Pro 12.9" M4': 'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
  'Samsung Galaxy Tab S9 Ultra': 'https://m.media-amazon.com/images/I/71gm8v4uPBL._AC_SL1500_.jpg',
  'Microsoft Surface Pro 10': 'https://m.media-amazon.com/images/I/61VQxRxEcQL._AC_SL1500_.jpg',

  // ساعات ذكية (Smartwatches)
  'Apple Watch Series 10': 'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
  'Samsung Galaxy Watch7': 'https://m.media-amazon.com/images/I/71gm8v4uPBL._AC_SL1500_.jpg',
  'Garmin Fenix 8': 'https://m.media-amazon.com/images/I/61VQxRxEcQL._AC_SL1500_.jpg',

  // أجهزة تلفاز (TVs)
  'Samsung Neo QLED QN95C 65"': 'https://m.media-amazon.com/images/I/81AEmqydk8L._AC_SL1500_.jpg',
  'LG C3 OLED 55"': 'https://m.media-amazon.com/images/I/91L9EFaFsZL._AC_SL1500_.jpg',
  'TCL C845 Mini LED 55"': 'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg',
  'Hisense U8K 65"': 'https://m.media-amazon.com/images/I/81ZVaRsFVyL._AC_SL1500_.jpg',
  'Samsung Frame TV 55"': 'https://m.media-amazon.com/images/I/91EBBJN6cUL._AC_SL1500_.jpg',
  'Xiaomi TV A2 43"': 'https://m.media-amazon.com/images/I/71r1+2M0sDL._AC_SL1500_.jpg',
  'Roku TV 50"': 'https://m.media-amazon.com/images/I/81nj5Tg3YJL._AC_SL1500_.jpg'
};

// دالة لتحديث منتج واحد
async function updateProductImages(productName) {
  try {
    const imageUrl = productImages[productName];
    if (!imageUrl) {
      console.log(`⚠️ لا توجد صور Amazon للمنتج: ${productName}`);
      return false;
    }

    // البحث عن المنتج في قاعدة البيانات
    const querySnapshot = await getDocs(query(
      collection(db, 'products'),
      where('name', '==', productName)
    ));

    if (querySnapshot.empty) {
      console.log(`❌ لم يتم العثور على المنتج: ${productName}`);
      return false;
    }

    // تحديث كل مستند يطابق الاسم
    const updatePromises = [];
    querySnapshot.forEach(docSnapshot => {
      const updateData = {
        image: imageUrl,
        images: [imageUrl], // تحويل الرابط الواحد إلى مصفوفة
        updatedAt: new Date()
      };
      updatePromises.push(updateDoc(doc(db, 'products', docSnapshot.id), updateData));
    });

    await Promise.all(updatePromises);
    console.log(`✅ تم تحديث صور المنتج: ${productName}`);
    return true;
  } catch (error) {
    console.error(`❌ خطأ في تحديث المنتج ${productName}:`, error);
    return false;
  }
}

// دالة رئيسية لتحديث جميع المنتجات
async function updateAllProducts() {
  try {
    console.log('🚀 بدء تحديث جميع المنتجات بصور Amazon...');
    
    const productNames = Object.keys(productImages);
    console.log(`📦 سيتم تحديث ${productNames.length} منتج`);
    
    let successCount = 0;
    let failureCount = 0;
    
    for (const productName of productNames) {
      console.log(`\n🔄 معالجة المنتج: ${productName}`);
      
      const success = await updateProductImages(productName);
      if (success) {
        successCount++;
      } else {
        failureCount++;
      }
      
      // انتظار قصير بين التحديثات لتجنب الضغط على قاعدة البيانات
      await new Promise(resolve => setTimeout(resolve, 100));
    }
    
    console.log('\n📊 ملخص النتائج:');
    console.log(`✅ تم تحديث ${successCount} منتج بنجاح`);
    console.log(`❌ فشل في تحديث ${failureCount} منتج`);
    console.log('🎉 انتهى تحديث جميع المنتجات!');
    
  } catch (error) {
    console.error('❌ خطأ في العملية الرئيسية:', error);
  }
}

// تشغيل السكريبت
updateAllProducts();