// سكريبت للتحقق من حالة صور المنتجات
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs } from 'firebase/firestore';
import fetch from 'node-fetch';

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

async function checkImageUrl(url) {
  try {
    const response = await fetch(url, { method: 'HEAD' });
    return {
      status: response.status,
      ok: response.ok,
      contentType: response.headers.get('content-type')
    };
  } catch (error) {
    return {
      status: 'ERROR',
      ok: false,
      error: error.message
    };
  }
}

async function checkAllProductImages() {
  try {
    console.log('🔍 فحص حالة صور جميع المنتجات...\n');
    
    const productsCollection = collection(db, 'products');
    const snapshot = await getDocs(productsCollection);
    
    if (snapshot.empty) {
      console.log('❌ لا توجد منتجات في قاعدة البيانات');
      return;
    }
    
    console.log(`📦 عدد المنتجات: ${snapshot.size}\n`);
    
    let workingImages = 0;
    let brokenImages = 0;
    const brokenProducts = [];
    
    for (const doc of snapshot.docs) {
      const data = doc.data();
      const productName = data.name || data.nameAr || doc.id;
      const imageUrl = data.imageUrl;
      
      console.log(`🔍 فحص: ${productName}`);
      console.log(`   🔗 الرابط: ${imageUrl}`);
      
      if (!imageUrl || imageUrl.trim() === '') {
        console.log('   ❌ لا يوجد رابط صورة');
        brokenImages++;
        brokenProducts.push({
          id: doc.id,
          name: productName,
          issue: 'لا يوجد رابط صورة'
        });
        continue;
      }
      
      const result = await checkImageUrl(imageUrl);
      
      if (result.ok) {
        console.log(`   ✅ الصورة تعمل (${result.status})`);
        workingImages++;
      } else {
        console.log(`   ❌ الصورة لا تعمل (${result.status || result.error})`);
        brokenImages++;
        brokenProducts.push({
          id: doc.id,
          name: productName,
          imageUrl: imageUrl,
          issue: `خطأ ${result.status || result.error}`
        });
      }
      
      console.log(''); // سطر فارغ
      
      // تأخير قصير لتجنب الضغط على الخادم
      await new Promise(resolve => setTimeout(resolve, 500));
    }
    
    console.log('📊 ملخص النتائج:');
    console.log(`✅ صور تعمل: ${workingImages}`);
    console.log(`❌ صور معطلة: ${brokenImages}`);
    console.log(`📈 نسبة النجاح: ${((workingImages / snapshot.size) * 100).toFixed(1)}%\n`);
    
    if (brokenProducts.length > 0) {
      console.log('🚨 المنتجات التي تحتاج إصلاح:');
      brokenProducts.forEach((product, index) => {
        console.log(`${index + 1}. ${product.name} (${product.id})`);
        console.log(`   المشكلة: ${product.issue}`);
        if (product.imageUrl) {
          console.log(`   الرابط: ${product.imageUrl}`);
        }
        console.log('');
      });
    }
    
  } catch (error) {
    console.error('❌ خطأ في فحص الصور:', error);
  }
}

checkAllProductImages();