import { v2 as cloudinary } from 'cloudinary';
import admin from 'firebase-admin';
import axios from 'axios';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

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

// بيانات المنتجات الكاملة من ملف figma-design
const figmaProducts = [
  // سماعات (Headphones)
  {
    id: 'sony-wh-1000xm4',
    name: 'Sony WH-1000XM4',
    nameEn: 'Sony WH-1000XM4',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 1299,
    currency: 'SAR',
    description: 'سماعات لاسلكية بتقنية إلغاء الضوضاء الرائدة في الصناعة',
    descriptionEn: 'Industry-leading noise canceling wireless headphones',
    images: [
      'https://m.media-amazon.com/images/I/71o8Q5XJS5L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61ZJqLpOJeL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71frwp924XL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71c6JmxKerL._AC_SL1500_.jpg'
    ],
    brand: 'Sony',
    inStock: true,
    rating: 4.5,
    reviews: 1250
  },
  {
    id: 'airpods-pro-2',
    name: 'Apple AirPods Pro (الجيل الثاني)',
    nameEn: 'Apple AirPods Pro (2nd Generation)',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 899,
    currency: 'SAR',
    description: 'سماعات أذن لاسلكية مع إلغاء الضوضاء النشط',
    descriptionEn: 'Wireless earbuds with Active Noise Cancellation',
    images: [
      'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61f1YfTkTtL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61-rPMP-8jL._AC_SL1500_.jpg'
    ],
    brand: 'Apple',
    inStock: true,
    rating: 4.7,
    reviews: 2100
  },
  {
    id: 'bose-quietcomfort-45',
    name: 'Bose QuietComfort 45',
    nameEn: 'Bose QuietComfort 45',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 1199,
    currency: 'SAR',
    description: 'سماعات لاسلكية مع إلغاء الضوضاء الممتاز',
    descriptionEn: 'Wireless headphones with excellent noise cancellation',
    images: [
      'https://m.media-amazon.com/images/I/51UVdgWwk7L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61-rPMP-8jL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61f1YfTkTtL._AC_SL1500_.jpg'
    ],
    brand: 'Bose',
    inStock: true,
    rating: 4.4,
    reviews: 890
  },
  {
    id: 'sennheiser-momentum-4',
    name: 'Sennheiser Momentum 4',
    nameEn: 'Sennheiser Momentum 4',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 1399,
    currency: 'SAR',
    description: 'سماعات عالية الجودة مع صوت استثنائي',
    descriptionEn: 'High-quality headphones with exceptional sound',
    images: [
      'https://m.media-amazon.com/images/I/61ZJqLpOJeL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71frwp924XL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71c6JmxKerL._AC_SL1500_.jpg'
    ],
    brand: 'Sennheiser',
    inStock: true,
    rating: 4.6,
    reviews: 650
  },
  {
    id: 'beats-studio-3',
    name: 'Beats Studio 3',
    nameEn: 'Beats Studio 3',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 999,
    currency: 'SAR',
    description: 'سماعات لاسلكية مع تقنية Pure ANC',
    descriptionEn: 'Wireless headphones with Pure ANC technology',
    images: [
      'https://m.media-amazon.com/images/I/51UVdgWwk7L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61f1YfTkTtL._AC_SL1500_.jpg'
    ],
    brand: 'Beats',
    inStock: true,
    rating: 4.2,
    reviews: 1100
  },
  {
    id: 'jabra-elite-85h',
    name: 'Jabra Elite 85h',
    nameEn: 'Jabra Elite 85h',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 899,
    currency: 'SAR',
    description: 'سماعات ذكية مع إلغاء الضوضاء التكيفي',
    descriptionEn: 'Smart headphones with adaptive noise cancellation',
    images: [
      'https://m.media-amazon.com/images/I/71o8Q5XJS5L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71frwp924XL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61-rPMP-8jL._AC_SL1500_.jpg'
    ],
    brand: 'Jabra',
    inStock: true,
    rating: 4.3,
    reviews: 750
  },
  {
    id: 'audio-technica-ath-m50x',
    name: 'Audio-Technica ATH-M50x',
    nameEn: 'Audio-Technica ATH-M50x',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 699,
    currency: 'SAR',
    description: 'سماعات احترافية للاستوديو',
    descriptionEn: 'Professional studio headphones',
    images: [
      'https://m.media-amazon.com/images/I/61ZJqLpOJeL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71c6JmxKerL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/51UVdgWwk7L._AC_SL1500_.jpg'
    ],
    brand: 'Audio-Technica',
    inStock: true,
    rating: 4.5,
    reviews: 980
  },
  {
    id: 'skullcandy-crusher-evo',
    name: 'Skullcandy Crusher Evo',
    nameEn: 'Skullcandy Crusher Evo',
    category: 'سماعات',
    categoryEn: 'headphones',
    price: 599,
    currency: 'SAR',
    description: 'سماعات مع تقنية الاهتزاز الحسي',
    descriptionEn: 'Headphones with sensory haptic technology',
    images: [
      'https://m.media-amazon.com/images/I/61SUj2aKoEL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71o8Q5XJS5L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61f1YfTkTtL._AC_SL1500_.jpg'
    ],
    brand: 'Skullcandy',
    inStock: true,
    rating: 4.1,
    reviews: 520
  },

  // لابتوبات (Laptops)
  {
    id: 'macbook-pro-m3',
    name: 'MacBook Pro M3 14"',
    nameEn: 'MacBook Pro M3 14"',
    category: 'لابتوبات',
    categoryEn: 'laptops',
    price: 7999,
    currency: 'SAR',
    description: 'لابتوب احترافي بمعالج Apple M3',
    descriptionEn: 'Professional laptop with Apple M3 processor',
    images: [
      'https://m.media-amazon.com/images/I/61aUBxqc5PL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71vFKBpKakL._AC_SL1500_.jpg'
    ],
    brand: 'Apple',
    inStock: true,
    rating: 4.8,
    reviews: 1500
  },
  {
    id: 'dell-xps-13',
    name: 'Dell XPS 13',
    nameEn: 'Dell XPS 13',
    category: 'لابتوبات',
    categoryEn: 'laptops',
    price: 4999,
    currency: 'SAR',
    description: 'لابتوب نحيف وخفيف مع شاشة InfinityEdge',
    descriptionEn: 'Thin and light laptop with InfinityEdge display',
    images: [
      'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71vFKBpKakL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61aUBxqc5PL._AC_SL1500_.jpg'
    ],
    brand: 'Dell',
    inStock: true,
    rating: 4.5,
    reviews: 890
  },
  {
    id: 'hp-spectre-x360',
    name: 'HP Spectre x360',
    nameEn: 'HP Spectre x360',
    category: 'لابتوبات',
    categoryEn: 'laptops',
    price: 5499,
    currency: 'SAR',
    description: 'لابتوب قابل للتحويل مع شاشة لمس',
    descriptionEn: 'Convertible laptop with touchscreen',
    images: [
      'https://m.media-amazon.com/images/I/71vFKBpKakL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61aUBxqc5PL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg'
    ],
    brand: 'HP',
    inStock: true,
    rating: 4.4,
    reviews: 650
  },
  {
    id: 'lenovo-thinkpad-x1',
    name: 'Lenovo ThinkPad X1 Carbon',
    nameEn: 'Lenovo ThinkPad X1 Carbon',
    category: 'لابتوبات',
    categoryEn: 'laptops',
    price: 6299,
    currency: 'SAR',
    description: 'لابتوب أعمال متين وخفيف',
    descriptionEn: 'Durable and lightweight business laptop',
    images: [
      'https://m.media-amazon.com/images/I/61aUBxqc5PL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71vFKBpKakL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg'
    ],
    brand: 'Lenovo',
    inStock: true,
    rating: 4.6,
    reviews: 780
  },
  {
    id: 'asus-zenbook-14',
    name: 'ASUS ZenBook 14',
    nameEn: 'ASUS ZenBook 14',
    category: 'لابتوبات',
    categoryEn: 'laptops',
    price: 3999,
    currency: 'SAR',
    description: 'لابتوب أنيق مع أداء قوي',
    descriptionEn: 'Elegant laptop with powerful performance',
    images: [
      'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61aUBxqc5PL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71vFKBpKakL._AC_SL1500_.jpg'
    ],
    brand: 'ASUS',
    inStock: true,
    rating: 4.3,
    reviews: 560
  },
  {
    id: 'microsoft-surface-laptop-5',
    name: 'Microsoft Surface Laptop 5',
    nameEn: 'Microsoft Surface Laptop 5',
    category: 'لابتوبات',
    categoryEn: 'laptops',
    price: 4799,
    currency: 'SAR',
    description: 'لابتوب أنيق مع نظام Windows 11',
    descriptionEn: 'Elegant laptop with Windows 11',
    images: [
      'https://m.media-amazon.com/images/I/71vFKBpKakL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61aUBxqc5PL._AC_SL1500_.jpg'
    ],
    brand: 'Microsoft',
    inStock: true,
    rating: 4.4,
    reviews: 720
  },
  {
    id: 'acer-swift-3',
    name: 'Acer Swift 3',
    nameEn: 'Acer Swift 3',
    category: 'لابتوبات',
    categoryEn: 'laptops',
    price: 2999,
    currency: 'SAR',
    description: 'لابتوب بقيمة ممتازة للاستخدام اليومي',
    descriptionEn: 'Great value laptop for everyday use',
    images: [
      'https://m.media-amazon.com/images/I/61aUBxqc5PL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71vFKBpKakL._AC_SL1500_.jpg'
    ],
    brand: 'Acer',
    inStock: true,
    rating: 4.2,
    reviews: 450
  },
  {
    id: 'msi-stealth-15m',
    name: 'MSI Stealth 15M',
    nameEn: 'MSI Stealth 15M',
    category: 'لابتوبات',
    categoryEn: 'laptops',
    price: 5999,
    currency: 'SAR',
    description: 'لابتوب ألعاب نحيف وقوي',
    descriptionEn: 'Thin and powerful gaming laptop',
    images: [
      'https://m.media-amazon.com/images/I/71jG+e7roXL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71vFKBpKakL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61aUBxqc5PL._AC_SL1500_.jpg'
    ],
    brand: 'MSI',
    inStock: true,
    rating: 4.5,
    reviews: 380
  },

  // هواتف (Phones)
  {
    id: 'iphone-15-pro-max',
    name: 'iPhone 15 Pro Max',
    nameEn: 'iPhone 15 Pro Max',
    category: 'هواتف',
    categoryEn: 'phones',
    price: 4999,
    currency: 'SAR',
    description: 'أحدث هاتف من Apple مع معالج A17 Pro',
    descriptionEn: 'Latest iPhone with A17 Pro processor',
    images: [
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61bK6PMOC3L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71ZDY57yTQL._AC_SL1500_.jpg'
    ],
    brand: 'Apple',
    inStock: true,
    rating: 4.8,
    reviews: 2500
  },
  {
    id: 'samsung-galaxy-s24-ultra',
    name: 'Samsung Galaxy S24 Ultra',
    nameEn: 'Samsung Galaxy S24 Ultra',
    category: 'هواتف',
    categoryEn: 'phones',
    price: 4599,
    currency: 'SAR',
    description: 'هاتف Samsung الرائد مع قلم S Pen',
    descriptionEn: 'Samsung flagship phone with S Pen',
    images: [
      'https://m.media-amazon.com/images/I/61bK6PMOC3L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71ZDY57yTQL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg'
    ],
    brand: 'Samsung',
    inStock: true,
    rating: 4.7,
    reviews: 1800
  },
  {
    id: 'google-pixel-8-pro',
    name: 'Google Pixel 8 Pro',
    nameEn: 'Google Pixel 8 Pro',
    category: 'هواتف',
    categoryEn: 'phones',
    price: 3999,
    currency: 'SAR',
    description: 'هاتف Google مع أفضل كاميرا حاسوبية',
    descriptionEn: 'Google phone with best computational camera',
    images: [
      'https://m.media-amazon.com/images/I/71ZDY57yTQL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61bK6PMOC3L._AC_SL1500_.jpg'
    ],
    brand: 'Google',
    inStock: true,
    rating: 4.6,
    reviews: 1200
  },
  {
    id: 'oneplus-12',
    name: 'OnePlus 12',
    nameEn: 'OnePlus 12',
    category: 'هواتف',
    categoryEn: 'phones',
    price: 3299,
    currency: 'SAR',
    description: 'هاتف OnePlus بأداء سريع وشحن فائق',
    descriptionEn: 'OnePlus phone with fast performance and super charging',
    images: [
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71ZDY57yTQL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61bK6PMOC3L._AC_SL1500_.jpg'
    ],
    brand: 'OnePlus',
    inStock: true,
    rating: 4.5,
    reviews: 890
  },
  {
    id: 'xiaomi-14-ultra',
    name: 'Xiaomi 14 Ultra',
    nameEn: 'Xiaomi 14 Ultra',
    category: 'هواتف',
    categoryEn: 'phones',
    price: 2999,
    currency: 'SAR',
    description: 'هاتف Xiaomi الرائد مع كاميرا Leica',
    descriptionEn: 'Xiaomi flagship phone with Leica camera',
    images: [
      'https://m.media-amazon.com/images/I/61bK6PMOC3L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71ZDY57yTQL._AC_SL1500_.jpg'
    ],
    brand: 'Xiaomi',
    inStock: true,
    rating: 4.4,
    reviews: 750
  },
  {
    id: 'oppo-find-x7-pro',
    name: 'OPPO Find X7 Pro',
    nameEn: 'OPPO Find X7 Pro',
    category: 'هواتف',
    categoryEn: 'phones',
    price: 3599,
    currency: 'SAR',
    description: 'هاتف OPPO مع تصميم أنيق وكاميرا متقدمة',
    descriptionEn: 'OPPO phone with elegant design and advanced camera',
    images: [
      'https://m.media-amazon.com/images/I/71ZDY57yTQL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61bK6PMOC3L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg'
    ],
    brand: 'OPPO',
    inStock: true,
    rating: 4.3,
    reviews: 620
  },
  {
    id: 'vivo-x100-pro',
    name: 'Vivo X100 Pro',
    nameEn: 'Vivo X100 Pro',
    category: 'هواتف',
    categoryEn: 'phones',
    price: 3199,
    currency: 'SAR',
    description: 'هاتف Vivo مع تقنيات تصوير احترافية',
    descriptionEn: 'Vivo phone with professional photography technologies',
    images: [
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61bK6PMOC3L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71ZDY57yTQL._AC_SL1500_.jpg'
    ],
    brand: 'Vivo',
    inStock: true,
    rating: 4.2,
    reviews: 480
  },
  {
    id: 'nothing-phone-2',
    name: 'Nothing Phone (2)',
    nameEn: 'Nothing Phone (2)',
    category: 'هواتف',
    categoryEn: 'phones',
    price: 2599,
    currency: 'SAR',
    description: 'هاتف Nothing بتصميم شفاف فريد',
    descriptionEn: 'Nothing phone with unique transparent design',
    images: [
      'https://m.media-amazon.com/images/I/61bK6PMOC3L._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71ZDY57yTQL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81Os1SDWpcL._AC_SL1500_.jpg'
    ],
    brand: 'Nothing',
    inStock: true,
    rating: 4.1,
    reviews: 350
  },

  // تابلت (Tablets)
  {
    id: 'ipad-pro-m4',
    name: 'iPad Pro M4 12.9"',
    nameEn: 'iPad Pro M4 12.9"',
    category: 'تابلت',
    categoryEn: 'tablets',
    price: 4499,
    currency: 'SAR',
    description: 'تابلت iPad Pro بمعالج M4 وشاشة Liquid Retina XDR',
    descriptionEn: 'iPad Pro with M4 processor and Liquid Retina XDR display',
    images: [
      'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71GLMJ7TzxL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61QRgVOpAnL._AC_SL1500_.jpg'
    ],
    brand: 'Apple',
    inStock: true,
    rating: 4.8,
    reviews: 1100
  },
  {
    id: 'samsung-galaxy-tab-s9-ultra',
    name: 'Samsung Galaxy Tab S9 Ultra',
    nameEn: 'Samsung Galaxy Tab S9 Ultra',
    category: 'تابلت',
    categoryEn: 'tablets',
    price: 3999,
    currency: 'SAR',
    description: 'تابلت Samsung الرائد مع شاشة كبيرة وقلم S Pen',
    descriptionEn: 'Samsung flagship tablet with large screen and S Pen',
    images: [
      'https://m.media-amazon.com/images/I/71GLMJ7TzxL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61QRgVOpAnL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg'
    ],
    brand: 'Samsung',
    inStock: true,
    rating: 4.6,
    reviews: 780
  },
  {
    id: 'microsoft-surface-pro-9',
    name: 'Microsoft Surface Pro 9',
    nameEn: 'Microsoft Surface Pro 9',
    category: 'تابلت',
    categoryEn: 'tablets',
    price: 3599,
    currency: 'SAR',
    description: 'تابلت Microsoft قابل للتحويل مع Windows 11',
    descriptionEn: 'Microsoft convertible tablet with Windows 11',
    images: [
      'https://m.media-amazon.com/images/I/61QRgVOpAnL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71GLMJ7TzxL._AC_SL1500_.jpg'
    ],
    brand: 'Microsoft',
    inStock: true,
    rating: 4.5,
    reviews: 650
  },
  {
    id: 'lenovo-tab-p12-pro',
    name: 'Lenovo Tab P12 Pro',
    nameEn: 'Lenovo Tab P12 Pro',
    category: 'تابلت',
    categoryEn: 'tablets',
    price: 2999,
    currency: 'SAR',
    description: 'تابلت Lenovo احترافي مع شاشة OLED',
    descriptionEn: 'Professional Lenovo tablet with OLED display',
    images: [
      'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61QRgVOpAnL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71GLMJ7TzxL._AC_SL1500_.jpg'
    ],
    brand: 'Lenovo',
    inStock: true,
    rating: 4.3,
    reviews: 420
  },
  {
    id: 'huawei-matepad-pro',
    name: 'Huawei MatePad Pro',
    nameEn: 'Huawei MatePad Pro',
    category: 'تابلت',
    categoryEn: 'tablets',
    price: 2599,
    currency: 'SAR',
    description: 'تابلت Huawei مع أداء قوي وتصميم أنيق',
    descriptionEn: 'Huawei tablet with powerful performance and elegant design',
    images: [
      'https://m.media-amazon.com/images/I/71GLMJ7TzxL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61QRgVOpAnL._AC_SL1500_.jpg'
    ],
    brand: 'Huawei',
    inStock: true,
    rating: 4.2,
    reviews: 350
  },
  {
    id: 'xiaomi-pad-6',
    name: 'Xiaomi Pad 6',
    nameEn: 'Xiaomi Pad 6',
    category: 'تابلت',
    categoryEn: 'tablets',
    price: 1999,
    currency: 'SAR',
    description: 'تابلت Xiaomi بقيمة ممتازة وأداء جيد',
    descriptionEn: 'Xiaomi tablet with excellent value and good performance',
    images: [
      'https://m.media-amazon.com/images/I/61QRgVOpAnL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71GLMJ7TzxL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg'
    ],
    brand: 'Xiaomi',
    inStock: true,
    rating: 4.1,
    reviews: 280
  },
  {
    id: 'amazon-fire-hd-10',
    name: 'Amazon Fire HD 10',
    nameEn: 'Amazon Fire HD 10',
    category: 'تابلت',
    categoryEn: 'tablets',
    price: 899,
    currency: 'SAR',
    description: 'تابلت Amazon اقتصادي للترفيه والقراءة',
    descriptionEn: 'Affordable Amazon tablet for entertainment and reading',
    images: [
      'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71GLMJ7TzxL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61QRgVOpAnL._AC_SL1500_.jpg'
    ],
    brand: 'Amazon',
    inStock: true,
    rating: 3.9,
    reviews: 450
  },
  {
    id: 'realme-pad-2',
    name: 'Realme Pad 2',
    nameEn: 'Realme Pad 2',
    category: 'تابلت',
    categoryEn: 'tablets',
    price: 1299,
    currency: 'SAR',
    description: 'تابلت Realme بسعر منافس وميزات جيدة',
    descriptionEn: 'Realme tablet with competitive price and good features',
    images: [
      'https://m.media-amazon.com/images/I/71GLMJ7TzxL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61QRgVOpAnL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61uA2UVnYWL._AC_SL1500_.jpg'
    ],
    brand: 'Realme',
    inStock: true,
    rating: 4.0,
    reviews: 220
  },

  // ساعات ذكية (Smart Watches)
  {
    id: 'apple-watch-series-9',
    name: 'Apple Watch Series 9',
    nameEn: 'Apple Watch Series 9',
    category: 'ساعات ذكية',
    categoryEn: 'smartwatches',
    price: 1599,
    currency: 'SAR',
    description: 'ساعة Apple الذكية مع معالج S9 وشاشة Always-On',
    descriptionEn: 'Apple smartwatch with S9 processor and Always-On display',
    images: [
      'https://m.media-amazon.com/images/I/71u2XkqIIrL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61BIyKH-8nL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71cSV-RTBSL._AC_SL1500_.jpg'
    ],
    brand: 'Apple',
    inStock: true,
    rating: 4.7,
    reviews: 1800
  },
  {
    id: 'samsung-galaxy-watch-6',
    name: 'Samsung Galaxy Watch 6',
    nameEn: 'Samsung Galaxy Watch 6',
    category: 'ساعات ذكية',
    categoryEn: 'smartwatches',
    price: 1299,
    currency: 'SAR',
    description: 'ساعة Samsung الذكية مع مراقبة صحية متقدمة',
    descriptionEn: 'Samsung smartwatch with advanced health monitoring',
    images: [
      'https://m.media-amazon.com/images/I/61BIyKH-8nL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71cSV-RTBSL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71u2XkqIIrL._AC_SL1500_.jpg'
    ],
    brand: 'Samsung',
    inStock: true,
    rating: 4.5,
    reviews: 1200
  },
  {
    id: 'garmin-fenix-7',
    name: 'Garmin Fenix 7',
    nameEn: 'Garmin Fenix 7',
    category: 'ساعات ذكية',
    categoryEn: 'smartwatches',
    price: 2299,
    currency: 'SAR',
    description: 'ساعة Garmin الرياضية مع GPS وبطارية طويلة المدى',
    descriptionEn: 'Garmin sports watch with GPS and long battery life',
    images: [
      'https://m.media-amazon.com/images/I/71cSV-RTBSL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71u2XkqIIrL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61BIyKH-8nL._AC_SL1500_.jpg'
    ],
    brand: 'Garmin',
    inStock: true,
    rating: 4.6,
    reviews: 890
  },
  {
    id: 'fitbit-sense-2',
    name: 'Fitbit Sense 2',
    nameEn: 'Fitbit Sense 2',
    category: 'ساعات ذكية',
    categoryEn: 'smartwatches',
    price: 999,
    currency: 'SAR',
    description: 'ساعة Fitbit الصحية مع مراقبة الإجهاد',
    descriptionEn: 'Fitbit health watch with stress monitoring',
    images: [
      'https://m.media-amazon.com/images/I/71u2XkqIIrL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71cSV-RTBSL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61BIyKH-8nL._AC_SL1500_.jpg'
    ],
    brand: 'Fitbit',
    inStock: true,
    rating: 4.3,
    reviews: 650
  },
  {
    id: 'huawei-watch-gt-4',
    name: 'Huawei Watch GT 4',
    nameEn: 'Huawei Watch GT 4',
    category: 'ساعات ذكية',
    categoryEn: 'smartwatches',
    price: 899,
    currency: 'SAR',
    description: 'ساعة Huawei الذكية مع تصميم كلاسيكي',
    descriptionEn: 'Huawei smartwatch with classic design',
    images: [
      'https://m.media-amazon.com/images/I/61BIyKH-8nL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71u2XkqIIrL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71cSV-RTBSL._AC_SL1500_.jpg'
    ],
    brand: 'Huawei',
    inStock: true,
    rating: 4.2,
    reviews: 480
  },
  {
    id: 'amazfit-gtr-4',
    name: 'Amazfit GTR 4',
    nameEn: 'Amazfit GTR 4',
    category: 'ساعات ذكية',
    categoryEn: 'smartwatches',
    price: 699,
    currency: 'SAR',
    description: 'ساعة Amazfit بقيمة ممتازة وبطارية طويلة',
    descriptionEn: 'Amazfit watch with excellent value and long battery',
    images: [
      'https://m.media-amazon.com/images/I/71cSV-RTBSL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61BIyKH-8nL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71u2XkqIIrL._AC_SL1500_.jpg'
    ],
    brand: 'Amazfit',
    inStock: true,
    rating: 4.1,
    reviews: 380
  },
  {
    id: 'fossil-gen-6',
    name: 'Fossil Gen 6',
    nameEn: 'Fossil Gen 6',
    category: 'ساعات ذكية',
    categoryEn: 'smartwatches',
    price: 1199,
    currency: 'SAR',
    description: 'ساعة Fossil الذكية مع Wear OS',
    descriptionEn: 'Fossil smartwatch with Wear OS',
    images: [
      'https://m.media-amazon.com/images/I/71u2XkqIIrL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61BIyKH-8nL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71cSV-RTBSL._AC_SL1500_.jpg'
    ],
    brand: 'Fossil',
    inStock: true,
    rating: 4.0,
    reviews: 320
  },
  {
    id: 'ticwatch-pro-5',
    name: 'TicWatch Pro 5',
    nameEn: 'TicWatch Pro 5',
    category: 'ساعات ذكية',
    categoryEn: 'smartwatches',
    price: 1099,
    currency: 'SAR',
    description: 'ساعة TicWatch مع شاشة مزدوجة وأداء قوي',
    descriptionEn: 'TicWatch with dual display and powerful performance',
    images: [
      'https://m.media-amazon.com/images/I/61BIyKH-8nL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71cSV-RTBSL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/71u2XkqIIrL._AC_SL1500_.jpg'
    ],
    brand: 'TicWatch',
    inStock: true,
    rating: 4.2,
    reviews: 250
  },

  // أجهزة تلفاز (TVs)
  {
    id: 'sony-x90l-65',
    name: 'Sony X90L 65"',
    nameEn: 'Sony X90L 65"',
    category: 'أجهزة تلفاز',
    categoryEn: 'tvs',
    price: 2999,
    currency: 'SAR',
    description: 'تلفاز Sony 4K مع تقنية XR وGoogle TV',
    descriptionEn: 'Sony 4K TV with XR technology and Google TV',
    images: [
      'https://www.sony.com/content/dam/sony/en/televisions/x90l/x90l-1.jpg',
      'https://www.sony.com/content/dam/sony/en/televisions/x90l/x90l-2.jpg',
      'https://www.sony.com/content/dam/sony/en/televisions/x90l/x90l-3.jpg'
    ],
    brand: 'Sony',
    inStock: true,
    rating: 4.6,
    reviews: 780
  },
  {
    id: 'lg-c3-oled-55',
    name: 'LG C3 OLED 55"',
    nameEn: 'LG C3 OLED 55"',
    category: 'أجهزة تلفاز',
    categoryEn: 'tvs',
    price: 1800,
    currency: 'SAR',
    description: 'تلفاز LG OLED مع ألوان مثالية وتباين لا نهائي',
    descriptionEn: 'LG OLED TV with perfect colors and infinite contrast',
    images: [
      'https://www.lg.com/content/dam/channel/wcms/uk/assets/tvs-soundbars/oled/c3/c3-1.jpg',
      'https://www.lg.com/content/dam/channel/wcms/uk/assets/tvs-soundbars/oled/c3/c3-2.jpg',
      'https://www.lg.com/content/dam/channel/wcms/uk/assets/tvs-soundbars/oled/c3/c3-3.jpg'
    ],
    brand: 'LG',
    inStock: true,
    rating: 4.8,
    reviews: 1200
  },
  {
    id: 'samsung-qn90c-75',
    name: 'Samsung QN90C 75"',
    nameEn: 'Samsung QN90C 75"',
    category: 'أجهزة تلفاز',
    categoryEn: 'tvs',
    price: 6999,
    currency: 'SAR',
    description: 'تلفاز Samsung Neo QLED مع إضاءة خلفية Mini LED',
    descriptionEn: 'Samsung Neo QLED TV with Mini LED backlighting',
    images: [
      'https://images.samsung.com/is/image/samsung/p6pim/uk/qe75qn90catxxu/gallery/uk-neo-qled-4k-qn90c-qe75qn90catxxu-534851516',
      'https://images.samsung.com/is/image/samsung/p6pim/uk/qe75qn90catxxu/gallery/uk-neo-qled-4k-qn90c-qe75qn90catxxu-534851517',
      'https://images.samsung.com/is/image/samsung/p6pim/uk/qe75qn90catxxu/gallery/uk-neo-qled-4k-qn90c-qe75qn90catxxu-534851518'
    ],
    brand: 'Samsung',
    inStock: true,
    rating: 4.7,
    reviews: 950
  },
  {
    id: 'tcl-c845-65',
    name: 'TCL C845 65"',
    nameEn: 'TCL C845 65"',
    category: 'أجهزة تلفاز',
    categoryEn: 'tvs',
    price: 2499,
    currency: 'SAR',
    description: 'تلفاز TCL QLED مع Google TV وسعر منافس',
    descriptionEn: 'TCL QLED TV with Google TV and competitive price',
    images: [
      'https://www.tcl.com/content/dam/tcl/product-feature/tv/c845/c845-1.jpg',
      'https://www.tcl.com/content/dam/tcl/product-feature/tv/c845/c845-2.jpg',
      'https://www.tcl.com/content/dam/tcl/product-feature/tv/c845/c845-3.jpg'
    ],
    brand: 'TCL',
    inStock: true,
    rating: 4.3,
    reviews: 520
  },
  {
    id: 'hisense-u8k-55',
    name: 'Hisense U8K 55"',
    nameEn: 'Hisense U8K 55"',
    category: 'أجهزة تلفاز',
    categoryEn: 'tvs',
    price: 1999,
    currency: 'SAR',
    description: 'تلفاز Hisense ULED مع تقنية Quantum Dot',
    descriptionEn: 'Hisense ULED TV with Quantum Dot technology',
    images: [
      'https://www.hisense.com/content/dam/hisense/products/tv/u8k/u8k-1.jpg',
      'https://www.hisense.com/content/dam/hisense/products/tv/u8k/u8k-2.jpg',
      'https://www.hisense.com/content/dam/hisense/products/tv/u8k/u8k-3.jpg'
    ],
    brand: 'Hisense',
    inStock: true,
    rating: 4.2,
    reviews: 380
  },
  {
    id: 'philips-oled-808-55',
    name: 'Philips OLED 808 55"',
    nameEn: 'Philips OLED 808 55"',
    category: 'أجهزة تلفاز',
    categoryEn: 'tvs',
    price: 3299,
    currency: 'SAR',
    description: 'تلفاز Philips OLED مع تقنية Ambilight',
    descriptionEn: 'Philips OLED TV with Ambilight technology',
    images: [
      'https://www.philips.com/content/dam/b2c/en/televisions/oled808/oled808-1.jpg',
      'https://www.philips.com/content/dam/b2c/en/televisions/oled808/oled808-2.jpg',
      'https://www.philips.com/content/dam/b2c/en/televisions/oled808/oled808-3.jpg'
    ],
    brand: 'Philips',
    inStock: true,
    rating: 4.4,
    reviews: 290
  },
  {
    id: 'lg-nano-766-75',
    name: 'LG NanoCell 75NANO766QA',
    nameEn: 'LG NanoCell 75NANO766QA',
    category: 'أجهزة تلفاز',
    categoryEn: 'tvs',
    price: 2799,
    currency: 'SAR',
    description: 'تلفاز LG NanoCell مع تقنية الألوان النقية',
    descriptionEn: 'LG NanoCell TV with pure color technology',
    images: [
      'https://www.lg.com/content/dam/channel/wcms/uk/assets/tvs-soundbars/nanocell/75nano766qa/75nano766qa-1.jpg',
      'https://www.lg.com/content/dam/channel/wcms/uk/assets/tvs-soundbars/nanocell/75nano766qa/75nano766qa-2.jpg',
      'https://www.lg.com/content/dam/channel/wcms/uk/assets/tvs-soundbars/nanocell/75nano766qa/75nano766qa-3.jpg'
    ],
    brand: 'LG',
    inStock: true,
    rating: 4.1,
    reviews: 420
  },
  {
    id: 'samsung-frame-tv-55',
    name: 'Samsung Frame TV 55"',
    nameEn: 'Samsung Frame TV 55"',
    category: 'أجهزة تلفاز',
    categoryEn: 'tvs',
    price: 4999,
    currency: 'SAR',
    description: 'تلفاز Samsung Frame مع تصميم إطار فني',
    descriptionEn: 'Samsung Frame TV with artistic frame design',
    images: [
      'https://m.media-amazon.com/images/I/91EBBJN6cUL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ],
    brand: 'Samsung',
    inStock: true,
    rating: 4.5,
    reviews: 680
  },
  {
    id: 'roku-tv-50',
    name: 'Roku TV 50"',
    nameEn: 'Roku TV 50"',
    category: 'أجهزة تلفاز',
    categoryEn: 'tvs',
    price: 1599,
    currency: 'SAR',
    description: 'تلفاز Roku الذكي مع واجهة بسيطة وسهلة',
    descriptionEn: 'Roku smart TV with simple and easy interface',
    images: [
      'https://m.media-amazon.com/images/I/81nj5Tg3YJL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61u2J7QeBGL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/61yZ71JEDFL._AC_SL1500_.jpg',
      'https://m.media-amazon.com/images/I/81NQ78i7vDL._AC_SL1500_.jpg'
    ],
    brand: 'Roku',
    inStock: true,
    rating: 4.0,
    reviews: 350
  }
];

// دالة لرفع صورة إلى Cloudinary
async function uploadImageToCloudinary(imageUrl, productId, imageIndex) {
  try {
    console.log(`📤 رفع الصورة ${imageIndex} للمنتج ${productId}...`);
    
    const result = await cloudinary.uploader.upload(imageUrl, {
      folder: 'gizmo_store/products',
      public_id: `${productId}_image_${imageIndex}`,
      overwrite: true,
      resource_type: 'image',
      transformation: [
        { width: 800, height: 800, crop: 'fill', quality: 'auto' },
        { format: 'webp' }
      ]
    });
    
    console.log(`✅ تم رفع الصورة بنجاح: ${result.secure_url}`);
    return result.secure_url;
  } catch (error) {
    console.error(`❌ خطأ في رفع الصورة ${imageUrl}:`, error.message);
    return null;
  }
}

// دالة لرفع جميع صور منتج معين
async function uploadProductImages(product) {
  console.log(`\n📦 بدء رفع صور المنتج: ${product.name}`);
  const uploadedUrls = [];
  
  for (let i = 0; i < product.images.length; i++) {
    const url = await uploadImageToCloudinary(product.images[i], product.id, i + 1);
    if (url) {
      uploadedUrls.push(url);
    }
    // انتظار قصير بين الرفعات لتجنب تجاوز الحدود
    await new Promise(resolve => setTimeout(resolve, 2000));
  }
  
  console.log(`✅ تم رفع ${uploadedUrls.length} صورة للمنتج ${product.name}`);
  return uploadedUrls;
}

// دالة لإضافة منتج إلى Firebase Firestore
async function addProductToFirestore(product, cloudinaryImages) {
  try {
    const productData = {
      ...product,
      images: cloudinaryImages, // استبدال الصور بروابط Cloudinary
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };
    
    await db.collection('products').doc(product.id).set(productData);
    console.log(`✅ تم إضافة المنتج ${product.name} إلى Firebase`);
    return true;
  } catch (error) {
    console.error(`❌ خطأ في إضافة المنتج ${product.name} إلى Firebase:`, error.message);
    return false;
  }
}

// دالة لحذف الصور القديمة من Cloudinary
async function deleteOldImages() {
  try {
    console.log('🗑️ بدء حذف الصور القديمة من Cloudinary...');
    
    // البحث عن جميع الصور في مجلد gizmo_store/products
    const result = await cloudinary.api.resources({
      type: 'upload',
      prefix: 'gizmo_store/products/',
      max_results: 500
    });
    
    if (result.resources && result.resources.length > 0) {
      console.log(`🔍 تم العثور على ${result.resources.length} صورة قديمة`);
      
      // حذف الصور بمجموعات صغيرة
      const batchSize = 10;
      for (let i = 0; i < result.resources.length; i += batchSize) {
        const batch = result.resources.slice(i, i + batchSize);
        const publicIds = batch.map(resource => resource.public_id);
        
        await cloudinary.api.delete_resources(publicIds);
        console.log(`🗑️ تم حذف ${publicIds.length} صورة`);
        
        // انتظار قصير بين المجموعات
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
      
      console.log('✅ تم حذف جميع الصور القديمة بنجاح');
    } else {
      console.log('ℹ️ لا توجد صور قديمة للحذف');
    }
  } catch (error) {
    console.error('❌ خطأ في حذف الصور القديمة:', error.message);
  }
}

// دالة لحذف جميع المنتجات القديمة من Firebase
async function deleteOldProducts() {
  try {
    console.log('🗑️ بدء حذف المنتجات القديمة من Firebase...');
    
    const snapshot = await db.collection('products').get();
    
    if (!snapshot.empty) {
      console.log(`🔍 تم العثور على ${snapshot.size} منتج قديم`);
      
      const batch = db.batch();
      snapshot.docs.forEach(doc => {
        batch.delete(doc.ref);
      });
      
      await batch.commit();
      console.log('✅ تم حذف جميع المنتجات القديمة من Firebase');
    } else {
      console.log('ℹ️ لا توجد منتجات قديمة للحذف');
    }
  } catch (error) {
    console.error('❌ خطأ في حذف المنتجات القديمة:', error.message);
  }
}

// الدالة الرئيسية
async function main() {
  console.log('🚀 بدء عملية رفع المنتجات الجديدة...\n');
  
  try {
    // 1. حذف الصور والمنتجات القديمة
    console.log('📋 المرحلة 1: تنظيف البيانات القديمة');
    await deleteOldImages();
    await deleteOldProducts();
    
    console.log('\n📋 المرحلة 2: رفع المنتجات الجديدة');
    
    let successCount = 0;
    let errorCount = 0;
    
    // 2. رفع كل منتج مع صوره
    for (let i = 0; i < figmaProducts.length; i++) {
      const product = figmaProducts[i];
      console.log(`\n📦 معالجة المنتج ${i + 1}/${figmaProducts.length}: ${product.name}`);
      
      try {
        // رفع صور المنتج إلى Cloudinary
        const cloudinaryImages = await uploadProductImages(product);
        
        if (cloudinaryImages.length > 0) {
          // إضافة المنتج إلى Firebase مع روابط Cloudinary
          const success = await addProductToFirestore(product, cloudinaryImages);
          
          if (success) {
            successCount++;
            console.log(`✅ تم إنجاز المنتج ${product.name} بنجاح`);
          } else {
            errorCount++;
          }
        } else {
          console.log(`⚠️ لم يتم رفع أي صورة للمنتج ${product.name}`);
          errorCount++;
        }
        
        // انتظار بين المنتجات لتجنب تجاوز الحدود
        if (i < figmaProducts.length - 1) {
          console.log('⏳ انتظار 3 ثوانٍ قبل المنتج التالي...');
          await new Promise(resolve => setTimeout(resolve, 3000));
        }
        
      } catch (error) {
        console.error(`❌ خطأ في معالجة المنتج ${product.name}:`, error.message);
        errorCount++;
      }
    }
    
    // 3. تقرير النتائج
    console.log('\n📊 تقرير النتائج النهائية:');
    console.log(`✅ المنتجات المضافة بنجاح: ${successCount}`);
    console.log(`❌ المنتجات التي فشلت: ${errorCount}`);
    console.log(`📦 إجمالي المنتجات: ${figmaProducts.length}`);
    
    if (successCount === figmaProducts.length) {
      console.log('\n🎉 تم إنجاز جميع المنتجات بنجاح!');
    } else {
      console.log('\n⚠️ بعض المنتجات لم تكتمل. يرجى مراجعة الأخطاء أعلاه.');
    }
    
  } catch (error) {
    console.error('❌ خطأ عام في العملية:', error.message);
  }
}

// تشغيل السكريبت
if (require.main === module) {
  main().then(() => {
    console.log('\n🏁 انتهت العملية');
    process.exit(0);
  }).catch(error => {
    console.error('💥 خطأ فادح:', error);
    process.exit(1);
  });
}

module.exports = {
  uploadImageToCloudinary,
  uploadProductImages,
  addProductToFirestore,
  deleteOldImages,
  deleteOldProducts,
  figmaProducts
};