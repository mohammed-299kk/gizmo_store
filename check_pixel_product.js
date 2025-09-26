// سكريبت للتحقق من إضافة منتج Google Pixel 8
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, query, where } from 'firebase/firestore';

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

async function checkPixelProduct() {
  try {
    console.log('🔍 البحث عن منتج Google Pixel 8...');
    
    // البحث عن منتج Google Pixel 8
    const q = query(collection(db, 'products'), where('id', '==', 'google-pixel-8'));
    const querySnapshot = await getDocs(q);
    
    if (querySnapshot.empty) {
      console.log('❌ لم يتم العثور على منتج Google Pixel 8');
      
      // عرض جميع المنتجات المتاحة
      console.log('\n📱 المنتجات المتاحة:');
      const allProducts = await getDocs(collection(db, 'products'));
      allProducts.forEach((doc) => {
        const data = doc.data();
        console.log(`  - ${data.name || data.nameAr} (ID: ${data.id || doc.id})`);
      });
    } else {
      console.log('✅ تم العثور على منتج Google Pixel 8!');
      
      querySnapshot.forEach((doc) => {
        const data = doc.data();
        console.log('\n📱 تفاصيل المنتج:');
        console.log(`  الاسم: ${data.name}`);
        console.log(`  الاسم بالعربية: ${data.nameAr}`);
        console.log(`  السعر: $${data.price}`);
        console.log(`  الفئة: ${data.category}`);
        console.log(`  العلامة التجارية: ${data.brand}`);
        console.log(`  متوفر: ${data.inStock ? 'نعم' : 'لا'}`);
        console.log(`  الكمية: ${data.stockQuantity}`);
        console.log(`  التقييم: ${data.rating}/5`);
        console.log(`  عدد المراجعات: ${data.reviewCount}`);
        console.log(`  رابط الصورة: ${data.imageUrl}`);
      });
    }
    
    // عرض إحصائيات عامة
    console.log('\n📊 إحصائيات عامة:');
    const allProducts = await getDocs(collection(db, 'products'));
    console.log(`  إجمالي المنتجات: ${allProducts.size}`);
    
    // تجميع حسب الفئة
    const categories = {};
    allProducts.forEach((doc) => {
      const data = doc.data();
      const category = data.categoryAr || data.category || 'غير محدد';
      categories[category] = (categories[category] || 0) + 1;
    });
    
    console.log('\n📂 المنتجات حسب الفئة:');
    Object.entries(categories).forEach(([category, count]) => {
      console.log(`  ${category}: ${count} منتج`);
    });
    
  } catch (error) {
    console.error('❌ خطأ في التحقق من المنتج:', error);
  }
}

checkPixelProduct();