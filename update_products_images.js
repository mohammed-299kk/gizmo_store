// Import the functions you need from the SDKs you need
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, deleteDoc, doc, getDocs, writeBatch, serverTimestamp } from 'firebase/firestore';

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyBKqKZKqKZKqKZKqKZKqKZKqKZKqKZKqKZ",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  databaseURL: "https://gizmostore-2a3ff-default-rtdb.firebaseio.com",
  projectId: "gizmostore-2a3ff",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdefghijklmnop"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Updated product data with high-quality Cloudinary images
const products = [
  // Smartphones
  {
    id: 'iphone-15-pro',
    name: 'iPhone 15 Pro',
    nameAr: 'آيفون 15 برو',
    description: 'Latest iPhone with A17 Pro chip and titanium design',
    descriptionAr: 'أحدث آيفون مع معالج A17 Pro وتصميم التيتانيوم',
    price: 999,
    originalPrice: 1099,
    category: 'smartphones',
    categoryAr: 'هواتف ذكية',
    brand: 'Apple',
    brandAr: 'آبل',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/iphone-15-pro.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/iphone-15-pro-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/iphone-15-pro-2.jpg'
    ],
    inStock: true,
    stockQuantity: 50,
    rating: 4.8,
    reviewCount: 245,
    specifications: {
      screen: '6.1 inch Super Retina XDR',
      processor: 'A17 Pro',
      storage: '128GB',
      camera: '48MP Triple Camera',
      battery: '3274 mAh'
    },
    features: ['5G', 'Face ID', 'Wireless Charging', 'Water Resistant']
  },
  {
    id: 'samsung-galaxy-s24',
    name: 'Samsung Galaxy S24',
    nameAr: 'سامسونج جالاكسي S24',
    description: 'Premium Android smartphone with AI features',
    descriptionAr: 'هاتف أندرويد متميز مع ميزات الذكاء الاصطناعي',
    price: 799,
    originalPrice: 899,
    category: 'smartphones',
    categoryAr: 'هواتف ذكية',
    brand: 'Samsung',
    brandAr: 'سامسونج',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/galaxy-s24.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/galaxy-s24-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/galaxy-s24-2.jpg'
    ],
    inStock: true,
    stockQuantity: 35,
    rating: 4.6,
    reviewCount: 189,
    specifications: {
      screen: '6.2 inch Dynamic AMOLED',
      processor: 'Snapdragon 8 Gen 3',
      storage: '256GB',
      camera: '50MP Triple Camera',
      battery: '4000 mAh'
    },
    features: ['5G', 'S Pen Support', 'Wireless Charging', 'IP68']
  },
  {
    id: 'google-pixel-8',
    name: 'Google Pixel 8',
    nameAr: 'جوجل بيكسل 8',
    description: 'Pure Android experience with advanced AI photography',
    descriptionAr: 'تجربة أندرويد نقية مع تصوير ذكي متقدم',
    price: 699,
    originalPrice: 799,
    category: 'smartphones',
    categoryAr: 'هواتف ذكية',
    brand: 'Google',
    brandAr: 'جوجل',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/pixel-8.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/pixel-8-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/pixel-8-2.jpg'
    ],
    inStock: true,
    stockQuantity: 25,
    rating: 4.7,
    reviewCount: 156,
    specifications: {
      screen: '6.2 inch OLED',
      processor: 'Google Tensor G3',
      storage: '128GB',
      camera: '50MP Dual Camera',
      battery: '4575 mAh'
    },
    features: ['5G', 'Pure Android', 'AI Photography', 'Wireless Charging']
  },

  // Laptops
  {
    id: 'macbook-pro-m3',
    name: 'MacBook Pro M3',
    nameAr: 'ماك بوك برو M3',
    description: 'Professional laptop with M3 chip for ultimate performance',
    descriptionAr: 'لابتوب احترافي مع معالج M3 للأداء الفائق',
    price: 1599,
    originalPrice: 1799,
    category: 'laptops',
    categoryAr: 'لابتوبات',
    brand: 'Apple',
    brandAr: 'آبل',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/macbook-pro-m3.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/macbook-pro-m3-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/macbook-pro-m3-2.jpg'
    ],
    inStock: true,
    stockQuantity: 15,
    rating: 4.9,
    reviewCount: 89,
    specifications: {
      screen: '14 inch Liquid Retina XDR',
      processor: 'Apple M3',
      memory: '16GB',
      storage: '512GB SSD',
      graphics: 'M3 GPU'
    },
    features: ['Touch ID', 'Magic Keyboard', 'Force Touch Trackpad', 'Thunderbolt 4']
  },
  {
    id: 'dell-xps-13',
    name: 'Dell XPS 13',
    nameAr: 'ديل XPS 13',
    description: 'Ultra-portable laptop with stunning display',
    descriptionAr: 'لابتوب فائق الحمولة مع شاشة مذهلة',
    price: 999,
    originalPrice: 1199,
    category: 'laptops',
    categoryAr: 'لابتوبات',
    brand: 'Dell',
    brandAr: 'ديل',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/dell-xps-13.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/dell-xps-13-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/dell-xps-13-2.jpg'
    ],
    inStock: true,
    stockQuantity: 20,
    rating: 4.5,
    reviewCount: 134,
    specifications: {
      screen: '13.4 inch InfinityEdge',
      processor: 'Intel Core i7',
      memory: '16GB',
      storage: '512GB SSD',
      graphics: 'Intel Iris Xe'
    },
    features: ['Fingerprint Reader', 'Backlit Keyboard', 'Wi-Fi 6E', 'USB-C']
  },
  {
    id: 'hp-spectre-x360',
    name: 'HP Spectre x360',
    nameAr: 'HP سبيكتر x360',
    description: '2-in-1 convertible laptop with premium design',
    descriptionAr: 'لابتوب قابل للتحويل 2 في 1 بتصميم متميز',
    price: 1299,
    originalPrice: 1499,
    category: 'laptops',
    categoryAr: 'لابتوبات',
    brand: 'HP',
    brandAr: 'HP',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/hp-spectre-x360.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/hp-spectre-x360-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/hp-spectre-x360-2.jpg'
    ],
    inStock: true,
    stockQuantity: 12,
    rating: 4.4,
    reviewCount: 98,
    specifications: {
      screen: '13.5 inch OLED Touch',
      processor: 'Intel Core i7',
      memory: '16GB',
      storage: '1TB SSD',
      graphics: 'Intel Iris Xe'
    },
    features: ['360° Hinge', 'Pen Support', 'Bang & Olufsen Audio', 'Privacy Camera']
  },

  // Tablets
  {
    id: 'ipad-pro-m2',
    name: 'iPad Pro M2',
    nameAr: 'آيباد برو M2',
    description: 'Professional tablet with M2 chip and Liquid Retina display',
    descriptionAr: 'تابلت احترافي مع معالج M2 وشاشة Liquid Retina',
    price: 799,
    originalPrice: 899,
    category: 'tablets',
    categoryAr: 'أجهزة لوحية',
    brand: 'Apple',
    brandAr: 'آبل',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/ipad-pro-m2.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/ipad-pro-m2-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/ipad-pro-m2-2.jpg'
    ],
    inStock: true,
    stockQuantity: 30,
    rating: 4.8,
    reviewCount: 167,
    specifications: {
      screen: '11 inch Liquid Retina',
      processor: 'Apple M2',
      storage: '128GB',
      camera: '12MP + 10MP Ultra Wide',
      connectivity: 'Wi-Fi 6E'
    },
    features: ['Apple Pencil Support', 'Magic Keyboard Compatible', 'Face ID', 'USB-C']
  },
  {
    id: 'samsung-tab-s9',
    name: 'Samsung Galaxy Tab S9',
    nameAr: 'سامسونج جالاكسي تاب S9',
    description: 'Premium Android tablet with S Pen included',
    descriptionAr: 'تابلت أندرويد متميز مع قلم S Pen مرفق',
    price: 649,
    originalPrice: 749,
    category: 'tablets',
    categoryAr: 'أجهزة لوحية',
    brand: 'Samsung',
    brandAr: 'سامسونج',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/galaxy-tab-s9.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/galaxy-tab-s9-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/galaxy-tab-s9-2.jpg'
    ],
    inStock: true,
    stockQuantity: 25,
    rating: 4.6,
    reviewCount: 123,
    specifications: {
      screen: '11 inch Dynamic AMOLED 2X',
      processor: 'Snapdragon 8 Gen 2',
      storage: '128GB',
      camera: '13MP + 6MP Ultra Wide',
      connectivity: 'Wi-Fi 6E'
    },
    features: ['S Pen Included', 'DeX Mode', 'IP68 Rating', 'Fast Charging']
  },

  // Smart Watches
  {
    id: 'apple-watch-series-9',
    name: 'Apple Watch Series 9',
    nameAr: 'آبل واتش سيريز 9',
    description: 'Advanced smartwatch with health monitoring',
    descriptionAr: 'ساعة ذكية متقدمة مع مراقبة صحية',
    price: 399,
    originalPrice: 449,
    category: 'smartwatches',
    categoryAr: 'ساعات ذكية',
    brand: 'Apple',
    brandAr: 'آبل',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/apple-watch-series-9.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/apple-watch-series-9-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/apple-watch-series-9-2.jpg'
    ],
    inStock: true,
    stockQuantity: 40,
    rating: 4.7,
    reviewCount: 234,
    specifications: {
      display: '45mm Retina Display',
      processor: 'S9 SiP',
      storage: '64GB',
      connectivity: 'GPS + Cellular',
      battery: '18 hours'
    },
    features: ['ECG', 'Blood Oxygen', 'Sleep Tracking', 'Water Resistant']
  },
  {
    id: 'samsung-galaxy-watch-6',
    name: 'Samsung Galaxy Watch 6',
    nameAr: 'سامسونج جالاكسي واتش 6',
    description: 'Feature-rich smartwatch for Android users',
    descriptionAr: 'ساعة ذكية غنية بالميزات لمستخدمي أندرويد',
    price: 329,
    originalPrice: 379,
    category: 'smartwatches',
    categoryAr: 'ساعات ذكية',
    brand: 'Samsung',
    brandAr: 'سامسونج',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/galaxy-watch-6.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/galaxy-watch-6-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/galaxy-watch-6-2.jpg'
    ],
    inStock: true,
    stockQuantity: 35,
    rating: 4.5,
    reviewCount: 178,
    specifications: {
      display: '44mm Super AMOLED',
      processor: 'Exynos W930',
      storage: '16GB',
      connectivity: 'Bluetooth + Wi-Fi',
      battery: '40 hours'
    },
    features: ['Body Composition', 'Sleep Coaching', 'GPS', 'Water Resistant']
  },

  // Headphones
  {
    id: 'airpods-pro-2',
    name: 'AirPods Pro 2nd Gen',
    nameAr: 'إيربودز برو الجيل الثاني',
    description: 'Premium wireless earbuds with active noise cancellation',
    descriptionAr: 'سماعات لاسلكية متميزة مع إلغاء الضوضاء النشط',
    price: 249,
    originalPrice: 279,
    category: 'headphones',
    categoryAr: 'سماعات',
    brand: 'Apple',
    brandAr: 'آبل',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/airpods-pro-2.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/airpods-pro-2-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/airpods-pro-2-2.jpg'
    ],
    inStock: true,
    stockQuantity: 60,
    rating: 4.8,
    reviewCount: 345,
    specifications: {
      driver: 'Custom Apple Driver',
      battery: '6 hours + 24 hours case',
      connectivity: 'Bluetooth 5.3',
      features: 'Active Noise Cancellation',
      charging: 'Lightning + Wireless'
    },
    features: ['Spatial Audio', 'Adaptive Transparency', 'Sweat Resistant', 'Find My']
  },
  {
    id: 'sony-wh-1000xm5',
    name: 'Sony WH-1000XM5',
    nameAr: 'سوني WH-1000XM5',
    description: 'Industry-leading noise canceling headphones',
    descriptionAr: 'سماعات رائدة في إلغاء الضوضاء',
    price: 349,
    originalPrice: 399,
    category: 'headphones',
    categoryAr: 'سماعات',
    brand: 'Sony',
    brandAr: 'سوني',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/sony-wh-1000xm5.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/sony-wh-1000xm5-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/sony-wh-1000xm5-2.jpg'
    ],
    inStock: true,
    stockQuantity: 45,
    rating: 4.7,
    reviewCount: 267,
    specifications: {
      driver: '30mm Dynamic',
      battery: '30 hours',
      connectivity: 'Bluetooth 5.2',
      features: 'Industry-leading ANC',
      charging: 'USB-C + Quick Charge'
    },
    features: ['LDAC Support', 'Multipoint Connection', 'Touch Controls', 'Foldable']
  },
  {
    id: 'bose-quietcomfort-45',
    name: 'Bose QuietComfort 45',
    nameAr: 'بوز كوايت كومفورت 45',
    description: 'Comfortable noise canceling headphones for all-day wear',
    descriptionAr: 'سماعات مريحة لإلغاء الضوضاء للارتداء طوال اليوم',
    price: 279,
    originalPrice: 329,
    category: 'headphones',
    categoryAr: 'سماعات',
    brand: 'Bose',
    brandAr: 'بوز',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/bose-qc45.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/bose-qc45-1.jpg',
      'https://res.cloudinary.com/demo/image/upload/v1640123456/bose-qc45-2.jpg'
    ],
    inStock: true,
    stockQuantity: 30,
    rating: 4.6,
    reviewCount: 198,
    specifications: {
      driver: 'TriPort Acoustic',
      battery: '24 hours',
      connectivity: 'Bluetooth 5.1',
      features: 'Quiet & Aware Modes',
      charging: 'USB-C'
    },
    features: ['Comfortable Fit', 'Voice Assistant', 'Foldable', 'Quick Charge']
  },

  // Accessories
  {
    id: 'magsafe-charger',
    name: 'MagSafe Charger',
    nameAr: 'شاحن ماج سيف',
    description: 'Wireless charger for iPhone with magnetic alignment',
    descriptionAr: 'شاحن لاسلكي للآيفون مع محاذاة مغناطيسية',
    price: 39,
    originalPrice: 49,
    category: 'accessories',
    categoryAr: 'إكسسوارات',
    brand: 'Apple',
    brandAr: 'آبل',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/magsafe-charger.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/magsafe-charger-1.jpg'
    ],
    inStock: true,
    stockQuantity: 100,
    rating: 4.5,
    reviewCount: 456,
    specifications: {
      power: '15W Wireless Charging',
      compatibility: 'iPhone 12 and later',
      cable: '1m USB-C to Lightning',
      material: 'Aluminum and Glass'
    },
    features: ['Magnetic Alignment', 'Fast Charging', 'Compact Design', 'Case Compatible']
  },
  {
    id: 'anker-powerbank',
    name: 'Anker PowerCore 10000',
    nameAr: 'أنكر باور كور 10000',
    description: 'Compact portable charger with fast charging',
    descriptionAr: 'شاحن محمول مدمج مع شحن سريع',
    price: 29,
    originalPrice: 39,
    category: 'accessories',
    categoryAr: 'إكسسوارات',
    brand: 'Anker',
    brandAr: 'أنكر',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/anker-powercore.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/anker-powercore-1.jpg'
    ],
    inStock: true,
    stockQuantity: 80,
    rating: 4.7,
    reviewCount: 789,
    specifications: {
      capacity: '10000mAh',
      output: '12W Max',
      input: 'Micro USB',
      weight: '180g'
    },
    features: ['PowerIQ Technology', 'Compact Size', 'MultiProtect Safety', 'LED Indicator']
  },
  {
    id: 'belkin-car-mount',
    name: 'Belkin Car Mount',
    nameAr: 'حامل سيارة بيلكين',
    description: 'Secure phone mount for car dashboard',
    descriptionAr: 'حامل آمن للهاتف في لوحة القيادة',
    price: 19,
    originalPrice: 29,
    category: 'accessories',
    categoryAr: 'إكسسوارات',
    brand: 'Belkin',
    brandAr: 'بيلكين',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/belkin-car-mount.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/belkin-car-mount-1.jpg'
    ],
    inStock: true,
    stockQuantity: 50,
    rating: 4.3,
    reviewCount: 234,
    specifications: {
      compatibility: 'Universal',
      mounting: 'Dashboard/Windshield',
      adjustment: '360° Rotation',
      material: 'ABS Plastic'
    },
    features: ['One-Touch Release', 'Adjustable Arms', 'Stable Grip', 'Easy Installation']
  },
  {
    id: 'spigen-phone-case',
    name: 'Spigen Tough Armor Case',
    nameAr: 'كفر سبيجن توف آرمور',
    description: 'Heavy-duty protection case for smartphones',
    descriptionAr: 'كفر حماية قوي للهواتف الذكية',
    price: 25,
    originalPrice: 35,
    category: 'accessories',
    categoryAr: 'إكسسوارات',
    brand: 'Spigen',
    brandAr: 'سبيجن',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/spigen-case.jpg',
    images: [
      'https://res.cloudinary.com/demo/image/upload/v1640123456/spigen-case-1.jpg'
    ],
    inStock: true,
    stockQuantity: 75,
    rating: 4.6,
    reviewCount: 567,
    specifications: {
      material: 'TPU + PC',
      protection: 'Military Grade',
      features: 'Kickstand',
      compatibility: 'Multiple Models'
    },
    features: ['Drop Protection', 'Raised Bezels', 'Precise Cutouts', 'Wireless Charging Compatible']
  }
];

// Categories data with Arabic translations
const categories = [
  {
    id: 'smartphones',
    name: 'Smartphones',
    nameAr: 'هواتف ذكية',
    description: 'Latest smartphones from top brands',
    descriptionAr: 'أحدث الهواتف الذكية من أفضل العلامات التجارية',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/category-smartphones.jpg',
    productCount: 0
  },
  {
    id: 'laptops',
    name: 'Laptops',
    nameAr: 'لابتوبات',
    description: 'High-performance laptops for work and gaming',
    descriptionAr: 'لابتوبات عالية الأداء للعمل والألعاب',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/category-laptops.jpg',
    productCount: 0
  },
  {
    id: 'tablets',
    name: 'Tablets',
    nameAr: 'أجهزة لوحية',
    description: 'Versatile tablets for productivity and entertainment',
    descriptionAr: 'أجهزة لوحية متعددة الاستخدامات للإنتاجية والترفيه',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/category-tablets.jpg',
    productCount: 0
  },
  {
    id: 'smartwatches',
    name: 'Smart Watches',
    nameAr: 'ساعات ذكية',
    description: 'Advanced smartwatches for health and fitness',
    descriptionAr: 'ساعات ذكية متقدمة للصحة واللياقة البدنية',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/category-smartwatches.jpg',
    productCount: 0
  },
  {
    id: 'headphones',
    name: 'Headphones',
    nameAr: 'سماعات',
    description: 'Premium audio devices and headphones',
    descriptionAr: 'أجهزة صوتية وسماعات متميزة',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/category-headphones.jpg',
    productCount: 0
  },
  {
    id: 'accessories',
    name: 'Accessories',
    nameAr: 'إكسسوارات',
    description: 'Essential accessories for your devices',
    descriptionAr: 'إكسسوارات أساسية لأجهزتك',
    imageUrl: 'https://res.cloudinary.com/demo/image/upload/v1640123456/category-accessories.jpg',
    productCount: 0
  }
];

// Function to delete all existing products
async function deleteAllProducts() {
  try {
    console.log('🗑️ Deleting existing products...');
    const productsSnapshot = await getDocs(collection(db, 'products'));
    const batch = writeBatch(db);
    
    productsSnapshot.docs.forEach(docSnapshot => {
      batch.delete(docSnapshot.ref);
    });
    
    await batch.commit();
    console.log(`✅ Deleted ${productsSnapshot.docs.length} existing products`);
  } catch (error) {
    console.error('Error deleting products:', error);
  }
}

// Function to delete all existing categories
async function deleteAllCategories() {
  try {
    console.log('🗑️ Deleting existing categories...');
    const categoriesSnapshot = await getDocs(collection(db, 'categories'));
    const batch = writeBatch(db);
    
    categoriesSnapshot.docs.forEach(docSnapshot => {
      batch.delete(docSnapshot.ref);
    });
    
    await batch.commit();
    console.log(`✅ Deleted ${categoriesSnapshot.docs.length} existing categories`);
  } catch (error) {
    console.error('Error deleting categories:', error);
  }
}

// Function to add products to Firestore
async function addProducts() {
  try {
    console.log('📱 Adding products with high-quality Cloudinary images...');
    const batch = writeBatch(db);
    
    products.forEach(product => {
      const productRef = doc(db, 'products', product.id);
      batch.set(productRef, {
        ...product,
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp()
      });
    });
    
    await batch.commit();
    console.log(`✅ Added ${products.length} products successfully`);
  } catch (error) {
    console.error('Error adding products:', error);
  }
}

// Function to add categories to Firestore
async function addCategories() {
  try {
    console.log('📂 Adding organized categories...');
    
    // Count products per category
    const categoryProductCount = {};
    products.forEach(product => {
      categoryProductCount[product.category] = (categoryProductCount[product.category] || 0) + 1;
    });
    
    const batch = writeBatch(db);
    
    categories.forEach(category => {
      const categoryRef = doc(db, 'categories', category.id);
      batch.set(categoryRef, {
        ...category,
        productCount: categoryProductCount[category.id] || 0,
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp()
      });
    });
    
    await batch.commit();
    console.log(`✅ Added ${categories.length} categories successfully`);
  } catch (error) {
    console.error('Error adding categories:', error);
  }
}

// Main function to update products and categories
async function updateProductsAndCategories() {
  try {
    console.log('🚀 Starting products and categories update...');
    
    // Delete existing data
    await deleteAllProducts();
    await deleteAllCategories();
    
    // Add new data
    await addProducts();
    await addCategories();
    
    console.log('\n✅ Successfully updated all products and categories!');
    console.log('📱 Products are now properly categorized with high-quality Cloudinary images');
    
    // Display category summary
    console.log('\n📊 Category Summary:');
    const categoryProductCount = {};
    products.forEach(product => {
      categoryProductCount[product.category] = (categoryProductCount[product.category] || 0) + 1;
    });
    
    categories.forEach(category => {
      const count = categoryProductCount[category.id] || 0;
      console.log(`   ${category.nameAr}: ${count} منتج`);
    });
    
  } catch (error) {
    console.error('Error updating products and categories:', error);
  }
}

// Run the update
updateProductsAndCategories();