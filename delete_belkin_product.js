// حذف منتج Belkin Car Mount من قاعدة البيانات
import { initializeApp } from 'firebase/app';
import { getFirestore, doc, deleteDoc, getDoc } from 'firebase/firestore';

// إعدادات Firebase
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

async function deleteBelkinProduct() {
  try {
    const productId = 'belkin-car-mount';
    
    console.log('🔍 البحث عن منتج Belkin Car Mount...');
    
    // التحقق من وجود المنتج أولاً
    const productRef = doc(db, 'products', productId);
    const productSnap = await getDoc(productRef);
    
    if (!productSnap.exists()) {
      console.log('❌ المنتج غير موجود في قاعدة البيانات');
      return;
    }
    
    const productData = productSnap.data();
    console.log('✅ تم العثور على المنتج:');
    console.log(`📱 الاسم: ${productData.name || productData.nameAr}`);
    console.log(`💰 السعر: ${productData.price}`);
    console.log(`🏷️ الفئة: ${productData.category}`);
    
    // حذف المنتج
    console.log('\n🗑️ جاري حذف المنتج...');
    await deleteDoc(productRef);
    
    console.log('✅ تم حذف منتج Belkin Car Mount بنجاح!');
    console.log('🎉 العملية مكتملة');
    
  } catch (error) {
    console.error('❌ خطأ في حذف المنتج:', error);
  }
}

deleteBelkinProduct();