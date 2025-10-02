// إصلاح الصورة الأخيرة المعطلة
import { initializeApp } from 'firebase/app';
import { getFirestore, doc, updateDoc } from 'firebase/firestore';

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

async function fixAnkerPowerbank() {
  try {
    console.log('🔧 إصلاح صورة Anker PowerCore 10000...');
    
    // صورة بديلة مختلفة لبنك الطاقة
    const newImageUrl = 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500&h=500&fit=crop&crop=center';
    
    console.log(`📷 الصورة الجديدة: ${newImageUrl}`);
    
    // تحديث المنتج في قاعدة البيانات
    const productRef = doc(db, 'products', 'anker-powerbank');
    await updateDoc(productRef, {
      imageUrl: newImageUrl
    });
    
    console.log('✅ تم إصلاح صورة Anker PowerCore 10000 بنجاح!');
    
  } catch (error) {
    console.error('❌ خطأ في إصلاح الصورة:', error);
  }
}

fixAnkerPowerbank();