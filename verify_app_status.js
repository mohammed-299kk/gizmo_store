// سكريبت للتحقق من حالة التطبيق والمنتجات
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, query, where } from 'firebase/firestore';

// إعدادات Firebase (نفس إعدادات التطبيق)
const firebaseConfig = {
  apiKey: 'AIzaSyAo4-Ge1dC4LnIyG_wUjYgWc9KHCxEYUxM',
  appId: '1:32902740595:web:7de8f1273a64f9f28fc806',
  messagingSenderId: '32902740595',
  projectId: 'gizmostore-2a3ff',
  authDomain: 'gizmostore-2a3ff.firebaseapp.com',
  storageBucket: 'gizmostore-2a3ff.firebasestorage.app',
  measurementId: 'G-WF0Z8EKYMX',
};

// تهيئة Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function verifyAppStatus() {
  try {
    console.log('🔍 التحقق من حالة التطبيق...');
    console.log('📱 معرف المشروع:', firebaseConfig.projectId);
    console.log('🌐 نطاق المصادقة:', firebaseConfig.authDomain);
    
    // التحقق من الاتصال بـ Firestore
    console.log('\n🔗 اختبار الاتصال بـ Firestore...');
    const testCollection = collection(db, 'products');
    const snapshot = await getDocs(testCollection);
    
    if (snapshot.empty) {
      console.log('❌ لا توجد منتجات في قاعدة البيانات');
      return;
    }
    
    console.log('✅ تم الاتصال بـ Firestore بنجاح');
    console.log(`📦 عدد المنتجات: ${snapshot.size}`);
    
    // البحث عن Google Pixel 8
    console.log('\n🔍 البحث عن Google Pixel 8...');
    const pixelQuery = query(testCollection, where('id', '==', 'google-pixel-8'));
    const pixelSnapshot = await getDocs(pixelQuery);
    
    if (pixelSnapshot.empty) {
      console.log('❌ لم يتم العثور على Google Pixel 8');
    } else {
      console.log('✅ تم العثور على Google Pixel 8!');
      pixelSnapshot.forEach((doc) => {
        const data = doc.data();
        console.log(`  📱 الاسم: ${data.name}`);
        console.log(`  💰 السعر: $${data.price}`);
        console.log(`  📷 الصورة: ${data.imageUrl}`);
        console.log(`  📊 التقييم: ${data.rating}/5`);
      });
    }
    
    // عرض جميع المنتجات
    console.log('\n📋 قائمة جميع المنتجات:');
    snapshot.forEach((doc, index) => {
      const data = doc.data();
      console.log(`${index + 1}. ${data.name || data.nameAr} (${data.id || doc.id})`);
      console.log(`   💰 السعر: $${data.price}`);
      console.log(`   📂 الفئة: ${data.categoryAr || data.category}`);
      console.log(`   📷 الصورة: ${data.imageUrl ? '✅' : '❌'}`);
      console.log('');
    });
    
    // إحصائيات الفئات
    console.log('📊 إحصائيات الفئات:');
    const categories = {};
    snapshot.forEach((doc) => {
      const data = doc.data();
      const category = data.categoryAr || data.category || 'غير محدد';
      categories[category] = (categories[category] || 0) + 1;
    });
    
    Object.entries(categories).forEach(([category, count]) => {
      console.log(`  📂 ${category}: ${count} منتج`);
    });
    
    // التحقق من الصور
    console.log('\n📷 حالة الصور:');
    let imagesWithUrl = 0;
    let imagesWithoutUrl = 0;
    
    snapshot.forEach((doc) => {
      const data = doc.data();
      if (data.imageUrl && data.imageUrl.trim() !== '') {
        imagesWithUrl++;
      } else {
        imagesWithoutUrl++;
        console.log(`  ❌ بدون صورة: ${data.name || data.nameAr}`);
      }
    });
    
    console.log(`  ✅ منتجات بصور: ${imagesWithUrl}`);
    console.log(`  ❌ منتجات بدون صور: ${imagesWithoutUrl}`);
    
    console.log('\n🎉 تم إكمال التحقق بنجاح!');
    
  } catch (error) {
    console.error('❌ خطأ في التحقق من حالة التطبيق:', error);
    console.error('تفاصيل الخطأ:', error.message);
  }
}

verifyAppStatus();