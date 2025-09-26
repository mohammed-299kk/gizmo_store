// سكريبت لإصلاح الصور المعطلة
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, doc, updateDoc, getDocs } from 'firebase/firestore';

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

// صور بديلة عالية الجودة من Unsplash
const imageReplacements = {
  'airpods-pro-2': 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=500&h=500&fit=crop&crop=center',
  'anker-powerbank': 'https://images.unsplash.com/photo-1609592806787-3d9c1b8e5e6e?w=500&h=500&fit=crop&crop=center',
  'belkin-car-mount': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500&h=500&fit=crop&crop=center',
  'ipad-pro-m2': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop&crop=center',
  'macbook-pro-m3': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&h=500&fit=crop&crop=center',
  'magsafe-charger': 'https://images.unsplash.com/photo-1621768216002-5ac171876625?w=500&h=500&fit=crop&crop=center',
  'samsung-tab-s9': 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=500&h=500&fit=crop&crop=center',
  'spigen-phone-case': 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500&h=500&fit=crop&crop=center'
};

async function fixBrokenImages() {
  try {
    console.log('🔧 بدء إصلاح الصور المعطلة...\n');
    
    const productsCollection = collection(db, 'products');
    const snapshot = await getDocs(productsCollection);
    
    let fixedCount = 0;
    let skippedCount = 0;
    
    for (const docSnapshot of snapshot.docs) {
      const productId = docSnapshot.id;
      const data = docSnapshot.data();
      const productName = data.name || data.nameAr || productId;
      
      // التحقق من وجود صورة بديلة لهذا المنتج
      if (imageReplacements[productId]) {
        const newImageUrl = imageReplacements[productId];
        
        console.log(`🔧 إصلاح: ${productName}`);
        console.log(`   📷 الصورة الجديدة: ${newImageUrl}`);
        
        try {
          // تحديث الصورة في قاعدة البيانات
          const productRef = doc(db, 'products', productId);
          await updateDoc(productRef, {
            imageUrl: newImageUrl
          });
          
          console.log(`   ✅ تم الإصلاح بنجاح`);
          fixedCount++;
          
        } catch (updateError) {
          console.log(`   ❌ فشل في التحديث: ${updateError.message}`);
        }
        
      } else {
        console.log(`⏭️  تخطي: ${productName} (لا توجد صورة بديلة)`);
        skippedCount++;
      }
      
      console.log(''); // سطر فارغ
      
      // تأخير قصير بين التحديثات
      await new Promise(resolve => setTimeout(resolve, 500));
    }
    
    console.log('📊 ملخص الإصلاح:');
    console.log(`✅ تم إصلاح: ${fixedCount} منتج`);
    console.log(`⏭️  تم تخطي: ${skippedCount} منتج`);
    console.log(`🎉 تم إكمال عملية الإصلاح!`);
    
  } catch (error) {
    console.error('❌ خطأ في إصلاح الصور:', error);
  }
}

fixBrokenImages();