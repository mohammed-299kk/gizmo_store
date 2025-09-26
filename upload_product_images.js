import { v2 as cloudinary } from 'cloudinary';
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, doc, updateDoc } from 'firebase/firestore';
import fetch from 'node-fetch';
import fs from 'fs';
import path from 'path';

// إعداد Cloudinary
cloudinary.config({
  cloud_name: 'dq1anqzzx',
  api_key: '123456789012345', // يجب استبدالها بالمفتاح الحقيقي
  api_secret: 'your_api_secret_here' // يجب استبدالها بالسر الحقيقي
});

// إعداد Firebase
const firebaseConfig = {
  apiKey: "AIzaSyBGl7rHkP5nzQg5ShHa3NvjZONKOo5LHQY",
  appId: "1:1062701951007:web:a5b8fc2729fdc029dc1985",
  messagingSenderId: "1062701951007",
  projectId: "gizmostore-2a3ff",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  measurementId: "G-YGWN9QZPJL"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// قائمة الصور للمنتجات المختلفة
const productImages = {
  // هواتف ذكية
  'iPhone 15 Pro Max': [
    'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800',
    'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=800'
  ],
  'Samsung Galaxy S24 Ultra': [
    'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800',
    'https://images.unsplash.com/photo-1567581935884-3349723552ca?w=800',
    'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=800'
  ],
  'Google Pixel 8 Pro': [
    'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=800',
    'https://images.unsplash.com/photo-1567581935884-3349723552ca?w=800'
  ],

  // أجهزة لابتوب
  'MacBook Pro M3': [
    'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800',
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800',
    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800'
  ],
  'Dell XPS 13': [
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800',
    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800',
    'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800'
  ],
  'HP Spectre x360': [
    'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800',
    'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800',
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800'
  ],

  // سماعات
  'AirPods Pro 2': [
    'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=800',
    'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=800',
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800'
  ],
  'Sony WH-1000XM5': [
    'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=800',
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
    'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=800'
  ],
  'Bose QuietComfort 45': [
    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
    'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=800',
    'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=800'
  ],

  // ساعات ذكية
  'Apple Watch Series 9': [
    'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=800',
    'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=800',
    'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800'
  ],
  'Samsung Galaxy Watch 6': [
    'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=800',
    'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=800',
    'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=800'
  ],

  // أجهزة لوحية
  'iPad Pro 12.9': [
    'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800',
    'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=800'
  ],
  'Samsung Galaxy Tab S9': [
    'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=800',
    'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800'
  ],

  // إكسسوارات
  'Wireless Charger': [
    'https://images.unsplash.com/photo-1609592806596-b43bada2e3c9?w=800'
  ],
  'Phone Case': [
    'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=800'
  ],
  'Screen Protector': [
    'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=800'
  ],
  'USB-C Cable': [
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800'
  ]
};

// دالة لتحميل الصورة من URL
async function downloadImage(url, filename) {
  try {
    const response = await fetch(url);
    if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
    
    const buffer = await response.buffer();
    const filepath = path.join('product_images', filename);
    
    fs.writeFileSync(filepath, buffer);
    console.log(`تم تحميل الصورة: ${filename}`);
    return filepath;
  } catch (error) {
    console.error(`خطأ في تحميل الصورة ${filename}:`, error);
    return null;
  }
}

// دالة لرفع الصورة إلى Cloudinary
async function uploadToCloudinary(imagePath, publicId) {
  try {
    const result = await cloudinary.uploader.upload(imagePath, {
      public_id: publicId,
      folder: 'gizmo_store_products',
      transformation: [
        { width: 800, height: 800, crop: 'fill' },
        { quality: 'auto' },
        { format: 'webp' }
      ]
    });
    
    console.log(`تم رفع الصورة إلى Cloudinary: ${result.secure_url}`);
    return result.secure_url;
  } catch (error) {
    console.error(`خطأ في رفع الصورة إلى Cloudinary:`, error);
    return null;
  }
}

// دالة لتحديث قاعدة البيانات
async function updateProductInDatabase(productId, imageUrl) {
  try {
    const productRef = doc(db, 'products', productId);
    await updateDoc(productRef, {
      imageUrl: imageUrl
    });
    console.log(`تم تحديث المنتج ${productId} برابط الصورة الجديد`);
    return true;
  } catch (error) {
    console.error(`خطأ في تحديث قاعدة البيانات للمنتج ${productId}:`, error);
    return false;
  }
}

// دالة رئيسية لمعالجة جميع المنتجات
async function processAllProducts() {
  try {
    console.log('بدء معالجة المنتجات...');
    
    // الحصول على جميع المنتجات من قاعدة البيانات
    const productsRef = collection(db, 'products');
    const snapshot = await getDocs(productsRef);
    
    console.log(`تم العثور على ${snapshot.size} منتج`);
    
    for (const docSnap of snapshot.docs) {
      const product = docSnap.data();
      const productId = docSnap.id;
      const productName = product.name;
      
      console.log(`\nمعالجة المنتج: ${productName}`);
      
      // البحث عن صور للمنتج
      const images = productImages[productName];
      if (!images || images.length === 0) {
        console.log(`لا توجد صور محددة للمنتج: ${productName}`);
        continue;
      }
      
      // استخدام أول صورة فقط
      const imageUrl = images[0];
      const filename = `${productName.replace(/[^a-zA-Z0-9]/g, '_')}_1.jpg`;
      
      // تحميل الصورة
      const localPath = await downloadImage(imageUrl, filename);
      if (!localPath) continue;
      
      // رفع الصورة إلى Cloudinary
      const publicId = `${productName.replace(/[^a-zA-Z0-9]/g, '_')}_main`;
      const cloudinaryUrl = await uploadToCloudinary(localPath, publicId);
      if (!cloudinaryUrl) continue;
      
      // تحديث قاعدة البيانات
      await updateProductInDatabase(productId, cloudinaryUrl);
      
      // حذف الصورة المحلية لتوفير المساحة
      try {
        fs.unlinkSync(localPath);
      } catch (error) {
        console.log(`تعذر حذف الصورة المحلية: ${localPath}`);
      }
      
      // انتظار قصير لتجنب تجاوز حدود API
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
    
    console.log('\nتم الانتهاء من معالجة جميع المنتجات!');
    
  } catch (error) {
    console.error('خطأ في معالجة المنتجات:', error);
  }
}

// تشغيل السكريبت
processAllProducts().catch(console.error);