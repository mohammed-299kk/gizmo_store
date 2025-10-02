import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, limit, query } from 'firebase/firestore';

// Firebase config
const firebaseConfig = {
  apiKey: "AIzaSyBGVJKJJKJKJKJKJKJKJKJKJKJKJKJKJKJ",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  projectId: "gizmostore-2a3ff",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  messagingSenderId: "32902740595",
  appId: "1:32902740595:web:7de8f1273a64f9f28fc806"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function checkProductImages() {
  try {
    console.log('جاري التحقق من صور المنتجات...');
    
    const q = query(collection(db, 'products'), limit(5));
    const querySnapshot = await getDocs(q);
    
    console.log(`عدد المنتجات: ${querySnapshot.size}`);
    
    querySnapshot.forEach((doc) => {
      const data = doc.data();
      console.log('\n--- منتج:', data.name || 'بدون اسم');
      console.log('رابط الصورة:', data.imageUrl || 'لا يوجد رابط');
      
      if (data.imageUrl) {
        console.log('نوع الرابط:', typeof data.imageUrl);
        console.log('يبدأ بـ http:', data.imageUrl.startsWith('http'));
        console.log('طول الرابط:', data.imageUrl.length);
      }
    });
    
  } catch (error) {
    console.error('خطأ في التحقق من الصور:', error);
  }
}

checkProductImages();