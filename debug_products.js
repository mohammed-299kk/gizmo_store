// سكريبت لفحص بنية البيانات الفعلية
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs } from 'firebase/firestore';

// إعدادات Firebase
const firebaseConfig = {
  apiKey: "AIzaSyBJGJJGJJGJJGJJGJJGJJGJJGJJGJJGJJG",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  projectId: "gizmostore-2a3ff",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdefghijklmnop"
};

// تهيئة Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

async function debugProducts() {
  try {
    console.log('🔍 فحص بنية البيانات الفعلية...\n');
    
    const productsRef = collection(db, 'products');
    const snapshot = await getDocs(productsRef);
    
    if (snapshot.empty) {
      console.log('❌ لا توجد منتجات في قاعدة البيانات');
      return;
    }
    
    console.log(`📦 تم العثور على ${snapshot.size} منتج\n`);
    
    // فحص أول 3 منتجات بالتفصيل
    let count = 0;
    snapshot.forEach((doc) => {
      if (count < 3) {
        console.log(`📋 المنتج ${count + 1}:`);
        console.log(`   ID: ${doc.id}`);
        console.log(`   البيانات الكاملة:`, JSON.stringify(doc.data(), null, 2));
        console.log('   =====================================\n');
        count++;
      }
    });
    
    // إحصائيات الحقول
    const fieldStats = {};
    snapshot.forEach((doc) => {
      const data = doc.data();
      Object.keys(data).forEach(field => {
        if (!fieldStats[field]) {
          fieldStats[field] = 0;
        }
        fieldStats[field]++;
      });
    });
    
    console.log('📊 إحصائيات الحقول:');
    console.log('==================');
    Object.entries(fieldStats).forEach(([field, count]) => {
      console.log(`${field}: ${count} منتج`);
    });
    
    console.log('\n✅ تم الانتهاء من فحص البيانات');
    
  } catch (error) {
    console.error('❌ خطأ في فحص البيانات:', error);
  }
}

debugProducts();