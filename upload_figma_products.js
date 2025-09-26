const cloudinary = require('cloudinary').v2;
const admin = require('firebase-admin');
const axios = require('axios');
const fs = require('fs');
const path = require('path');

// إعداد Cloudinary
cloudinary.config({
  cloud_name: 'dq1anqzzx',
  api_key: '123456789012345', // يجب استبدالها بالمفتاح الحقيقي
  api_secret: 'your_api_secret_here' // يجب استبدالها بالسر الحقيقي
});

// إعداد Firebase Admin
const serviceAccount = {
  type: "service_account",
  project_id: "gizmostore-2a3ff",
  private_key_id: "key_id",
  private_key: "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC7VJTUt9Us8cKB\n-----END PRIVATE KEY-----\n",
  client_email: "firebase-adminsdk@gizmostore-2a3ff.iam.gserviceaccount.com",
  client_id: "client_id",
  auth_uri: "https://accounts.google.com/o/oauth2/auth",
  token_uri: "https://oauth2.googleapis.com/token",
  auth_provider_x509_cert_url: "https://www.googleapis.com/oauth2/v1/certs"
};

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'gizmostore-2a3ff'
});

const db = admin.firestore();

// بيانات المنتجات من ملف figma-design
const figmaProducts = [
  // سماعات (Headphones)
  {
    id: 'airpods-pro-2',
    name: 'Apple AirPods Pro (الجيل الثاني)',
    nameEn: 'Apple AirPods Pro (2nd Generation)',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 899,
    originalPrice: 999,
    description: 'سماعات Apple AirPods Pro الجيل الثاني مع إلغاء الضوضاء النشط المحسن وجودة صوت استثنائية',
    descriptionEn: 'Apple AirPods Pro 2nd Generation with enhanced Active Noise Cancellation and exceptional audio quality',
    brand: 'Apple',
    rating: 4.8,
    reviewCount: 2847,
    inStock: true,
    stockCount: 45,
    images: [
      'https://m.media-amazon.com/images/I/61SUj2aAoQS._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61f1YfTkYTL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81oAv5ntVuL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81O6j9py4WL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'sony-wh-1000xm5',
    name: 'Sony WH-1000XM5',
    nameEn: 'Sony WH-1000XM5',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 1299,
    originalPrice: 1499,
    description: 'سماعات Sony WH-1000XM5 اللاسلكية مع إلغاء الضوضاء الرائد في الصناعة',
    descriptionEn: 'Sony WH-1000XM5 Wireless Headphones with Industry Leading Noise Cancellation',
    brand: 'Sony',
    rating: 4.7,
    reviewCount: 1923,
    inStock: true,
    stockCount: 32,
    images: [
      'https://m.media-amazon.com/images/I/61VPY3p+f0L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71XKEL6UaXL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'bose-qc45',
    name: 'Bose QuietComfort 45',
    nameEn: 'Bose QuietComfort 45',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 1199,
    originalPrice: 1399,
    description: 'سماعات Bose QuietComfort 45 مع تقنية إلغاء الضوضاء المتقدمة',
    descriptionEn: 'Bose QuietComfort 45 Headphones with Advanced Noise Cancellation',
    brand: 'Bose',
    rating: 4.6,
    reviewCount: 1456,
    inStock: true,
    stockCount: 28,
    images: [
      'https://m.media-amazon.com/images/I/71m5rZfh88L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'beats-studio3',
    name: 'Beats Studio3 Wireless',
    nameEn: 'Beats Studio3 Wireless',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 799,
    originalPrice: 999,
    description: 'سماعات Beats Studio3 اللاسلكية مع تقنية إلغاء الضوضاء التكيفية',
    descriptionEn: 'Beats Studio3 Wireless Headphones with Adaptive Noise Cancelling',
    brand: 'Beats',
    rating: 4.4,
    reviewCount: 987,
    inStock: true,
    stockCount: 22,
    images: [
      'https://m.media-amazon.com/images/I/61drpbBuCxL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'sennheiser-momentum4',
    name: 'Sennheiser Momentum 4',
    nameEn: 'Sennheiser Momentum 4',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 1099,
    originalPrice: 1299,
    description: 'سماعات Sennheiser Momentum 4 اللاسلكية مع جودة صوت أوديوفايل',
    descriptionEn: 'Sennheiser Momentum 4 Wireless Headphones with Audiophile Sound Quality',
    brand: 'Sennheiser',
    rating: 4.5,
    reviewCount: 743,
    inStock: true,
    stockCount: 18,
    images: [
      'https://m.media-amazon.com/images/I/61Z3n3U5ZTL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61sWd6j4CQL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'jbl-live-660nc',
    name: 'JBL Live 660NC',
    nameEn: 'JBL Live 660NC',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 499,
    originalPrice: 699,
    description: 'سماعات JBL Live 660NC اللاسلكية مع إلغاء الضوضاء التكيفي',
    descriptionEn: 'JBL Live 660NC Wireless Headphones with Adaptive Noise Cancelling',
    brand: 'JBL',
    rating: 4.3,
    reviewCount: 654,
    inStock: true,
    stockCount: 35,
    images: [
      'https://m.media-amazon.com/images/I/61kBiws284L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'audio-technica-ath-m50xbt2',
    name: 'Audio-Technica ATH-M50xBT2',
    nameEn: 'Audio-Technica ATH-M50xBT2',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 699,
    originalPrice: 899,
    description: 'سماعات Audio-Technica ATH-M50xBT2 اللاسلكية للمحترفين',
    descriptionEn: 'Audio-Technica ATH-M50xBT2 Professional Wireless Headphones',
    brand: 'Audio-Technica',
    rating: 4.6,
    reviewCount: 892,
    inStock: true,
    stockCount: 26,
    images: [
      'https://m.media-amazon.com/images/I/71x6j45M+jL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71+4FzfR8KL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'marshall-major-iv',
    name: 'Marshall Major IV',
    nameEn: 'Marshall Major IV',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 599,
    originalPrice: 799,
    description: 'سماعات Marshall Major IV اللاسلكية مع تصميم كلاسيكي وصوت قوي',
    descriptionEn: 'Marshall Major IV Wireless Headphones with Classic Design and Powerful Sound',
    brand: 'Marshall',
    rating: 4.4,
    reviewCount: 567,
    inStock: true,
    stockCount: 31,
    images: [
      'https://m.media-amazon.com/images/I/61hzl5n3k+L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'hyperx-cloud-alpha',
    name: 'HyperX Cloud Alpha',
    nameEn: 'HyperX Cloud Alpha',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 399,
    originalPrice: 599,
    description: 'سماعات HyperX Cloud Alpha للألعاب مع جودة صوت استثنائية',
    descriptionEn: 'HyperX Cloud Alpha Gaming Headphones with Exceptional Audio Quality',
    brand: 'HyperX',
    rating: 4.5,
    reviewCount: 1234,
    inStock: true,
    stockCount: 42,
    images: [
      'https://m.media-amazon.com/images/I/81-9z4Z0eQL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81-9z4Z0eQL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'anker-soundcore-life-q30',
    name: 'Anker Soundcore Life Q30',
    nameEn: 'Anker Soundcore Life Q30',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 299,
    originalPrice: 399,
    description: 'سماعات Anker Soundcore Life Q30 مع إلغاء الضوضاء النشط وبطارية طويلة المدى',
    descriptionEn: 'Anker Soundcore Life Q30 Headphones with Active Noise Cancellation and Long Battery Life',
    brand: 'Anker',
    rating: 4.3,
    reviewCount: 2156,
    inStock: true,
    stockCount: 67,
    images: [
      'https://m.media-amazon.com/images/I/61vZU8YY2QL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },

  // لاب توب (Laptops)
  {
    id: 'macbook-pro-16-m2',
    name: 'MacBook Pro 16" M2 Pro',
    nameEn: 'MacBook Pro 16" M2 Pro',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 8999,
    originalPrice: 9999,
    description: 'MacBook Pro 16 بوصة مع معالج M2 Pro للأداء الاحترافي المتقدم',
    descriptionEn: 'MacBook Pro 16-inch with M2 Pro chip for advanced professional performance',
    brand: 'Apple',
    rating: 4.9,
    reviewCount: 1567,
    inStock: true,
    stockCount: 15,
    images: [
      'https://m.media-amazon.com/images/I/61LMpB2oEqL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'dell-xps-13-plus',
    name: 'Dell XPS 13 Plus',
    nameEn: 'Dell XPS 13 Plus',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 4999,
    originalPrice: 5999,
    description: 'Dell XPS 13 Plus مع تصميم مبتكر وأداء قوي للمحترفين',
    descriptionEn: 'Dell XPS 13 Plus with innovative design and powerful performance for professionals',
    brand: 'Dell',
    rating: 4.6,
    reviewCount: 892,
    inStock: true,
    stockCount: 23,
    images: [
      'https://m.media-amazon.com/images/I/71-Zu4v6gL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'hp-spectre-x360-14',
    name: 'HP Spectre x360 14',
    nameEn: 'HP Spectre x360 14',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 4499,
    originalPrice: 5499,
    description: 'HP Spectre x360 14 لابتوب قابل للتحويل مع شاشة لمس عالية الدقة',
    descriptionEn: 'HP Spectre x360 14 Convertible Laptop with High-Resolution Touchscreen',
    brand: 'HP',
    rating: 4.5,
    reviewCount: 634,
    inStock: true,
    stockCount: 19,
    images: [
      'https://m.media-amazon.com/images/I/71k45hzkfGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'asus-rog-strix-g15',
    name: 'ASUS ROG Strix G15',
    nameEn: 'ASUS ROG Strix G15',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 3999,
    originalPrice: 4999,
    description: 'ASUS ROG Strix G15 لابتوب ألعاب قوي مع كرت رسومات متقدم',
    descriptionEn: 'ASUS ROG Strix G15 Powerful Gaming Laptop with Advanced Graphics Card',
    brand: 'ASUS',
    rating: 4.7,
    reviewCount: 1123,
    inStock: true,
    stockCount: 27,
    images: [
      'https://m.media-amazon.com/images/I/81Z8g6IdHEL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'lenovo-thinkpad-x1-carbon',
    name: 'Lenovo ThinkPad X1 Carbon',
    nameEn: 'Lenovo ThinkPad X1 Carbon',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 5499,
    originalPrice: 6499,
    description: 'Lenovo ThinkPad X1 Carbon لابتوب أعمال خفيف الوزن وقوي الأداء',
    descriptionEn: 'Lenovo ThinkPad X1 Carbon Lightweight and Powerful Business Laptop',
    brand: 'Lenovo',
    rating: 4.6,
    reviewCount: 789,
    inStock: true,
    stockCount: 21,
    images: [
      'https://m.media-amazon.com/images/I/61C4JCMwYVL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'microsoft-surface-laptop-5',
    name: 'Microsoft Surface Laptop 5',
    nameEn: 'Microsoft Surface Laptop 5',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 4299,
    originalPrice: 5299,
    description: 'Microsoft Surface Laptop 5 مع تصميم أنيق وأداء موثوق',
    descriptionEn: 'Microsoft Surface Laptop 5 with Elegant Design and Reliable Performance',
    brand: 'Microsoft',
    rating: 4.4,
    reviewCount: 567,
    inStock: true,
    stockCount: 18,
    images: [
      'https://m.media-amazon.com/images/I/61sX5I8tYEL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'acer-predator-helios-300',
    name: 'Acer Predator Helios 300',
    nameEn: 'Acer Predator Helios 300',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 3499,
    originalPrice: 4499,
    description: 'Acer Predator Helios 300 لابتوب ألعاب بأداء عالي وسعر مناسب',
    descriptionEn: 'Acer Predator Helios 300 High-Performance Gaming Laptop at Affordable Price',
    brand: 'Acer',
    rating: 4.5,
    reviewCount: 945,
    inStock: true,
    stockCount: 33,
    images: [
      'https://m.media-amazon.com/images/I/71v2aYHfhFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'macbook-air-m2',
    name: 'MacBook Air M2',
    nameEn: 'MacBook Air M2',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 4999,
    originalPrice: 5999,
    description: 'MacBook Air مع معالج M2 - خفيف الوزن وقوي الأداء',
    descriptionEn: 'MacBook Air with M2 chip - Lightweight and Powerful Performance',
    brand: 'Apple',
    rating: 4.8,
    reviewCount: 2134,
    inStock: true,
    stockCount: 29,
    images: [
      'https://m.media-amazon.com/images/I/719C6aTaKRL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'hp-pavilion-gaming',
    name: 'HP Pavilion Gaming',
    nameEn: 'HP Pavilion Gaming',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 2999,
    originalPrice: 3999,
    description: 'HP Pavilion Gaming لابتوب ألعاب بسعر مناسب للمبتدئين',
    descriptionEn: 'HP Pavilion Gaming Laptop at Affordable Price for Beginners',
    brand: 'HP',
    rating: 4.3,
    reviewCount: 1567,
    inStock: true,
    stockCount: 41,
    images: [
      'https://m.media-amazon.com/images/I/61Xv5kvtkuL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  },
  {
    id: 'asus-zenbook-14',
    name: 'ASUS ZenBook 14',
    nameEn: 'ASUS ZenBook 14',
    category: 'لاب توب',
    categoryEn: 'laptops',
    price: 3799,
    originalPrice: 4799,
    description: 'ASUS ZenBook 14 لابتوب أنيق ومحمول للاستخدام اليومي',
    descriptionEn: 'ASUS ZenBook 14 Elegant and Portable Laptop for Daily Use',
    brand: 'ASUS',
    rating: 4.4,
    reviewCount: 823,
    inStock: true,
    stockCount: 25,
    images: [
      'https://m.media-amazon.com/images/I/71J+4Qh4CFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ]
  }
];

// دالة لرفع صورة إلى Cloudinary
async function uploadImageToCloudinary(imageUrl, productId, imageIndex) {
  try {
    console.log(`📤 رفع الصورة ${imageIndex} للمنتج ${productId}...`);
    
    const result = await cloudinary.uploader.upload(imageUrl, {
      folder: 'gizmo_store/products',
      public_id: `${productId}_${imageIndex}`,
      overwrite: true,
      resource_type: 'image',
      format: 'jpg',
      quality: 'auto:good',
      fetch_format: 'auto'
    });

    console.log(`✅ تم رفع الصورة بنجاح: ${result.secure_url}`);
    return result.secure_url;
  } catch (error) {
    console.error(`❌ خطأ في رفع الصورة ${imageIndex} للمنتج ${productId}:`, error.message);
    return null;
  }
}

// دالة لرفع جميع صور منتج واحد
async function uploadProductImages(product) {
  console.log(`\n🔄 بدء رفع صور المنتج: ${product.name}`);
  
  const cloudinaryImages = [];
  
  for (let i = 0; i < product.images.length; i++) {
    const cloudinaryUrl = await uploadImageToCloudinary(
      product.images[i], 
      product.id, 
      i + 1
    );
    
    if (cloudinaryUrl) {
      cloudinaryImages.push(cloudinaryUrl);
    }
    
    // تأخير قصير لتجنب تجاوز حدود API
    await new Promise(resolve => setTimeout(resolve, 1000));
  }
  
  return cloudinaryImages;
}

// دالة لإضافة منتج إلى Firebase
async function addProductToFirebase(product, cloudinaryImages) {
  try {
    console.log(`📝 إضافة المنتج إلى Firebase: ${product.name}`);
    
    const productData = {
      ...product,
      images: cloudinaryImages,
      imageUrl: cloudinaryImages[0] || '', // الصورة الرئيسية
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };
    
    await db.collection('products').doc(product.id).set(productData);
    console.log(`✅ تم إضافة المنتج بنجاح: ${product.name}`);
    
    return true;
  } catch (error) {
    console.error(`❌ خطأ في إضافة المنتج ${product.name}:`, error.message);
    return false;
  }
}

// دالة لحذف الصور القديمة من Cloudinary
async function deleteOldImages() {
  try {
    console.log('\n🗑️ بدء حذف الصور القديمة من Cloudinary...');
    
    // الحصول على قائمة الصور في مجلد gizmo_store/products
    const result = await cloudinary.api.resources({
      type: 'upload',
      prefix: 'gizmo_store/products/',
      max_results: 500
    });
    
    if (result.resources && result.resources.length > 0) {
      console.log(`🔍 تم العثور على ${result.resources.length} صورة قديمة`);
      
      // حذف الصور بشكل مجمع
      const publicIds = result.resources.map(resource => resource.public_id);
      const deleteResult = await cloudinary.api.delete_resources(publicIds);
      
      console.log(`✅ تم حذف ${Object.keys(deleteResult.deleted).length} صورة قديمة`);
    } else {
      console.log('ℹ️ لا توجد صور قديمة للحذف');
    }
  } catch (error) {
    console.error('❌ خطأ في حذف الصور القديمة:', error.message);
  }
}

// الدالة الرئيسية
async function main() {
  console.log('🚀 بدء عملية رفع المنتجات من Figma Design إلى Cloudinary و Firebase...\n');
  
  let successCount = 0;
  let failCount = 0;
  
  // حذف الصور القديمة أولاً
  await deleteOldImages();
  
  console.log(`\n📦 سيتم رفع ${figmaProducts.length} منتج...\n`);
  
  for (let i = 0; i < figmaProducts.length; i++) {
    const product = figmaProducts[i];
    
    console.log(`\n[${i + 1}/${figmaProducts.length}] معالجة المنتج: ${product.name}`);
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    try {
      // رفع صور المنتج إلى Cloudinary
      const cloudinaryImages = await uploadProductImages(product);
      
      if (cloudinaryImages.length > 0) {
        // إضافة المنتج إلى Firebase
        const success = await addProductToFirebase(product, cloudinaryImages);
        
        if (success) {
          successCount++;
          console.log(`✅ تم إنجاز المنتج بنجاح: ${product.name}`);
        } else {
          failCount++;
          console.log(`❌ فشل في إضافة المنتج: ${product.name}`);
        }
      } else {
        failCount++;
        console.log(`❌ فشل في رفع صور المنتج: ${product.name}`);
      }
      
    } catch (error) {
      failCount++;
      console.error(`❌ خطأ في معالجة المنتج ${product.name}:`, error.message);
    }
    
    // تأخير بين المنتجات
    if (i < figmaProducts.length - 1) {
      console.log('⏳ انتظار 2 ثانية قبل المنتج التالي...');
      await new Promise(resolve => setTimeout(resolve, 2000));
    }
  }
  
  console.log('\n' + '='.repeat(60));
  console.log('📊 ملخص العملية:');
  console.log('='.repeat(60));
  console.log(`✅ المنتجات المضافة بنجاح: ${successCount}`);
  console.log(`❌ المنتجات الفاشلة: ${failCount}`);
  console.log(`📦 إجمالي المنتجات: ${figmaProducts.length}`);
  console.log('='.repeat(60));
  
  if (successCount > 0) {
    console.log('\n🎉 تم إنجاز العملية بنجاح! يمكنك الآن اختبار التطبيق لرؤية المنتجات الجديدة.');
  }
  
  process.exit(0);
}

// تشغيل السكريبت
main().catch(error => {
  console.error('❌ خطأ عام في السكريبت:', error);
  process.exit(1);
});