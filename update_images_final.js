import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, doc, updateDoc } from 'firebase/firestore';

// إعدادات Firebase الصحيحة
const firebaseConfig = {
    apiKey: "AIzaSyAo4-Ge1dC4LnIyG_wUjYgWc9KHCxEYUxM",
    authDomain: "gizmostore-2a3ff.firebaseapp.com",
    projectId: "gizmostore-2a3ff",
    storageBucket: "gizmostore-2a3ff.firebasestorage.app",
    messagingSenderId: "32902740595",
    appId: "1:32902740595:web:7de8f1273a64f9f28fc806"
};

// تهيئة Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// بيانات الصور الجديدة من Amazon
const productImages = {
    'هواتف': [
        'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71ZOtNdaZCL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71d7rfSl0wL._AC_SL1500_.jpg'
    ],
    'لابتوبات': [
        'https://m.media-amazon.com/images/I/61RJn0ofUsL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81bc8mS3nhL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg'
    ],
    'سماعات': [
        'https://m.media-amazon.com/images/I/51K+wIbLzNL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/61SUj23roXL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81bhkKHsNnL._AC_SL1500_.jpg'
    ],
    'ساعات ذكية': [
        'https://m.media-amazon.com/images/I/71u1JVgTdiL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81+VpHhh3QL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71BFqBqp1eL._AC_SL1500_.jpg'
    ],
    'تابلت': [
        'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81NiAaKs8nL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71CRH1JVqmL._AC_SL1500_.jpg'
    ],
    'تلفازات': [
        'https://m.media-amazon.com/images/I/81REYN6HCTL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/71qid7QFZJL._AC_SL1500_.jpg',
        'https://m.media-amazon.com/images/I/81vDKIJo9eL._AC_SL1500_.jpg'
    ]
};

async function updateProductImages() {
    try {
        console.log('🔄 بدء تحديث صور المنتجات...');
        
        // جلب جميع المنتجات
        const productsRef = collection(db, 'products');
        const snapshot = await getDocs(productsRef);
        
        console.log(`📦 تم العثور على ${snapshot.size} منتج`);
        
        let updatedCount = 0;
        const categoryCounters = {};
        
        for (const docSnapshot of snapshot.docs) {
            const product = docSnapshot.data();
            const productId = docSnapshot.id;
            const category = product.category;
            
            console.log(`\n🔍 معالجة المنتج: ${product.name} (الفئة: ${category})`);
            
            if (productImages[category]) {
                // تحديد فهرس الصورة بناءً على عدد المنتجات في نفس الفئة
                if (!categoryCounters[category]) {
                    categoryCounters[category] = 0;
                }
                
                const imageIndex = categoryCounters[category] % productImages[category].length;
                const newImageUrl = productImages[category][imageIndex];
                
                // تحديث المنتج بالصورة الجديدة
                const productRef = doc(db, 'products', productId);
                await updateDoc(productRef, {
                    imageUrl: newImageUrl
                });
                
                console.log(`✅ تم تحديث صورة المنتج: ${product.name}`);
                console.log(`🖼️ الصورة الجديدة: ${newImageUrl}`);
                
                categoryCounters[category]++;
                updatedCount++;
            } else {
                console.log(`⚠️ لا توجد صور متاحة للفئة: ${category}`);
            }
        }
        
        console.log(`\n🎉 تم الانتهاء! تم تحديث ${updatedCount} منتج بصور جديدة`);
        
        // عرض إحصائيات التحديث
        console.log('\n📊 إحصائيات التحديث:');
        for (const [category, count] of Object.entries(categoryCounters)) {
            console.log(`${category}: ${count} منتج محدث`);
        }
        
    } catch (error) {
        console.error('❌ خطأ في تحديث الصور:', error);
    }
}

// تشغيل التحديث
updateProductImages();