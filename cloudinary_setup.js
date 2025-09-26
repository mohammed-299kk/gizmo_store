const cloudinary = require('cloudinary').v2;

// إعداد Cloudinary
cloudinary.config({
  cloud_name: 'dq1anqzzx',
  api_key: '123456789012345', // يجب استبدالها بالمفتاح الحقيقي
  api_secret: 'your_api_secret_here' // يجب استبدالها بالسر الحقيقي
});

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
  ]
};

// دالة لرفع صورة إلى Cloudinary
async function uploadImageToCloudinary(imageUrl, productName, imageIndex) {
  try {
    const result = await cloudinary.uploader.upload(imageUrl, {
      folder: 'gizmo_store/products',
      public_id: `${productName.toLowerCase().replace(/\s+/g, '_')}_${imageIndex}`,
      overwrite: true,
      resource_type: 'image'
    });
    
    console.log(`✅ تم رفع الصورة: ${result.secure_url}`);
    return result.secure_url;
  } catch (error) {
    console.error(`❌ خطأ في رفع الصورة ${imageUrl}:`, error.message);
    return null;
  }
}

// دالة لرفع جميع صور منتج معين
async function uploadProductImages(productName) {
  const images = productImages[productName];
  if (!images) {
    console.log(`⚠️ لا توجد صور للمنتج: ${productName}`);
    return [];
  }
  
  console.log(`📤 بدء رفع صور المنتج: ${productName}`);
  const uploadedUrls = [];
  
  for (let i = 0; i < images.length; i++) {
    const url = await uploadImageToCloudinary(images[i], productName, i + 1);
    if (url) {
      uploadedUrls.push(url);
    }
    // انتظار قصير بين الرفعات لتجنب تجاوز الحدود
    await new Promise(resolve => setTimeout(resolve, 1000));
  }
  
  return uploadedUrls;
}

// دالة لرفع جميع الصور
async function uploadAllImages() {
  console.log('🚀 بدء رفع جميع الصور إلى Cloudinary...');
  
  const results = {};
  
  for (const productName of Object.keys(productImages)) {
    const urls = await uploadProductImages(productName);
    results[productName] = urls;
  }
  
  console.log('✅ تم الانتهاء من رفع جميع الصور');
  console.log('النتائج:', JSON.stringify(results, null, 2));
  
  return results;
}

// تشغيل الرفع إذا تم استدعاء الملف مباشرة
if (require.main === module) {
  uploadAllImages().catch(console.error);
}

module.exports = {
  uploadImageToCloudinary,
  uploadProductImages,
  uploadAllImages,
  productImages
};