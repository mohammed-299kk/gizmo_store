// إضافة 10 منتجات جديدة لكل فئة في المشروع
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc, doc, setDoc } from 'firebase/firestore';

// إعدادات Firebase
const firebaseConfig = {
  apiKey: 'AIzaSyAo4-Ge1dC4LnIyG_wUjYgWc9KHCxEYUxM',
  appId: '1:32902740595:web:7de8f1273a64f9f28fc806',
  messagingSenderId: '32902740595',
  projectId: 'gizmostore-2a3ff',
  authDomain: 'gizmostore-2a3ff.firebaseapp.com',
  storageBucket: 'gizmostore-2a3ff.firebasestorage.app',
  measurementId: 'G-WF0Z8EKYMX',
};

// تهيئة Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// منتجات جديدة لكل فئة
const newProducts = {
  'هواتف ذكية': [
    {
      id: 'xiaomi-13-pro',
      name: 'Xiaomi 13 Pro',
      nameAr: 'شاومي 13 برو',
      description: 'هاتف ذكي متطور مع كاميرا احترافية وأداء قوي',
      price: 899,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 25,
      rating: 4.6,
      brand: 'Xiaomi'
    },
    {
      id: 'oneplus-11',
      name: 'OnePlus 11',
      nameAr: 'ون بلس 11',
      description: 'هاتف ذكي بتقنية الشحن السريع وكاميرا متقدمة',
      price: 749,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 30,
      rating: 4.5,
      brand: 'OnePlus'
    },
    {
      id: 'oppo-find-x6',
      name: 'Oppo Find X6',
      nameAr: 'أوبو فايند إكس 6',
      description: 'هاتف ذكي أنيق مع تصميم متميز وأداء ممتاز',
      price: 699,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 20,
      rating: 4.4,
      brand: 'Oppo'
    },
    {
      id: 'vivo-x90-pro',
      name: 'Vivo X90 Pro',
      nameAr: 'فيفو إكس 90 برو',
      description: 'هاتف ذكي مع كاميرا احترافية وتقنيات متقدمة',
      price: 799,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 18,
      rating: 4.3,
      brand: 'Vivo'
    },
    {
      id: 'realme-gt3',
      name: 'Realme GT3',
      nameAr: 'ريلمي جي تي 3',
      description: 'هاتف ذكي للألعاب مع معالج قوي وشاشة عالية الجودة',
      price: 549,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 35,
      rating: 4.2,
      brand: 'Realme'
    },
    {
      id: 'honor-magic5',
      name: 'Honor Magic5',
      nameAr: 'هونر ماجيك 5',
      description: 'هاتف ذكي متطور مع بطارية طويلة المدى',
      price: 649,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1567581935884-3349723552ca?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 22,
      rating: 4.1,
      brand: 'Honor'
    },
    {
      id: 'nothing-phone-2',
      name: 'Nothing Phone (2)',
      nameAr: 'ناثينغ فون 2',
      description: 'هاتف ذكي بتصميم شفاف فريد وأداء متميز',
      price: 599,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 15,
      rating: 4.0,
      brand: 'Nothing'
    },
    {
      id: 'asus-rog-phone-7',
      name: 'Asus ROG Phone 7',
      nameAr: 'أسوس روغ فون 7',
      description: 'هاتف ذكي مخصص للألعاب مع تبريد متقدم',
      price: 999,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 12,
      rating: 4.7,
      brand: 'Asus'
    },
    {
      id: 'motorola-edge-40',
      name: 'Motorola Edge 40',
      nameAr: 'موتورولا إيدج 40',
      description: 'هاتف ذكي بشاشة منحنية وكاميرا متطورة',
      price: 499,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 28,
      rating: 3.9,
      brand: 'Motorola'
    },
    {
      id: 'sony-xperia-1-v',
      name: 'Sony Xperia 1 V',
      nameAr: 'سوني إكسبيريا 1 في',
      description: 'هاتف ذكي مع كاميرا احترافية وشاشة 4K',
      price: 1199,
      category: 'هواتف ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 10,
      rating: 4.5,
      brand: 'Sony'
    }
  ],
  'لابتوبات': [
    {
      id: 'asus-zenbook-14',
      name: 'Asus ZenBook 14',
      nameAr: 'أسوس زين بوك 14',
      description: 'لابتوب نحيف وخفيف مع أداء ممتاز للعمل والدراسة',
      price: 899,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 15,
      rating: 4.4,
      brand: 'Asus'
    },
    {
      id: 'lenovo-thinkpad-x1',
      name: 'Lenovo ThinkPad X1',
      nameAr: 'لينوفو ثينك باد إكس 1',
      description: 'لابتوب أعمال متطور مع أمان عالي وأداء قوي',
      price: 1599,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 12,
      rating: 4.6,
      brand: 'Lenovo'
    },
    {
      id: 'acer-swift-3',
      name: 'Acer Swift 3',
      nameAr: 'أيسر سويفت 3',
      description: 'لابتوب متوسط المدى مع بطارية طويلة المدى',
      price: 649,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1484788984921-03950022c9ef?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 20,
      rating: 4.2,
      brand: 'Acer'
    },
    {
      id: 'msi-gaming-laptop',
      name: 'MSI Gaming Laptop',
      nameAr: 'إم إس آي لابتوب ألعاب',
      description: 'لابتوب ألعاب قوي مع كرت رسومات متقدم',
      price: 1299,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1593642702821-c8da6771f0c6?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 8,
      rating: 4.5,
      brand: 'MSI'
    },
    {
      id: 'surface-laptop-5',
      name: 'Surface Laptop 5',
      nameAr: 'سيرفس لابتوب 5',
      description: 'لابتوب مايكروسوفت الأنيق مع شاشة لمس',
      price: 1199,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 14,
      rating: 4.3,
      brand: 'Microsoft'
    },
    {
      id: 'razer-blade-15',
      name: 'Razer Blade 15',
      nameAr: 'رايزر بليد 15',
      description: 'لابتوب ألعاب نحيف مع أداء استثنائي',
      price: 1899,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 6,
      rating: 4.7,
      brand: 'Razer'
    },
    {
      id: 'lg-gram-17',
      name: 'LG Gram 17',
      nameAr: 'إل جي جرام 17',
      description: 'لابتوب خفيف الوزن مع شاشة كبيرة 17 بوصة',
      price: 1399,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 10,
      rating: 4.1,
      brand: 'LG'
    },
    {
      id: 'alienware-m15',
      name: 'Alienware m15',
      nameAr: 'أليين وير إم 15',
      description: 'لابتوب ألعاب متطور مع تصميم مستقبلي',
      price: 2199,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 5,
      rating: 4.8,
      brand: 'Dell'
    },
    {
      id: 'huawei-matebook-x',
      name: 'Huawei MateBook X',
      nameAr: 'هواوي ميت بوك إكس',
      description: 'لابتوب أنيق ونحيف مع شاشة عالية الدقة',
      price: 1099,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 16,
      rating: 4.0,
      brand: 'Huawei'
    },
    {
      id: 'framework-laptop',
      name: 'Framework Laptop',
      nameAr: 'فريم وورك لابتوب',
      description: 'لابتوب قابل للتخصيص والإصلاح مع تصميم مبتكر',
      price: 999,
      category: 'لابتوبات',
      imageUrl: 'https://images.unsplash.com/photo-1629131726692-1accd0c53ce0?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 7,
      rating: 4.2,
      brand: 'Framework'
    }
  ],
  'أجهزة لوحية': [
    {
      id: 'ipad-air-5',
      name: 'iPad Air 5',
      nameAr: 'آيباد إير 5',
      description: 'جهاز لوحي متطور مع معالج M1 وشاشة عالية الجودة',
      price: 599,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 25,
      rating: 4.6,
      brand: 'Apple'
    },
    {
      id: 'surface-pro-9',
      name: 'Surface Pro 9',
      nameAr: 'سيرفس برو 9',
      description: 'جهاز لوحي 2 في 1 مع لوحة مفاتيح قابلة للفصل',
      price: 899,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1585790050230-5dd28404ccb9?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 18,
      rating: 4.4,
      brand: 'Microsoft'
    },
    {
      id: 'galaxy-tab-a8',
      name: 'Galaxy Tab A8',
      nameAr: 'جالاكسي تاب إيه 8',
      description: 'جهاز لوحي اقتصادي مع أداء جيد للاستخدام اليومي',
      price: 229,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 30,
      rating: 4.0,
      brand: 'Samsung'
    },
    {
      id: 'lenovo-tab-p11',
      name: 'Lenovo Tab P11',
      nameAr: 'لينوفو تاب بي 11',
      description: 'جهاز لوحي متوسط المدى مع شاشة 11 بوصة',
      price: 299,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 22,
      rating: 3.9,
      brand: 'Lenovo'
    },
    {
      id: 'huawei-matepad-11',
      name: 'Huawei MatePad 11',
      nameAr: 'هواوي ميت باد 11',
      description: 'جهاز لوحي أنيق مع قلم ذكي ولوحة مفاتيح',
      price: 399,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 15,
      rating: 4.2,
      brand: 'Huawei'
    },
    {
      id: 'amazon-fire-hd-10',
      name: 'Amazon Fire HD 10',
      nameAr: 'أمازون فاير إتش دي 10',
      description: 'جهاز لوحي اقتصادي مع نظام Fire OS',
      price: 149,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 35,
      rating: 3.7,
      brand: 'Amazon'
    },
    {
      id: 'xiaomi-pad-5',
      name: 'Xiaomi Pad 5',
      nameAr: 'شاومي باد 5',
      description: 'جهاز لوحي بأداء قوي وسعر منافس',
      price: 349,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 20,
      rating: 4.1,
      brand: 'Xiaomi'
    },
    {
      id: 'oneplus-pad',
      name: 'OnePlus Pad',
      nameAr: 'ون بلس باد',
      description: 'جهاز لوحي جديد من ون بلس مع تصميم أنيق',
      price: 479,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 12,
      rating: 4.3,
      brand: 'OnePlus'
    },
    {
      id: 'nokia-t20',
      name: 'Nokia T20',
      nameAr: 'نوكيا تي 20',
      description: 'جهاز لوحي بسيط وموثوق للاستخدام العائلي',
      price: 199,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 25,
      rating: 3.8,
      brand: 'Nokia'
    },
    {
      id: 'realme-pad-mini',
      name: 'Realme Pad Mini',
      nameAr: 'ريلمي باد ميني',
      description: 'جهاز لوحي صغير ومحمول بسعر اقتصادي',
      price: 179,
      category: 'أجهزة لوحية',
      imageUrl: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 28,
      rating: 3.6,
      brand: 'Realme'
    }
  ],
  'سماعات': [
    {
      id: 'bose-quietcomfort-45',
      name: 'Bose QuietComfort 45',
      nameAr: 'بوز كوايت كومفورت 45',
      description: 'سماعات إلغاء الضوضاء الرائدة مع جودة صوت استثنائية',
      price: 329,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 20,
      rating: 4.7,
      brand: 'Bose'
    },
    {
      id: 'sennheiser-hd-660s',
      name: 'Sennheiser HD 660S',
      nameAr: 'سينهايزر إتش دي 660 إس',
      description: 'سماعات استوديو احترافية مع صوت عالي الدقة',
      price: 499,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 15,
      rating: 4.8,
      brand: 'Sennheiser'
    },
    {
      id: 'audio-technica-ath-m50x',
      name: 'Audio-Technica ATH-M50x',
      nameAr: 'أوديو تكنيكا إيه تي إتش إم 50 إكس',
      description: 'سماعات مراقبة احترافية مع صوت متوازن',
      price: 149,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 25,
      rating: 4.5,
      brand: 'Audio-Technica'
    },
    {
      id: 'beats-studio3',
      name: 'Beats Studio3',
      nameAr: 'بيتس ستوديو 3',
      description: 'سماعات لاسلكية مع إلغاء الضوضاء وباس قوي',
      price: 199,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1545127398-14699f92334b?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 30,
      rating: 4.2,
      brand: 'Beats'
    },
    {
      id: 'jabra-elite-85h',
      name: 'Jabra Elite 85h',
      nameAr: 'جابرا إيليت 85 إتش',
      description: 'سماعات ذكية مع إلغاء الضوضاء التكيفي',
      price: 249,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1487215078519-e21cc028cb29?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 18,
      rating: 4.4,
      brand: 'Jabra'
    },
    {
      id: 'plantronics-backbeat-pro-2',
      name: 'Plantronics BackBeat Pro 2',
      nameAr: 'بلانترونيكس باك بيت برو 2',
      description: 'سماعات لاسلكية مع بطارية طويلة المدى',
      price: 179,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1558756520-22cfe5d382ca?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 22,
      rating: 4.1,
      brand: 'Plantronics'
    },
    {
      id: 'skullcandy-crusher-evo',
      name: 'Skullcandy Crusher Evo',
      nameAr: 'سكل كاندي كراشر إيفو',
      description: 'سماعات مع باس قابل للتخصيص وتصميم عصري',
      price: 199,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1524678606370-a47ad25cb82a?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 35,
      rating: 4.0,
      brand: 'Skullcandy'
    },
    {
      id: 'hyperx-cloud-alpha',
      name: 'HyperX Cloud Alpha',
      nameAr: 'هايبر إكس كلاود ألفا',
      description: 'سماعات ألعاب مع ميكروفون قابل للفصل',
      price: 99,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1599669454699-248893623440?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 40,
      rating: 4.3,
      brand: 'HyperX'
    },
    {
      id: 'steelseries-arctis-7',
      name: 'SteelSeries Arctis 7',
      nameAr: 'ستيل سيريز أركتيس 7',
      description: 'سماعات ألعاب لاسلكية مع صوت محيطي',
      price: 149,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 28,
      rating: 4.4,
      brand: 'SteelSeries'
    },
    {
      id: 'corsair-hs70-pro',
      name: 'Corsair HS70 Pro',
      nameAr: 'كورسير إتش إس 70 برو',
      description: 'سماعات ألعاب لاسلكية مع إضاءة RGB',
      price: 119,
      category: 'سماعات',
      imageUrl: 'https://images.unsplash.com/photo-1577174881658-0f30ed549adc?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 32,
      rating: 4.2,
      brand: 'Corsair'
    }
  ],
  'ساعات ذكية': [
    {
      id: 'garmin-fenix-7',
      name: 'Garmin Fenix 7',
      nameAr: 'جارمين فينيكس 7',
      description: 'ساعة ذكية رياضية متطورة مع GPS وبطارية طويلة',
      price: 699,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 15,
      rating: 4.7,
      brand: 'Garmin'
    },
    {
      id: 'fitbit-sense-2',
      name: 'Fitbit Sense 2',
      nameAr: 'فيت بيت سينس 2',
      description: 'ساعة ذكية صحية مع مراقبة الإجهاد ومعدل ضربات القلب',
      price: 299,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 25,
      rating: 4.3,
      brand: 'Fitbit'
    },
    {
      id: 'amazfit-gtr-4',
      name: 'Amazfit GTR 4',
      nameAr: 'أمازفيت جي تي آر 4',
      description: 'ساعة ذكية أنيقة مع شاشة AMOLED وبطارية طويلة',
      price: 199,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 30,
      rating: 4.2,
      brand: 'Amazfit'
    },
    {
      id: 'fossil-gen-6',
      name: 'Fossil Gen 6',
      nameAr: 'فوسيل جين 6',
      description: 'ساعة ذكية كلاسيكية مع Wear OS وتصميم أنيق',
      price: 255,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 20,
      rating: 4.0,
      brand: 'Fossil'
    },
    {
      id: 'suunto-9-baro',
      name: 'Suunto 9 Baro',
      nameAr: 'سونتو 9 بارو',
      description: 'ساعة ذكية رياضية مع مقياس الارتفاع وGPS دقيق',
      price: 499,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1579586337278-3f436f25d4d6?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 12,
      rating: 4.5,
      brand: 'Suunto'
    },
    {
      id: 'polar-vantage-v2',
      name: 'Polar Vantage V2',
      nameAr: 'بولار فانتاج في 2',
      description: 'ساعة ذكية للرياضيين مع تحليل الأداء المتقدم',
      price: 449,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1544117519-31a4b719223d?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 18,
      rating: 4.4,
      brand: 'Polar'
    },
    {
      id: 'ticwatch-pro-3',
      name: 'TicWatch Pro 3',
      nameAr: 'تيك واتش برو 3',
      description: 'ساعة ذكية مع شاشة مزدوجة وأداء قوي',
      price: 299,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1461141346587-763ab02bced9?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 22,
      rating: 4.1,
      brand: 'Mobvoi'
    },
    {
      id: 'withings-scanwatch',
      name: 'Withings ScanWatch',
      nameAr: 'ويذينغز سكان واتش',
      description: 'ساعة ذكية هجينة مع مراقبة صحية متقدمة',
      price: 279,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1522312346375-d1a52e2b99b3?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 16,
      rating: 4.3,
      brand: 'Withings'
    },
    {
      id: 'coros-pace-2',
      name: 'Coros Pace 2',
      nameAr: 'كوروس بيس 2',
      description: 'ساعة ذكية رياضية خفيفة الوزن مع GPS دقيق',
      price: 199,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 24,
      rating: 4.2,
      brand: 'Coros'
    },
    {
      id: 'huawei-watch-gt3',
      name: 'Huawei Watch GT 3',
      nameAr: 'هواوي واتش جي تي 3',
      description: 'ساعة ذكية أنيقة مع بطارية تدوم أسبوعين',
      price: 229,
      category: 'ساعات ذكية',
      imageUrl: 'https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 28,
      rating: 4.1,
      brand: 'Huawei'
    }
  ],
  'إكسسوارات': [
    {
      id: 'anker-powercore-26800',
      name: 'Anker PowerCore 26800',
      nameAr: 'أنكر باور كور 26800',
      description: 'بطارية محمولة عالية السعة مع شحن سريع',
      price: 65,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1609592806787-3d9c5b1b8b8e?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 50,
      rating: 4.5,
      brand: 'Anker'
    },
    {
      id: 'logitech-mx-master-3',
      name: 'Logitech MX Master 3',
      nameAr: 'لوجيتك إم إكس ماستر 3',
      description: 'فأرة لاسلكية متطورة للمحترفين',
      price: 99,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 35,
      rating: 4.7,
      brand: 'Logitech'
    },
    {
      id: 'keychron-k2-keyboard',
      name: 'Keychron K2 Keyboard',
      nameAr: 'كيكرون كي 2 لوحة مفاتيح',
      description: 'لوحة مفاتيح ميكانيكية لاسلكية مدمجة',
      price: 79,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 25,
      rating: 4.4,
      brand: 'Keychron'
    },
    {
      id: 'sandisk-extreme-pro-ssd',
      name: 'SanDisk Extreme Pro SSD',
      nameAr: 'ساندسك إكستريم برو إس إس دي',
      description: 'قرص صلب خارجي سريع ومحمول',
      price: 149,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1597872200969-2b65d56bd16b?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 30,
      rating: 4.6,
      brand: 'SanDisk'
    },
    {
      id: 'baseus-gan-charger',
      name: 'Baseus GaN Charger',
      nameAr: 'بيسوس شاحن جان',
      description: 'شاحن سريع مدمج بتقنية GaN',
      price: 45,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 40,
      rating: 4.3,
      brand: 'Baseus'
    },
    {
      id: 'ugreen-usb-hub',
      name: 'UGREEN USB Hub',
      nameAr: 'يو جرين يو إس بي هاب',
      description: 'موزع USB-C متعدد المنافذ',
      price: 35,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 45,
      rating: 4.2,
      brand: 'UGREEN'
    },
    {
      id: 'peak-design-everyday-backpack',
      name: 'Peak Design Everyday Backpack',
      nameAr: 'بيك ديزاين حقيبة ظهر يومية',
      description: 'حقيبة ظهر متطورة للكاميرات واللابتوب',
      price: 259,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 15,
      rating: 4.8,
      brand: 'Peak Design'
    },
    {
      id: 'moft-laptop-stand',
      name: 'MOFT Laptop Stand',
      nameAr: 'موفت حامل لابتوب',
      description: 'حامل لابتوب قابل للطي ومحمول',
      price: 25,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 60,
      rating: 4.1,
      brand: 'MOFT'
    },
    {
      id: 'dbrand-skin',
      name: 'dbrand Skin',
      nameAr: 'دي براند سكين',
      description: 'ملصق حماية مخصص للأجهزة الإلكترونية',
      price: 15,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 100,
      rating: 4.0,
      brand: 'dbrand'
    },
    {
      id: 'elgato-stream-deck',
      name: 'Elgato Stream Deck',
      nameAr: 'إلجاتو ستريم ديك',
      description: 'لوحة تحكم للبث المباشر والإنتاجية',
      price: 149,
      category: 'إكسسوارات',
      imageUrl: 'https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=500&h=500&fit=crop',
      inStock: true,
      stockQuantity: 20,
      rating: 4.6,
      brand: 'Elgato'
    }
  ]
};

async function addProductsToFirestore() {
  try {
    console.log('🚀 بدء إضافة المنتجات الجديدة...');
    
    let totalAdded = 0;
    
    for (const [category, products] of Object.entries(newProducts)) {
      console.log(`\n📂 إضافة منتجات فئة: ${category}`);
      
      for (const product of products) {
        try {
          // إضافة المنتج باستخدام معرف مخصص
          await setDoc(doc(db, 'products', product.id), {
            name: product.name,
            nameAr: product.nameAr,
            description: product.description,
            price: product.price,
            category: product.category,
            imageUrl: product.imageUrl,
            inStock: product.inStock,
            stockQuantity: product.stockQuantity,
            rating: product.rating,
            brand: product.brand,
            createdAt: new Date(),
            updatedAt: new Date()
          });
          
          console.log(`✅ تم إضافة: ${product.nameAr} (${product.name})`);
          totalAdded++;
          
        } catch (error) {
          console.error(`❌ خطأ في إضافة ${product.name}:`, error);
        }
      }
    }
    
    console.log(`\n🎉 تم إضافة ${totalAdded} منتج جديد بنجاح!`);
    console.log('📊 ملخص الإضافة:');
    
    for (const [category, products] of Object.entries(newProducts)) {
      console.log(`  📂 ${category}: ${products.length} منتج`);
    }
    
  } catch (error) {
    console.error('❌ خطأ عام في إضافة المنتجات:', error);
  }
}

addProductsToFirestore();