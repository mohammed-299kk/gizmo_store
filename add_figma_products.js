import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, writeBatch, doc } from 'firebase/firestore';

// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyAo4-Ge1dC4LnIyG_wUjYgWc9KHCxEYUxM",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  projectId: "gizmostore-2a3ff",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  messagingSenderId: "32902740595",
  appId: "1:32902740595:web:7de8f1273a64f9f28fc806"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// جميع المنتجات الـ 60 من ملف figma-design
const allProducts = [
  // سماعات (8 منتجات)
  {
    id: "sony-wh-1000xm5",
    name: "Sony WH-1000XM5",
    description: "سماعات لاسلكية بتقنية إلغاء الضوضاء المتقدمة من سوني",
    price: 1299,
    originalPrice: 1499,
    category: "سماعات",
    brand: "Sony",
    rating: 4.8,
    reviewCount: 245,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/61+btTzpKuL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61jBaCpLJfL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61QbqjJJpfL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61Ks8JQJJJL._AC_SL1500_.jpg"
    ],
    specifications: {
      connectivity: "Bluetooth 5.2",
      batteryLife: "30 ساعة",
      noiseCancellation: "نعم",
      weight: "250g"
    }
  },
  {
    id: "airpods-pro-2",
    name: "Apple AirPods Pro 2",
    description: "سماعات أبل اللاسلكية مع إلغاء الضوضاء النشط",
    price: 899,
    originalPrice: 999,
    category: "سماعات",
    brand: "Apple",
    rating: 4.7,
    reviewCount: 189,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61f1YfTkTtL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61jKKfnpU3L._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61QKKfnpU3L._AC_SL1500_.jpg"
    ],
    specifications: {
      connectivity: "Bluetooth 5.3",
      batteryLife: "6 ساعات + 24 مع العلبة",
      noiseCancellation: "نعم",
      weight: "5.3g لكل سماعة"
    }
  },
  {
    id: "bose-qc45",
    name: "Bose QuietComfort 45",
    description: "سماعات بوز مع تقنية إلغاء الضوضاء الرائدة",
    price: 1199,
    originalPrice: 1399,
    category: "سماعات",
    brand: "Bose",
    rating: 4.6,
    reviewCount: 156,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/51Ddmj+kkdL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/51Ddmj+kkdL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/51Ddmj+kkdL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/51Ddmj+kkdL._AC_SL1500_.jpg"
    ],
    specifications: {
      connectivity: "Bluetooth 5.1",
      batteryLife: "24 ساعة",
      noiseCancellation: "نعم",
      weight: "238g"
    }
  },
  {
    id: "jbl-tune-760nc",
    name: "JBL Tune 760NC",
    description: "سماعات JBL لاسلكية مع إلغاء الضوضاء النشط",
    price: 399,
    originalPrice: 499,
    category: "سماعات",
    brand: "JBL",
    rating: 4.4,
    reviewCount: 98,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/61vv9d9yvYL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61vv9d9yvYL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61vv9d9yvYL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61vv9d9yvYL._AC_SL1500_.jpg"
    ],
    specifications: {
      connectivity: "Bluetooth 5.0",
      batteryLife: "35 ساعة",
      noiseCancellation: "نعم",
      weight: "220g"
    }
  },
  {
    id: "sennheiser-hd-450bt",
    name: "Sennheiser HD 450BT",
    description: "سماعات سنهايزر اللاسلكية بجودة صوت عالية",
    price: 599,
    originalPrice: 699,
    category: "سماعات",
    brand: "Sennheiser",
    rating: 4.5,
    reviewCount: 134,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/61Zr9WqiGuL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61Zr9WqiGuL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61Zr9WqiGuL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61Zr9WqiGuL._AC_SL1500_.jpg"
    ],
    specifications: {
      connectivity: "Bluetooth 5.0",
      batteryLife: "30 ساعة",
      noiseCancellation: "نعم",
      weight: "238g"
    }
  },
  {
    id: "beats-studio3",
    name: "Beats Studio3 Wireless",
    description: "سماعات بيتس اللاسلكية مع تقنية Pure ANC",
    price: 799,
    originalPrice: 999,
    category: "سماعات",
    brand: "Beats",
    rating: 4.3,
    reviewCount: 167,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/51UJ71S4ixL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/51UJ71S4ixL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/51UJ71S4ixL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/51UJ71S4ixL._AC_SL1500_.jpg"
    ],
    specifications: {
      connectivity: "Bluetooth",
      batteryLife: "22 ساعة",
      noiseCancellation: "نعم",
      weight: "260g"
    }
  },
  {
    id: "audio-technica-ath-m50xbt2",
    name: "Audio-Technica ATH-M50xBT2",
    description: "سماعات أوديو تكنيكا المحترفة اللاسلكية",
    price: 699,
    originalPrice: 799,
    category: "سماعات",
    brand: "Audio-Technica",
    rating: 4.6,
    reviewCount: 89,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg"
    ],
    specifications: {
      connectivity: "Bluetooth 5.0",
      batteryLife: "50 ساعة",
      noiseCancellation: "لا",
      weight: "307g"
    }
  },
  {
    id: "skullcandy-crusher-evo",
    name: "Skullcandy Crusher Evo",
    description: "سماعات سكل كاندي مع تقنية الاهتزاء الحسي",
    price: 499,
    originalPrice: 599,
    category: "سماعات",
    brand: "Skullcandy",
    rating: 4.2,
    reviewCount: 76,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      connectivity: "Bluetooth 5.0",
      batteryLife: "40 ساعة",
      noiseCancellation: "لا",
      weight: "274g"
    }
  },

  // لاب توب (8 منتجات)
  {
    id: "macbook-air-m2",
    name: "MacBook Air M2",
    description: "لاب توب أبل ماك بوك إير بمعالج M2 الجديد",
    price: 4999,
    originalPrice: 5499,
    category: "لاب توب",
    brand: "Apple",
    rating: 4.9,
    reviewCount: 312,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Apple M2",
      ram: "8GB",
      storage: "256GB SSD",
      screen: "13.6 بوصة Liquid Retina"
    }
  },
  {
    id: "dell-xps-13",
    name: "Dell XPS 13",
    description: "لاب توب ديل XPS 13 بتصميم أنيق وأداء قوي",
    price: 3999,
    originalPrice: 4499,
    category: "لاب توب",
    brand: "Dell",
    rating: 4.7,
    reviewCount: 198,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Intel Core i7-1260P",
      ram: "16GB",
      storage: "512GB SSD",
      screen: "13.4 بوصة FHD+"
    }
  },
  {
    id: "hp-spectre-x360",
    name: "HP Spectre x360",
    description: "لاب توب HP قابل للتحويل مع شاشة لمس",
    price: 4299,
    originalPrice: 4799,
    category: "لاب توب",
    brand: "HP",
    rating: 4.6,
    reviewCount: 156,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Intel Core i7-1255U",
      ram: "16GB",
      storage: "512GB SSD",
      screen: "13.5 بوصة OLED Touch"
    }
  },
  {
    id: "lenovo-thinkpad-x1",
    name: "Lenovo ThinkPad X1 Carbon",
    description: "لاب توب لينوفو للأعمال بتصميم متين",
    price: 5299,
    originalPrice: 5799,
    category: "لاب توب",
    brand: "Lenovo",
    rating: 4.8,
    reviewCount: 234,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/61HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Intel Core i7-1260P",
      ram: "16GB",
      storage: "1TB SSD",
      screen: "14 بوصة WUXGA"
    }
  },
  {
    id: "asus-zenbook-14",
    name: "ASUS ZenBook 14",
    description: "لاب توب أسوس زين بوك بتصميم أنيق وخفيف",
    price: 3499,
    originalPrice: 3899,
    category: "لاب توب",
    brand: "ASUS",
    rating: 4.5,
    reviewCount: 167,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Intel Core i5-1240P",
      ram: "8GB",
      storage: "512GB SSD",
      screen: "14 بوصة FHD"
    }
  },
  {
    id: "acer-swift-3",
    name: "Acer Swift 3",
    description: "لاب توب أيسر سويفت بأداء ممتاز وسعر مناسب",
    price: 2799,
    originalPrice: 3199,
    category: "لاب توب",
    brand: "Acer",
    rating: 4.3,
    reviewCount: 189,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "AMD Ryzen 7 5700U",
      ram: "8GB",
      storage: "512GB SSD",
      screen: "14 بوصة FHD IPS"
    }
  },
  {
    id: "microsoft-surface-laptop-5",
    name: "Microsoft Surface Laptop 5",
    description: "لاب توب مايكروسوفت سيرفيس بتصميم أنيق",
    price: 4599,
    originalPrice: 4999,
    category: "لاب توب",
    brand: "Microsoft",
    rating: 4.7,
    reviewCount: 145,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Intel Core i7-1255U",
      ram: "16GB",
      storage: "512GB SSD",
      screen: "13.5 بوصة PixelSense"
    }
  },
  {
    id: "msi-modern-14",
    name: "MSI Modern 14",
    description: "لاب توب MSI مودرن للاستخدام اليومي",
    price: 2999,
    originalPrice: 3399,
    category: "لاب توب",
    brand: "MSI",
    rating: 4.4,
    reviewCount: 98,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Intel Core i5-1235U",
      ram: "8GB",
      storage: "512GB SSD",
      screen: "14 بوصة FHD"
    }
  },

  // هواتف (16 منتج)
  {
    id: "iphone-15-pro",
    name: "iPhone 15 Pro",
    description: "أحدث هاتف من أبل بمعالج A17 Pro",
    price: 4299,
    originalPrice: 4599,
    category: "هواتف",
    brand: "Apple",
    rating: 4.8,
    reviewCount: 456,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "A17 Pro",
      ram: "8GB",
      storage: "128GB",
      screen: "6.1 بوصة Super Retina XDR"
    }
  },
  {
    id: "samsung-galaxy-s24",
    name: "Samsung Galaxy S24",
    description: "هاتف سامسونج جالاكسي S24 بتقنية الذكاء الاصطناعي",
    price: 3299,
    originalPrice: 3599,
    category: "هواتف",
    brand: "Samsung",
    rating: 4.6,
    reviewCount: 234,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Snapdragon 8 Gen 3",
      ram: "8GB",
      storage: "256GB",
      screen: "6.2 بوصة Dynamic AMOLED 2X"
    }
  },
  {
    id: "google-pixel-8",
    name: "Google Pixel 8",
    description: "هاتف جوجل بيكسل 8 بكاميرا ذكية",
    price: 2799,
    originalPrice: 2999,
    category: "هواتف",
    brand: "Google",
    rating: 4.5,
    reviewCount: 178,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Google Tensor G3",
      ram: "8GB",
      storage: "128GB",
      screen: "6.2 بوصة OLED"
    }
  },
  {
    id: "oneplus-12",
    name: "OnePlus 12",
    description: "هاتف ون بلس 12 بأداء فائق وشحن سريع",
    price: 3199,
    originalPrice: 3499,
    category: "هواتف",
    brand: "OnePlus",
    rating: 4.7,
    reviewCount: 156,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Snapdragon 8 Gen 3",
      ram: "12GB",
      storage: "256GB",
      screen: "6.82 بوصة LTPO AMOLED"
    }
  },
  {
    id: "xiaomi-14",
    name: "Xiaomi 14",
    description: "هاتف شاومي 14 بكاميرا ليكا المتطورة",
    price: 2599,
    originalPrice: 2899,
    category: "هواتف",
    brand: "Xiaomi",
    rating: 4.4,
    reviewCount: 189,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Snapdragon 8 Gen 3",
      ram: "8GB",
      storage: "256GB",
      screen: "6.36 بوصة LTPO OLED"
    }
  },
  {
    id: "oppo-find-x7",
    name: "OPPO Find X7",
    description: "هاتف أوبو فايند X7 بتصميم أنيق وكاميرا احترافية",
    price: 2999,
    originalPrice: 3299,
    category: "هواتف",
    brand: "OPPO",
    rating: 4.3,
    reviewCount: 134,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "MediaTek Dimensity 9300",
      ram: "12GB",
      storage: "256GB",
      screen: "6.78 بوصة LTPO AMOLED"
    }
  },
  {
    id: "vivo-x100",
    name: "Vivo X100",
    description: "هاتف فيفو X100 بكاميرا زايس المتطورة",
    price: 2799,
    originalPrice: 3099,
    category: "هواتف",
    brand: "Vivo",
    rating: 4.5,
    reviewCount: 112,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "MediaTek Dimensity 9300",
      ram: "12GB",
      storage: "256GB",
      screen: "6.78 بوصة LTPO AMOLED"
    }
  },
  {
    id: "honor-magic-6",
    name: "Honor Magic 6",
    description: "هاتف هونر ماجيك 6 بتقنيات الذكاء الاصطناعي",
    price: 2399,
    originalPrice: 2699,
    category: "هواتف",
    brand: "Honor",
    rating: 4.2,
    reviewCount: 98,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Snapdragon 8 Gen 3",
      ram: "8GB",
      storage: "256GB",
      screen: "6.78 بوصة LTPO OLED"
    }
  },

  // تابلت (8 منتجات)
  {
    id: "ipad-pro-12-9",
    name: "iPad Pro 12.9\"",
    description: "تابلت أبل آيباد برو بشاشة 12.9 بوصة ومعالج M2",
    price: 4599,
    originalPrice: 4999,
    category: "تابلت",
    brand: "Apple",
    rating: 4.8,
    reviewCount: 267,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/81Vf+2vOHyL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/81Vf+2vOHyL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/81Vf+2vOHyL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/81Vf+2vOHyL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Apple M2",
      ram: "8GB",
      storage: "128GB",
      screen: "12.9 بوصة Liquid Retina XDR"
    }
  },
  {
    id: "samsung-galaxy-tab-s9",
    name: "Samsung Galaxy Tab S9",
    description: "تابلت سامسونج جالاكسي تاب S9 مع قلم S Pen",
    price: 3299,
    originalPrice: 3599,
    category: "تابلت",
    brand: "Samsung",
    rating: 4.6,
    reviewCount: 189,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Snapdragon 8 Gen 2",
      ram: "8GB",
      storage: "128GB",
      screen: "11 بوصة Dynamic AMOLED 2X"
    }
  },
  {
    id: "microsoft-surface-pro-9",
    name: "Microsoft Surface Pro 9",
    description: "تابلت مايكروسوفت سيرفيس برو 9 قابل للتحويل",
    price: 3999,
    originalPrice: 4399,
    category: "تابلت",
    brand: "Microsoft",
    rating: 4.5,
    reviewCount: 145,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Intel Core i5-1235U",
      ram: "8GB",
      storage: "256GB SSD",
      screen: "13 بوصة PixelSense Flow"
    }
  },
  {
    id: "lenovo-tab-p12",
    name: "Lenovo Tab P12",
    description: "تابلت لينوفو تاب P12 بشاشة كبيرة وأداء قوي",
    price: 2199,
    originalPrice: 2499,
    category: "تابلت",
    brand: "Lenovo",
    rating: 4.3,
    reviewCount: 98,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "MediaTek Dimensity 7050",
      ram: "8GB",
      storage: "128GB",
      screen: "12.7 بوصة 3K"
    }
  },
  {
    id: "huawei-matepad-pro",
    name: "Huawei MatePad Pro",
    description: "تابلت هواوي ميت باد برو بتصميم أنيق",
    price: 2799,
    originalPrice: 3099,
    category: "تابلت",
    brand: "Huawei",
    rating: 4.4,
    reviewCount: 134,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Kirin 9000S",
      ram: "8GB",
      storage: "256GB",
      screen: "11 بوصة OLED"
    }
  },
  {
    id: "xiaomi-pad-6",
    name: "Xiaomi Pad 6",
    description: "تابلت شاومي باد 6 بسعر مناسب وأداء ممتاز",
    price: 1599,
    originalPrice: 1799,
    category: "تابلت",
    brand: "Xiaomi",
    rating: 4.2,
    reviewCount: 167,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Snapdragon 870",
      ram: "6GB",
      storage: "128GB",
      screen: "11 بوصة LCD"
    }
  },
  {
    id: "amazon-fire-hd-10",
    name: "Amazon Fire HD 10",
    description: "تابلت أمازون فاير HD 10 للترفيه والقراءة",
    price: 699,
    originalPrice: 899,
    category: "تابلت",
    brand: "Amazon",
    rating: 4.1,
    reviewCount: 234,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Octa-core 2.0GHz",
      ram: "3GB",
      storage: "32GB",
      screen: "10.1 بوصة Full HD"
    }
  },
  {
    id: "nokia-t21",
    name: "Nokia T21",
    description: "تابلت نوكيا T21 بنظام أندرويد نظيف",
    price: 999,
    originalPrice: 1199,
    category: "تابلت",
    brand: "Nokia",
    rating: 4.0,
    reviewCount: 89,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Unisoc Tiger T612",
      ram: "4GB",
      storage: "64GB",
      screen: "10.36 بوصة 2K"
    }
  },

  // ساعات (8 منتجات)
  {
    id: "apple-watch-series-9",
    name: "Apple Watch Series 9",
    description: "ساعة أبل الذكية الجديدة مع معالج S9",
    price: 1599,
    originalPrice: 1799,
    category: "ساعات",
    brand: "Apple",
    rating: 4.7,
    reviewCount: 345,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "S9 SiP",
      display: "45mm Retina",
      battery: "18 ساعة",
      connectivity: "GPS + Cellular"
    }
  },
  {
    id: "samsung-galaxy-watch-6",
    name: "Samsung Galaxy Watch 6",
    description: "ساعة سامسونج الذكية مع مراقبة صحية متقدمة",
    price: 1299,
    originalPrice: 1499,
    category: "ساعات",
    brand: "Samsung",
    rating: 4.5,
    reviewCount: 234,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Exynos W930",
      display: "44mm Super AMOLED",
      battery: "40 ساعة",
      connectivity: "Bluetooth + WiFi"
    }
  },
  {
    id: "garmin-fenix-7",
    name: "Garmin Fenix 7",
    description: "ساعة جارمين للرياضيين والمغامرين",
    price: 2299,
    originalPrice: 2599,
    category: "ساعات",
    brand: "Garmin",
    rating: 4.8,
    reviewCount: 189,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Multi-GNSS",
      display: "47mm MIP",
      battery: "18 يوم",
      connectivity: "GPS + ANT+"
    }
  },
  {
    id: "fitbit-sense-2",
    name: "Fitbit Sense 2",
    description: "ساعة فيت بت للصحة واللياقة البدنية",
    price: 899,
    originalPrice: 1099,
    category: "ساعات",
    brand: "Fitbit",
    rating: 4.3,
    reviewCount: 156,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Fitbit OS",
      display: "AMOLED",
      battery: "6+ أيام",
      connectivity: "Bluetooth + WiFi"
    }
  },
  {
    id: "huawei-watch-gt-4",
    name: "Huawei Watch GT 4",
    description: "ساعة هواوي الذكية بتصميم كلاسيكي",
    price: 799,
    originalPrice: 999,
    category: "ساعات",
    brand: "Huawei",
    rating: 4.4,
    reviewCount: 134,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "HarmonyOS",
      display: "46mm AMOLED",
      battery: "14 يوم",
      connectivity: "Bluetooth + GPS"
    }
  },
  {
    id: "amazfit-gtr-4",
    name: "Amazfit GTR 4",
    description: "ساعة أمازفيت بعمر بطارية طويل",
    price: 599,
    originalPrice: 799,
    category: "ساعات",
    brand: "Amazfit",
    rating: 4.2,
    reviewCount: 198,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Zepp OS",
      display: "46mm AMOLED",
      battery: "14 يوم",
      connectivity: "Bluetooth + GPS"
    }
  },
  {
    id: "fossil-gen-6",
    name: "Fossil Gen 6",
    description: "ساعة فوسيل الذكية بنظام Wear OS",
    price: 1099,
    originalPrice: 1299,
    category: "ساعات",
    brand: "Fossil",
    rating: 4.1,
    reviewCount: 167,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Snapdragon Wear 4100+",
      display: "44mm AMOLED",
      battery: "24 ساعة",
      connectivity: "Bluetooth + WiFi"
    }
  },
  {
    id: "ticwatch-pro-5",
    name: "TicWatch Pro 5",
    description: "ساعة تيك واتش برو 5 بشاشة مزدوجة",
    price: 1199,
    originalPrice: 1399,
    category: "ساعات",
    brand: "TicWatch",
    rating: 4.3,
    reviewCount: 89,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      processor: "Snapdragon W5+ Gen 1",
      display: "48mm Dual Display",
      battery: "80 ساعة",
      connectivity: "4G LTE + GPS"
    }
  },

  // أجهزة تلفاز (4 منتجات)
  {
    id: "samsung-qled-65",
    name: "Samsung QLED 65\"",
    description: "تلفاز سامسونج QLED بدقة 4K وتقنية HDR",
    price: 3999,
    originalPrice: 4499,
    category: "أجهزة تلفاز",
    brand: "Samsung",
    rating: 4.6,
    reviewCount: 234,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      size: "65 بوصة",
      resolution: "4K UHD",
      hdr: "HDR10+",
      smartOS: "Tizen"
    }
  },
  {
    id: "lg-oled-55",
    name: "LG OLED 55\"",
    description: "تلفاز LG OLED بألوان مثالية وتباين لا نهائي",
    price: 4599,
    originalPrice: 5099,
    category: "أجهزة تلفاز",
    brand: "LG",
    rating: 4.8,
    reviewCount: 189,
    inStock: true,
    featured: true,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      size: "55 بوصة",
      resolution: "4K UHD",
      hdr: "Dolby Vision",
      smartOS: "webOS"
    }
  },
  {
    id: "sony-bravia-75",
    name: "Sony BRAVIA 75\"",
    description: "تلفاز سوني برافيا بحجم كبير وجودة صورة استثنائية",
    price: 5999,
    originalPrice: 6599,
    category: "أجهزة تلفاز",
    brand: "Sony",
    rating: 4.7,
    reviewCount: 156,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      size: "75 بوصة",
      resolution: "4K UHD",
      hdr: "HDR10",
      smartOS: "Google TV"
    }
  },
  {
    id: "xiaomi-tv-a2-43",
    name: "Xiaomi TV A2 43\"",
    description: "تلفاز شاومي A2 بسعر مناسب وأداء ممتاز",
    price: 1299,
    originalPrice: 1499,
    category: "أجهزة تلفاز",
    brand: "Xiaomi",
    rating: 4.3,
    reviewCount: 198,
    inStock: true,
    featured: false,
    images: [
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg",
      "https://m.media-amazon.com/images/I/71HWQJQJQJL._AC_SL1500_.jpg"
    ],
    specifications: {
      size: "43 بوصة",
      resolution: "4K UHD",
      hdr: "HDR10",
      smartOS: "Android TV"
    }
  }
];

async function addFigmaProducts() {
  try {
    console.log('🔄 جاري إضافة المنتجات الجديدة...');
    console.log(`📦 سيتم إضافة ${allProducts.length} منتج`);
    
    // Add products in batches
    const batchSize = 500;
    const batches = [];
    let currentBatch = writeBatch(db);
    let operationCount = 0;
    
    for (let i = 0; i < allProducts.length; i++) {
      const product = allProducts[i];
      const productRef = doc(db, 'products', product.id);
      
      // Remove the id from the product data before adding to Firestore
      const { id, ...productData } = product;
      
      currentBatch.set(productRef, productData);
      operationCount++;
      
      if (operationCount === batchSize || i === allProducts.length - 1) {
        batches.push(currentBatch);
        if (i < allProducts.length - 1) {
          currentBatch = writeBatch(db);
          operationCount = 0;
        }
      }
    }
    
    // Execute all batches
    console.log(`🔄 تنفيذ ${batches.length} دفعة إضافة...`);
    
    for (let i = 0; i < batches.length; i++) {
      await batches[i].commit();
      console.log(`✅ تم إضافة الدفعة ${i + 1}/${batches.length}`);
    }
    
    console.log('✅ تم إضافة جميع المنتجات بنجاح!');
    console.log(`📊 إجمالي المنتجات المضافة: ${allProducts.length}`);
    
    // إحصائيات المنتجات حسب الفئة
    const categoryStats = {};
    allProducts.forEach(product => {
      categoryStats[product.category] = (categoryStats[product.category] || 0) + 1;
    });
    
    console.log('\n📈 إحصائيات المنتجات حسب الفئة:');
    Object.entries(categoryStats).forEach(([category, count]) => {
      console.log(`   ${category}: ${count} منتج`);
    });
    
  } catch (error) {
    console.error('❌ خطأ في إضافة المنتجات:', error);
    throw error;
  }
}

// تشغيل الدالة
addFigmaProducts()
  .then(() => {
    console.log('\n🎉 تمت العملية بنجاح! يمكنك الآن رؤية المنتجات في التطبيق.');
    process.exit(0);
  })
  .catch((error) => {
    console.error('\n💥 فشلت العملية:', error);
    process.exit(1);
  });