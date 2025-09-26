// سكريبت إضافة صور Amazon للمنتجات الجديدة
import admin from 'firebase-admin';
import { readFileSync } from 'fs';

// قراءة ملف المفاتيح
const serviceAccount = JSON.parse(readFileSync('./serviceAccountKey.json', 'utf8'));

// تهيئة Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://gizmo-store-default-rtdb.firebaseio.com"
  });
}

const db = admin.firestore();

// روابط صور Amazon للفئات المختلفة
const categoryImages = {
  'الهواتف الذكية': [
    'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71GLMJ7TQiL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/61BWJQzKGNL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71cSV-RTBSL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71ZDY7YNHUL._AC_SL1500_.jpg'
  ],
  'الإكسسوارات': [
    'https://m.media-amazon.com/images/I/61Ks8nAJBuL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71YQrYKXSgL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/61ZjlBOp+QL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71K8nAJBuL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/61YQrYKXSgL._AC_SL1500_.jpg'
  ],
  'أجهزة الكمبيوتر المكتبية': [
    'https://m.media-amazon.com/images/I/81Fm0tRFdHL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71QN5JbakzL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/81Fm0tRFdHL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71QN5JbakzL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/81Fm0tRFdHL._AC_SL1500_.jpg'
  ],
  'سماعات الرأس': [
    'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71o8Q5XJS5L._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71o8Q5XJS5L._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg'
  ],
  'الكاميرات': [
    'https://m.media-amazon.com/images/I/81fA9YDKI7L._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71Swbp-B3jL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/81fA9YDKI7L._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71Swbp-B3jL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/81fA9YDKI7L._AC_SL1500_.jpg'
  ],
  'الأجهزة اللوحية': [
    'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg'
  ],
  'أجهزة الكمبيوتر المحمولة': [
    'https://m.media-amazon.com/images/I/71vvXGmdKWL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/81bc8mFhqKL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71vvXGmdKWL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/81bc8mFhqKL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71vvXGmdKWL._AC_SL1500_.jpg'
  ],
  'الساعات الذكية': [
    'https://m.media-amazon.com/images/I/71ZqQ3mKlwL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/61BVJqJGBpL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71ZqQ3mKlwL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/61BVJqJGBpL._AC_SL1500_.jpg',
    'https://m.media-amazon.com/images/I/71ZqQ3mKlwL._AC_SL1500_.jpg'
  ]
};

// دالة لاختيار صورة عشوائية من فئة معينة
function getRandomImageForCategory(category) {
  const images = categoryImages[category];
  if (!images || images.length === 0) {
    return 'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg'; // صورة افتراضية
  }
  return images[Math.floor(Math.random() * images.length)];
}

// دالة لإضافة الصور للمنتجات
async function addImagesToProducts() {
  try {
    console.log('🖼️ بدء إضافة الصور للمنتجات...');
    
    // جلب جميع المنتجات التي لا تحتوي على صور
    const productsSnapshot = await db.collection('products')
      .where('imageUrl', '==', '')
      .get();
    
    if (productsSnapshot.empty) {
      console.log('✅ جميع المنتجات تحتوي على صور بالفعل');
      return;
    }
    
    console.log(`📦 تم العثور على ${productsSnapshot.size} منتج بدون صور`);
    
    const batch = db.batch();
    let updateCount = 0;
    
    productsSnapshot.forEach((doc) => {
      const product = doc.data();
      const imageUrl = getRandomImageForCategory(product.category);
      
      batch.update(doc.ref, { imageUrl: imageUrl });
      updateCount++;
      
      if (updateCount % 50 === 0) {
        console.log(`✅ تم تحديث ${updateCount} منتج`);
      }
    });
    
    // تنفيذ التحديثات
    await batch.commit();
    
    console.log(`🎉 تم إضافة الصور لـ ${updateCount} منتج بنجاح!`);
    
    // التحقق من النتيجة النهائية
    const finalSnapshot = await db.collection('products').get();
    const productsWithImages = finalSnapshot.docs.filter(doc => doc.data().imageUrl && doc.data().imageUrl !== '').length;
    const productsWithoutImages = finalSnapshot.docs.filter(doc => !doc.data().imageUrl || doc.data().imageUrl === '').length;
    
    console.log(`📊 النتيجة النهائية:`);
    console.log(`✅ منتجات لها صور: ${productsWithImages}`);
    console.log(`❌ منتجات بدون صور: ${productsWithoutImages}`);
    
  } catch (error) {
    console.error('❌ خطأ في إضافة الصور:', error);
  }
}

// تشغيل الدالة
addImagesToProducts()
  .then(() => {
    console.log('✅ تم الانتهاء من إضافة الصور');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ خطأ:', error);
    process.exit(1);
  });