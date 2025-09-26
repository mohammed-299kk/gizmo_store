// سكريبت لإصلاح صور المنتجات
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, doc, updateDoc } from 'firebase/firestore';

// إعدادات Firebase
const firebaseConfig = {
  apiKey: "AIzaSyBKqKZKqKZKqKZKqKZKqKZKqKZKqKZKqKZ",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  databaseURL: "https://gizmostore-2a3ff-default-rtdb.firebaseio.com",
  projectId: "gizmostore-2a3ff",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdefghijklmnop"
};

// تهيئة Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// روابط الصور المحدثة
const imageUrls = {
  'google-pixel-8': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop',
  'iphone-15-pro': 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=500&fit=crop',
  'samsung-galaxy-s24': 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500&h=500&fit=crop',
  'macbook-pro-16': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&h=500&fit=crop',
  'hp-spectre-x360': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop',
  'dell-xps-13': 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500&h=500&fit=crop',
  'ipad-pro-12': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop',
  'samsung-galaxy-tab-s9': 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=500&h=500&fit=crop',
  'apple-watch-series-9': 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=500&h=500&fit=crop',
  'samsung-galaxy-watch-6': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop',
  'airpods-pro-2nd-gen': 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=500&h=500&fit=crop',
  'sony-wh-1000xm5': 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500&h=500&fit=crop',
  'bose-quietcomfort-45': 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500&h=500&fit=crop',
  'anker-powercore-10000': 'https://images.unsplash.com/photo-1609592806444-7de5e0e8e5b5?w=500&h=500&fit=crop',
  'belkin-wireless-charger': 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=500&h=500&fit=crop',
  'logitech-mx-master-3': 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500&h=500&fit=crop',
  'apple-magic-keyboard': 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500&h=500&fit=crop'
};

async function fixProductImages() {
  try {
    console.log('🔧 بدء إصلاح صور المنتجات...');
    
    // الحصول على جميع المنتجات
    const querySnapshot = await getDocs(collection(db, 'products'));
    let updatedCount = 0;
    let skippedCount = 0;
    
    for (const docSnapshot of querySnapshot.docs) {
      const productData = docSnapshot.data();
      const productId = productData.id || docSnapshot.id;
      
      if (imageUrls[productId]) {
        // تحديث رابط الصورة
        await updateDoc(doc(db, 'products', docSnapshot.id), {
          imageUrl: imageUrls[productId]
        });
        
        console.log(`✅ تم تحديث صورة ${productData.name || productData.nameAr}`);
        updatedCount++;
      } else {
        console.log(`⚠️ لم يتم العثور على صورة للمنتج: ${productData.name || productData.nameAr} (ID: ${productId})`);
        skippedCount++;
      }
    }
    
    console.log('\n📊 ملخص العملية:');
    console.log(`  ✅ تم تحديث: ${updatedCount} منتج`);
    console.log(`  ⚠️ تم تخطي: ${skippedCount} منتج`);
    console.log(`  📱 إجمالي المنتجات: ${querySnapshot.size}`);
    
    console.log('\n🎉 تم إكمال إصلاح صور المنتجات بنجاح!');
    
  } catch (error) {
    console.error('❌ خطأ في إصلاح صور المنتجات:', error);
  }
}

fixProductImages();