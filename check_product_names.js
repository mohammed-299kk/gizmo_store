// فحص أسماء المنتجات في قاعدة البيانات
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs } from 'firebase/firestore';

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

async function checkProductNames() {
  try {
    console.log('🔍 فحص أسماء المنتجات في قاعدة البيانات...');
    
    const productsRef = collection(db, 'products');
    const snapshot = await getDocs(productsRef);
    
    console.log(`📊 إجمالي المنتجات: ${snapshot.size}`);
    console.log('\n📝 أسماء المنتجات:');
    
    snapshot.forEach((doc, index) => {
      const data = doc.data();
      console.log(`${index + 1}. ${data.name || data.title || 'بدون اسم'} (ID: ${doc.id})`);
    });
    
  } catch (error) {
    console.error('❌ خطأ في فحص المنتجات:', error);
  }
}

checkProductNames();