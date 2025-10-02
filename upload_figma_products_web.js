import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, deleteDoc, getDocs, doc } from 'firebase/firestore';
import { v2 as cloudinary } from 'cloudinary';
import axios from 'axios';

// إعداد Firebase
const firebaseConfig = {
  apiKey: "AIzaSyBKQJXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  projectId: "gizmostore-2a3ff",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  messagingSenderId: "32902740595",
  appId: "1:32902740595:web:7de8f1273a64f9f28fc806"
};

// إعداد Cloudinary
cloudinary.config({
  cloud_name: 'dq1anqzzx',
  api_key: '123456789012345',
  api_secret: 'your_api_secret_here'
});

// تهيئة Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// بيانات المنتجات من ملف figma-design
const products = [
  {
    id: 'headphones-1',
    name: 'Sony WH-1000XM5',
    category: 'سماعات',
    price: 1299,
    originalPrice: 1499,
    description: 'سماعات لاسلكية بتقنية إلغاء الضوضاء المتقدمة',
    brand: 'Sony',
    rating: 4.8,
    reviewCount: 2847,
    inStock: true,
    images: [
      'https://m.media-amazon.com/images/I/61+btTqFLgL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61jLMt1pSQL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71o8Q5XJS5L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71pGKQ4yNbL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'headphones-2',
    name: 'Apple AirPods Pro 2',
    category: 'سماعات',
    price: 999,
    originalPrice: 1199,
    description: 'سماعات أبل اللاسلكية مع إلغاء الضوضاء النشط',
    brand: 'Apple',
    rating: 4.7,
    reviewCount: 5632,
    inStock: true,
    images: [
      'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61f1YfTkTtL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61jdKmgdPgL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'laptop-1',
    name: 'MacBook Pro M3',
    category: 'لابتوبات',
    price: 7999,
    originalPrice: 8999,
    description: 'لابتوب أبل ماك بوك برو بمعالج M3 المتطور',
    brand: 'Apple',
    rating: 4.9,
    reviewCount: 1234,
    inStock: true,
    images: [
      'https://m.media-amazon.com/images/I/61RJn0ofUsL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61+GJpFk5eL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'phone-1',
    name: 'iPhone 15 Pro',
    category: 'هواتف',
    price: 4999,
    originalPrice: 5499,
    description: 'هاتف أيفون 15 برو بكاميرا متطورة ومعالج A17 Pro',
    brand: 'Apple',
    rating: 4.8,
    reviewCount: 8765,
    inStock: true,
    images: [
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81SigpJN1KL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81dT7CUY6GL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'tablet-1',
    name: 'iPad Pro 12.9"',
    category: 'تابلت',
    price: 3999,
    originalPrice: 4499,
    description: 'تابلت أيباد برو بشاشة 12.9 بوصة ومعالج M2',
    brand: 'Apple',
    rating: 4.7,
    reviewCount: 3456,
    inStock: true,
    images: [
      'https://m.media-amazon.com/images/I/81Vctk5hOmL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81+GJpFk5eL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'watch-1',
    name: 'Apple Watch Series 9',
    category: 'ساعات ذكية',
    price: 1599,
    originalPrice: 1799,
    description: 'ساعة أبل الذكية الجيل التاسع مع مستشعرات متطورة',
    brand: 'Apple',
    rating: 4.6,
    reviewCount: 2134,
    inStock: true,
    images: [
      'https://m.media-amazon.com/images/I/71u+9OSHISL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71TPda7cwUL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'tv-1',
    name: 'Samsung QLED 65"',
    category: 'تلفازات',
    price: 2999,
    originalPrice: 3499,
    description: 'تلفاز سامسونج QLED بدقة 4K وتقنية HDR',
    brand: 'Samsung',
    rating: 4.5,
    reviewCount: 1876,
    inStock: true,
    images: [
      'https://m.media-amazon.com/images/I/81XQZK5K5tL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71u+9OSHISL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg'
    ]
  }
];

// دالة لرفع صورة إلى Cloudinary
async function uploadImageToCloudinary(imageUrl, productId, imageIndex) {
  try {
    console.log(`📤 رفع صورة ${imageIndex + 1} للمنتج ${productId}...`);
    
    const result = await cloudinary.uploader.upload(imageUrl, {
      folder: 'gizmo-store/products',
      public_id: `${productId}_${imageIndex + 1}`,
      overwrite: true,
      transformation: [
        { width: 800, height: 800, crop: 'fill', quality: 'auto' }
      ]
    });
    
    console.log(`✅ تم رفع الصورة: ${result.secure_url}`);
    return result.secure_url;
  } catch (error) {
    console.error(`❌ خطأ في رفع الصورة ${imageIndex + 1} للمنتج ${productId}:`, error.message);
    return imageUrl; // استخدام الرابط الأصلي في حالة الفشل
  }
}

// دالة لحذف المنتجات القديمة
async function deleteOldProducts() {
  try {
    console.log('🗑️ حذف المنتجات القديمة...');
    const querySnapshot = await getDocs(collection(db, 'products'));
    
    const deletePromises = querySnapshot.docs.map(docSnapshot => 
      deleteDoc(doc(db, 'products', docSnapshot.id))
    );
    
    await Promise.all(deletePromises);
    console.log(`✅ تم حذف ${querySnapshot.docs.length} منتج قديم`);
  } catch (error) {
    console.error('❌ خطأ في حذف المنتجات القديمة:', error.message);
  }
}

// دالة لإضافة منتج إلى Firebase
async function addProductToFirebase(product, cloudinaryImages) {
  try {
    const productData = {
      ...product,
      images: cloudinaryImages,
      createdAt: new Date(),
      updatedAt: new Date(),
      isActive: true,
      tags: [product.category, product.brand.toLowerCase()],
      specifications: {
        brand: product.brand,
        category: product.category,
        inStock: product.inStock
      }
    };
    
    const docRef = await addDoc(collection(db, 'products'), productData);
    console.log(`✅ تم إضافة المنتج ${product.name} بمعرف: ${docRef.id}`);
    return docRef.id;
  } catch (error) {
    console.error(`❌ خطأ في إضافة المنتج ${product.name}:`, error.message);
    throw error;
  }
}

// دالة لمعالجة منتج واحد
async function processProduct(product, index) {
  try {
    console.log(`\n🔄 معالجة المنتج ${index + 1}/${products.length}: ${product.name}`);
    
    // رفع الصور إلى Cloudinary
    const cloudinaryImages = [];
    for (let i = 0; i < product.images.length; i++) {
      const cloudinaryUrl = await uploadImageToCloudinary(product.images[i], product.id, i);
      cloudinaryImages.push(cloudinaryUrl);
      
      // تأخير قصير بين رفع الصور
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
    
    // إضافة المنتج إلى Firebase
    const firebaseId = await addProductToFirebase(product, cloudinaryImages);
    
    return {
      success: true,
      productName: product.name,
      firebaseId,
      imagesUploaded: cloudinaryImages.length
    };
  } catch (error) {
    console.error(`❌ فشل في معالجة المنتج ${product.name}:`, error.message);
    return {
      success: false,
      productName: product.name,
      error: error.message
    };
  }
}

// الدالة الرئيسية
async function main() {
  console.log('🚀 بدء رفع منتجات Figma إلى Cloudinary و Firebase...\n');
  
  const startTime = Date.now();
  const results = [];
  
  try {
    // حذف المنتجات القديمة
    await deleteOldProducts();
    
    console.log('\n📦 بدء معالجة المنتجات...');
    
    // معالجة المنتجات واحد تلو الآخر لتجنب تجاوز حدود API
    for (let i = 0; i < products.length; i++) {
      const result = await processProduct(products[i], i);
      results.push(result);
      
      // تأخير بين المنتجات
      if (i < products.length - 1) {
        console.log('⏳ انتظار 3 ثوان...');
        await new Promise(resolve => setTimeout(resolve, 3000));
      }
    }
    
    // تقرير النتائج
    const successful = results.filter(r => r.success);
    const failed = results.filter(r => !r.success);
    
    console.log('\n📊 تقرير النتائج:');
    console.log(`✅ نجح: ${successful.length} منتج`);
    console.log(`❌ فشل: ${failed.length} منتج`);
    
    if (failed.length > 0) {
      console.log('\n❌ المنتجات التي فشلت:');
      failed.forEach(f => console.log(`  - ${f.productName}: ${f.error}`));
    }
    
    const endTime = Date.now();
    const duration = Math.round((endTime - startTime) / 1000);
    console.log(`\n⏱️ الوقت المستغرق: ${duration} ثانية`);
    console.log('🎉 انتهت العملية!');
    
  } catch (error) {
    console.error('❌ خطأ عام في العملية:', error.message);
  }
}

// تشغيل السكريبت
main().catch(console.error);