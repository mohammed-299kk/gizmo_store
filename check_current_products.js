// سكريبت لفحص المنتجات الموجودة في قاعدة البيانات
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

async function checkProducts() {
  try {
    console.log('🔍 فحص المنتجات الموجودة في قاعدة البيانات...\n');
    
    const productsRef = collection(db, 'products');
    const snapshot = await getDocs(productsRef);
    
    if (snapshot.empty) {
      console.log('❌ لا توجد منتجات في قاعدة البيانات');
      return;
    }
    
    const products = [];
    snapshot.forEach((doc) => {
      products.push({ id: doc.id, ...doc.data() });
    });
    
    console.log(`📦 تم العثور على ${products.length} منتج\n`);
    
    // عرض عينة من المنتجات
    console.log('📋 عينة من المنتجات الموجودة:');
    console.log('=====================================');
    
    products.slice(0, 10).forEach((product, index) => {
      console.log(`${index + 1}. ${product.name}`);
      console.log(`   الفئة: ${product.category}`);
      console.log(`   السعر: ${product.price}`);
      console.log(`   الصورة الحالية: ${product.imageUrl ? 'موجودة ✅' : 'لا توجد صورة ❌'}`);
      if (product.imageUrl) {
        console.log(`   رابط الصورة: ${product.imageUrl.substring(0, 60)}...`);
      }
      console.log('   ---');
    });
    
    if (products.length > 10) {
      console.log(`... و ${products.length - 10} منتج آخر\n`);
    }
    
    // إحصائيات الفئات
    const categoryStats = {};
    products.forEach(product => {
      if (!categoryStats[product.category]) {
        categoryStats[product.category] = 0;
      }
      categoryStats[product.category]++;
    });
    
    console.log('📊 إحصائيات الفئات:');
    console.log('==================');
    Object.entries(categoryStats).forEach(([category, count]) => {
      console.log(`${category}: ${count} منتج`);
    });
    
    // إحصائيات الصور
    const productsWithImages = products.filter(p => p.imageUrl && p.imageUrl.trim() !== '');
    const productsWithoutImages = products.filter(p => !p.imageUrl || p.imageUrl.trim() === '');
    
    console.log('\n🖼️ حالة الصور:');
    console.log('===============');
    console.log(`منتجات لها صور: ${productsWithImages.length} ✅`);
    console.log(`منتجات بدون صور: ${productsWithoutImages.length} ❌`);
    
    if (productsWithImages.length > 0) {
      console.log('\n📸 أمثلة على الصور الموجودة:');
      console.log('============================');
      productsWithImages.slice(0, 3).forEach((product, index) => {
        console.log(`${index + 1}. ${product.name}: ${product.imageUrl}`);
      });
    }
    
    console.log('\n✅ تم الانتهاء من فحص المنتجات');
    
  } catch (error) {
    console.error('❌ خطأ في فحص المنتجات:', error);
  }
}

checkProducts();