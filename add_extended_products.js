// سكريبت لإضافة المنتجات الموسعة (400 منتج)
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, serverTimestamp, getDocs } from 'firebase/firestore';

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

// بيانات المنتجات الموسعة
const extendedProducts = [
  // الهواتف الذكية (50 منتج)
  ...Array.from({ length: 50 }, (_, i) => ({
    name: `هاتف ذكي ${i + 1}`,
    description: `هاتف ذكي متطور بمواصفات عالية الجودة - الطراز ${i + 1}`,
    price: 1500 + (i * 100),
    originalPrice: i % 3 === 0 ? 1700 + (i * 100) : null,
    image: `https://images.unsplash.com/photo-1695048133142?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80&sig=${i}`,
    category: 'الهواتف الذكية',
    rating: 4.0 + (i % 10) * 0.1,
    reviewsCount: 50 + (i * 5),
    featured: i % 10 === 0,
    isAvailable: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  })),

  // أجهزة الكمبيوتر المحمولة (50 منتج)
  ...Array.from({ length: 50 }, (_, i) => ({
    name: `لابتوب ${i + 1}`,
    description: `جهاز كمبيوتر محمول عالي الأداء للعمل والألعاب - الطراز ${i + 1}`,
    price: 3000 + (i * 200),
    originalPrice: i % 4 === 0 ? 3500 + (i * 200) : null,
    image: `https://images.unsplash.com/photo-1517336714731?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80&sig=${i}`,
    category: 'أجهزة الكمبيوتر المحمولة',
    rating: 4.2 + (i % 8) * 0.1,
    reviewsCount: 30 + (i * 3),
    featured: i % 12 === 0,
    isAvailable: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  })),

  // سماعات الرأس (50 منتج)
  ...Array.from({ length: 50 }, (_, i) => ({
    name: `سماعة رأس ${i + 1}`,
    description: `سماعة رأس عالية الجودة مع إلغاء الضوضاء - الطراز ${i + 1}`,
    price: 200 + (i * 50),
    originalPrice: i % 5 === 0 ? 280 + (i * 50) : null,
    image: `https://images.unsplash.com/photo-1505740420928?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80&sig=${i}`,
    category: 'سماعات الرأس',
    rating: 4.1 + (i % 9) * 0.1,
    reviewsCount: 25 + (i * 2),
    featured: i % 15 === 0,
    isAvailable: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  })),

  // الساعات الذكية (50 منتج)
  ...Array.from({ length: 50 }, (_, i) => ({
    name: `ساعة ذكية ${i + 1}`,
    description: `ساعة ذكية متطورة لتتبع اللياقة البدنية والصحة - الطراز ${i + 1}`,
    price: 800 + (i * 80),
    originalPrice: i % 6 === 0 ? 950 + (i * 80) : null,
    image: `https://images.unsplash.com/photo-1434494878577?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80&sig=${i}`,
    category: 'الساعات الذكية',
    rating: 4.3 + (i % 7) * 0.1,
    reviewsCount: 40 + (i * 4),
    featured: i % 18 === 0,
    isAvailable: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  })),

  // الأجهزة اللوحية (50 منتج)
  ...Array.from({ length: 50 }, (_, i) => ({
    name: `جهاز لوحي ${i + 1}`,
    description: `جهاز لوحي متطور للعمل والترفيه - الطراز ${i + 1}`,
    price: 1200 + (i * 120),
    originalPrice: i % 7 === 0 ? 1400 + (i * 120) : null,
    image: `https://images.unsplash.com/photo-1544244015?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80&sig=${i}`,
    category: 'الأجهزة اللوحية',
    rating: 4.0 + (i % 10) * 0.1,
    reviewsCount: 35 + (i * 3),
    featured: i % 20 === 0,
    isAvailable: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  })),

  // الإكسسوارات (50 منتج)
  ...Array.from({ length: 50 }, (_, i) => ({
    name: `إكسسوار ${i + 1}`,
    description: `إكسسوار تقني عالي الجودة - الطراز ${i + 1}`,
    price: 50 + (i * 20),
    originalPrice: i % 8 === 0 ? 70 + (i * 20) : null,
    image: `https://images.unsplash.com/photo-1572635196243?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80&sig=${i}`,
    category: 'الإكسسوارات',
    rating: 3.8 + (i % 12) * 0.1,
    reviewsCount: 15 + (i * 2),
    featured: i % 25 === 0,
    isAvailable: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  })),

  // أجهزة الكمبيوتر المكتبية (50 منتج)
  ...Array.from({ length: 50 }, (_, i) => ({
    name: `كمبيوتر مكتبي ${i + 1}`,
    description: `جهاز كمبيوتر مكتبي قوي للألعاب والعمل - الطراز ${i + 1}`,
    price: 4000 + (i * 300),
    originalPrice: i % 9 === 0 ? 4800 + (i * 300) : null,
    image: `https://images.unsplash.com/photo-1587831990711?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80&sig=${i}`,
    category: 'أجهزة الكمبيوتر المكتبية',
    rating: 4.4 + (i % 6) * 0.1,
    reviewsCount: 60 + (i * 5),
    featured: i % 22 === 0,
    isAvailable: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  })),

  // الكاميرات (50 منتج)
  ...Array.from({ length: 50 }, (_, i) => ({
    name: `كاميرا ${i + 1}`,
    description: `كاميرا احترافية عالية الدقة للتصوير - الطراز ${i + 1}`,
    price: 2500 + (i * 250),
    originalPrice: i % 10 === 0 ? 3000 + (i * 250) : null,
    image: `https://images.unsplash.com/photo-1606983340077?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80&sig=${i}`,
    category: 'الكاميرات',
    rating: 4.5 + (i % 5) * 0.1,
    reviewsCount: 45 + (i * 4),
    featured: i % 28 === 0,
    isAvailable: true,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  }))
];

async function addExtendedProducts() {
  try {
    console.log('🚀 بدء إضافة المنتجات الموسعة...');
    console.log(`📦 سيتم إضافة ${extendedProducts.length} منتج`);

    let addedCount = 0;
    const batchSize = 50; // إضافة المنتجات في مجموعات

    for (let i = 0; i < extendedProducts.length; i += batchSize) {
      const batch = extendedProducts.slice(i, i + batchSize);
      
      console.log(`📝 إضافة المجموعة ${Math.floor(i / batchSize) + 1} من ${Math.ceil(extendedProducts.length / batchSize)}`);
      
      const promises = batch.map(async (product) => {
        try {
          await addDoc(collection(db, 'products'), product);
          addedCount++;
          if (addedCount % 10 === 0) {
            console.log(`✅ تم إضافة ${addedCount} منتج`);
          }
        } catch (error) {
          console.error(`❌ خطأ في إضافة منتج: ${product.name}`, error);
        }
      });

      await Promise.all(promises);
      
      // انتظار قصير بين المجموعات لتجنب تحميل الخادم
      if (i + batchSize < extendedProducts.length) {
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
    }

    console.log(`🎉 تم إضافة ${addedCount} منتج بنجاح!`);
    console.log('✅ تم الانتهاء من إضافة جميع المنتجات الموسعة');

    // التحقق من العدد النهائي
    const snapshot = await getDocs(collection(db, 'products'));
    console.log(`📊 العدد النهائي للمنتجات في قاعدة البيانات: ${snapshot.docs.length}`);

  } catch (error) {
    console.error('❌ خطأ في إضافة المنتجات الموسعة:', error);
  }
}

addExtendedProducts();