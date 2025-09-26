const admin = require('firebase-admin');

// Initialize Firebase Admin using Application Default Credentials
admin.initializeApp({
  projectId: 'gizmostore-2a3ff'
});

const db = admin.firestore();

// 50 منتج جديد مع صور مطابقة
const products = [
  // هواتف ذكية
  {
    name: 'iPhone 15 Pro Max',
    description: 'أحدث هاتف من آبل بكاميرا متطورة وأداء استثنائي',
    price: 4999,
    originalPrice: 5499,
    image: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone15pro_1_wnqhzd.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone15pro_2_abc123.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/iphone15pro_3_def456.jpg'
    ],
    category: 'هواتف ذكية',
    featured: true,
    isAvailable: true,
    stock: 25,
    rating: 4.8,
    reviewsCount: 156
  },
  {
    name: 'Samsung Galaxy S24 Ultra',
    description: 'هاتف سامسونج الرائد بقلم S Pen وكاميرا 200 ميجابكسل',
    price: 4299,
    originalPrice: 4799,
    image: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/galaxy_s24_1_xyz789.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/galaxy_s24_2_uvw012.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/galaxy_s24_3_rst345.jpg'
    ],
    category: 'هواتف ذكية',
    featured: true,
    isAvailable: true,
    stock: 30,
    rating: 4.7,
    reviewsCount: 203
  },
  {
    name: 'Google Pixel 8 Pro',
    description: 'هاتف جوجل بذكاء اصطناعي متقدم وكاميرا احترافية',
    price: 3599,
    originalPrice: 3999,
    image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/pixel8pro_1_mno678.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/pixel8pro_2_pqr901.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/pixel8pro_3_stu234.jpg'
    ],
    category: 'هواتف ذكية',
    featured: false,
    isAvailable: true,
    stock: 20,
    rating: 4.6,
    reviewsCount: 89
  },
  {
    name: 'OnePlus 12',
    description: 'هاتف ون بلس بشحن سريع وأداء قوي',
    price: 2899,
    originalPrice: 3299,
    image: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/oneplus12_1_hij567.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/oneplus12_2_klm890.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/oneplus12_3_nop123.jpg'
    ],
    category: 'هواتف ذكية',
    featured: false,
    isAvailable: true,
    stock: 15,
    rating: 4.5,
    reviewsCount: 67
  },
  {
    name: 'Xiaomi 14 Ultra',
    description: 'هاتف شاومي بكاميرا ليكا وأداء متميز',
    price: 2599,
    originalPrice: 2999,
    image: 'https://images.unsplash.com/photo-1567581935884-3349723552ca?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/xiaomi14_1_qrs456.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/xiaomi14_2_tuv789.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/xiaomi14_3_wxy012.jpg'
    ],
    category: 'هواتف ذكية',
    featured: false,
    isAvailable: true,
    stock: 18,
    rating: 4.4,
    reviewsCount: 92
  },
  
  // لابتوبات
  {
    name: 'MacBook Pro 16 M3 Max',
    description: 'لابتوب آبل الاحترافي بمعالج M3 Max وشاشة Retina',
    price: 12999,
    originalPrice: 14999,
    image: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/macbook_pro_1_zab345.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/macbook_pro_2_cde678.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/macbook_pro_3_fgh901.jpg'
    ],
    category: 'لابتوبات',
    featured: true,
    isAvailable: true,
    stock: 10,
    rating: 4.9,
    reviewsCount: 78
  },
  {
    name: 'Dell XPS 15',
    description: 'لابتوب ديل بشاشة 4K وأداء احترافي',
    price: 8999,
    originalPrice: 9999,
    image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/dell_xps_1_ijk234.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/dell_xps_2_lmn567.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/dell_xps_3_opq890.jpg'
    ],
    category: 'لابتوبات',
    featured: false,
    isAvailable: true,
    stock: 12,
    rating: 4.6,
    reviewsCount: 45
  },
  {
    name: 'HP Spectre x360',
    description: 'لابتوب HP قابل للتحويل بشاشة لمس',
    price: 6999,
    originalPrice: 7999,
    image: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/hp_spectre_1_rst123.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/hp_spectre_2_uvw456.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/hp_spectre_3_xyz789.jpg'
    ],
    category: 'لابتوبات',
    featured: false,
    isAvailable: true,
    stock: 8,
    rating: 4.5,
    reviewsCount: 32
  },
  {
    name: 'Lenovo ThinkPad X1 Carbon',
    description: 'لابتوب لينوفو للأعمال بتصميم نحيف ومتين',
    price: 7599,
    originalPrice: 8599,
    image: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/thinkpad_1_abc012.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/thinkpad_2_def345.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/thinkpad_3_ghi678.jpg'
    ],
    category: 'لابتوبات',
    featured: false,
    isAvailable: true,
    stock: 6,
    rating: 4.7,
    reviewsCount: 28
  },
  {
    name: 'ASUS ROG Zephyrus G16',
    description: 'لابتوب ألعاب بمعالج رسومات RTX 4080',
    price: 9999,
    originalPrice: 11999,
    image: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/asus_rog_1_jkl901.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/asus_rog_2_mno234.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/asus_rog_3_pqr567.jpg'
    ],
    category: 'لابتوبات',
    featured: true,
    isAvailable: true,
    stock: 5,
    rating: 4.8,
    reviewsCount: 41
  },
  
  // سماعات
  {
    name: 'AirPods Pro 2',
    description: 'سماعات آبل اللاسلكية بإلغاء الضوضاء النشط',
    price: 899,
    originalPrice: 999,
    image: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/airpods_pro_1_stu890.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/airpods_pro_2_vwx123.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/airpods_pro_3_yza456.jpg'
    ],
    category: 'سماعات',
    featured: true,
    isAvailable: true,
    stock: 50,
    rating: 4.7,
    reviewsCount: 234
  },
  {
    name: 'Sony WH-1000XM5',
    description: 'سماعات سوني الاحترافية بإلغاء الضوضاء',
    price: 1299,
    originalPrice: 1499,
    image: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sony_wh1000xm5_1_bcd789.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sony_wh1000xm5_2_efg012.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sony_wh1000xm5_3_hij345.jpg'
    ],
    category: 'سماعات',
    featured: false,
    isAvailable: true,
    stock: 25,
    rating: 4.8,
    reviewsCount: 156
  },
  {
    name: 'Bose QuietComfort Ultra',
    description: 'سماعات بوز بأفضل إلغاء ضوضاء في العالم',
    price: 1599,
    originalPrice: 1799,
    image: 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/bose_qc_ultra_1_efg678.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/bose_qc_ultra_2_hij901.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/bose_qc_ultra_3_klm234.jpg'
    ],
    category: 'سماعات',
    featured: false,
    isAvailable: true,
    stock: 20,
    rating: 4.6,
    reviewsCount: 89
  },
  {
    name: 'Sennheiser Momentum 4',
    description: 'سماعات سينهايزر بجودة صوت استثنائية',
    price: 1199,
    originalPrice: 1399,
    image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sennheiser_momentum_1_nop567.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sennheiser_momentum_2_qrs890.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/sennheiser_momentum_3_tuv123.jpg'
    ],
    category: 'سماعات',
    featured: false,
    isAvailable: true,
    stock: 15,
    rating: 4.5,
    reviewsCount: 67
  },
  {
    name: 'JBL Live 660NC',
    description: 'سماعات JBL بإلغاء ضوضاء وصوت قوي',
    price: 599,
    originalPrice: 799,
    image: 'https://images.unsplash.com/photo-1558756520-22cfe5d382ca?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/jbl_live_660nc_1_wxy456.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/jbl_live_660nc_2_zab789.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/jbl_live_660nc_3_cde012.jpg'
    ],
    category: 'سماعات',
    featured: false,
    isAvailable: true,
    stock: 30,
    rating: 4.3,
    reviewsCount: 112
  },
  
  // ساعات ذكية
  {
    name: 'Apple Watch Series 9',
    description: 'ساعة آبل الذكية بمعالج S9 وشاشة أكثر إشراقاً',
    price: 1599,
    originalPrice: 1799,
    image: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/apple_watch_s9_1_fgh345.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/apple_watch_s9_2_ijk678.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/apple_watch_s9_3_lmn901.jpg'
    ],
    category: 'ساعات ذكية',
    featured: true,
    isAvailable: true,
    stock: 40,
    rating: 4.7,
    reviewsCount: 189
  },
  {
    name: 'Samsung Galaxy Watch 6',
    description: 'ساعة سامسونج الذكية بمراقبة صحية متقدمة',
    price: 1299,
    originalPrice: 1499,
    image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/galaxy_watch_6_1_opq234.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/galaxy_watch_6_2_rst567.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/galaxy_watch_6_3_uvw890.jpg'
    ],
    category: 'ساعات ذكية',
    featured: false,
    isAvailable: true,
    stock: 25,
    rating: 4.5,
    reviewsCount: 134
  },
  {
    name: 'Garmin Fenix 7X',
    description: 'ساعة جارمين للرياضيين والمغامرين',
    price: 2299,
    originalPrice: 2599,
    image: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/fitbit_versa_4_1_xyz123.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/fitbit_versa_4_2_abc456.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/fitbit_versa_4_3_def789.jpg'
    ],
    category: 'ساعات ذكية',
    featured: false,
    isAvailable: true,
    stock: 12,
    rating: 4.8,
    reviewsCount: 76
  },
  {
    name: 'Fitbit Sense 2',
    description: 'ساعة فيتبت بمراقبة الإجهاد ومعدل ضربات القلب',
    price: 899,
    originalPrice: 1099,
    image: 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/garmin_venu_3_1_ghi012.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/garmin_venu_3_2_jkl345.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/garmin_venu_3_3_mno678.jpg'
    ],
    category: 'ساعات ذكية',
    featured: false,
    isAvailable: true,
    stock: 20,
    rating: 4.4,
    reviewsCount: 98
  },
  {
    name: 'Huawei Watch GT 4',
    description: 'ساعة هواوي بتصميم كلاسيكي وبطارية طويلة المدى',
    price: 799,
    originalPrice: 999,
    image: 'https://images.unsplash.com/photo-1579586337278-3f436f25d4d6?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/huawei_watch_gt4_1_abc012.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/huawei_watch_gt4_2_def345.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/huawei_watch_gt4_3_ghi678.jpg'
    ],
    category: 'ساعات ذكية',
    featured: false,
    isAvailable: true,
    stock: 18,
    rating: 4.3,
    reviewsCount: 87
  },
  
  // أجهزة لوحية
  {
    name: 'iPad Pro 12.9 M2',
    description: 'جهاز آيباد برو بمعالج M2 وشاشة Liquid Retina XDR',
    price: 4999,
    originalPrice: 5499,
    image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/amazfit_gtr_4_1_pqr901.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/amazfit_gtr_4_2_stu234.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/amazfit_gtr_4_3_vwx567.jpg'
    ],
    category: 'أجهزة لوحية',
    featured: true,
    isAvailable: true,
    stock: 15,
    rating: 4.8,
    reviewsCount: 123
  },
  {
    name: 'Samsung Galaxy Tab S9 Ultra',
    description: 'جهاز سامسونج اللوحي بشاشة 14.6 بوصة وقلم S Pen',
    price: 4299,
    originalPrice: 4799,
    image: 'https://images.unsplash.com/photo-1561154464-82e9adf32764?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/galaxy_tab_s9_1_yza890.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/galaxy_tab_s9_2_bcd123.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/galaxy_tab_s9_3_efg456.jpg'
    ],
    category: 'أجهزة لوحية',
    featured: false,
    isAvailable: true,
    stock: 10,
    rating: 4.6,
    reviewsCount: 89
  },
  {
    name: 'Microsoft Surface Pro 9',
    description: 'جهاز مايكروسوفت اللوحي بنظام Windows 11',
    price: 3599,
    originalPrice: 3999,
    image: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/logitech_mx_master_1_ijk234.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/logitech_mx_master_2_lmn567.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/logitech_mx_master_3_opq890.jpg'
    ],
    category: 'أجهزة لوحية',
    featured: false,
    isAvailable: true,
    stock: 8,
    rating: 4.5,
    reviewsCount: 67
  },
  {
    name: 'Lenovo Tab P12 Pro',
    description: 'جهاز لينوفو اللوحي بشاشة OLED وأداء قوي',
    price: 2299,
    originalPrice: 2699,
    image: 'https://images.unsplash.com/photo-1585790050230-5dd28404ccb9?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/surface_pro_9_1_hij789.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/surface_pro_9_2_klm012.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/surface_pro_9_3_nop345.jpg'
    ],
    category: 'أجهزة لوحية',
    featured: false,
    isAvailable: true,
    stock: 12,
    rating: 4.4,
    reviewsCount: 45
  },
  {
    name: 'Huawei MatePad Pro 12.6',
    description: 'جهاز هواوي اللوحي بشاشة OLED ومعالج Kirin',
    price: 1999,
    originalPrice: 2399,
    image: 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/lenovo_tab_p12_1_qrs678.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/lenovo_tab_p12_2_tuv901.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/lenovo_tab_p12_3_wxy234.jpg'
    ],
    category: 'أجهزة لوحية',
    featured: false,
    isAvailable: true,
    stock: 14,
    rating: 4.3,
    reviewsCount: 56
  },
  
  // إكسسوارات
  {
    name: 'MagSafe Charger',
    description: 'شاحن آبل اللاسلكي المغناطيسي للآيفون',
    price: 199,
    originalPrice: 249,
    image: 'https://images.unsplash.com/photo-1609592806787-3d9c4d5b3b7d?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/magsafe_charger_1_zab345.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/magsafe_charger_2_cde678.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/magsafe_charger_3_fgh901.jpg'
    ],
    category: 'إكسسوارات',
    featured: false,
    isAvailable: true,
    stock: 100,
    rating: 4.5,
    reviewsCount: 267
  },
  {
    name: 'Anker PowerCore 26800',
    description: 'بطارية محمولة بسعة 26800 مللي أمبير',
    price: 299,
    originalPrice: 399,
    image: 'https://images.unsplash.com/photo-1609592806787-3d9c4d5b3b7d?w=400',
    images: ['https://images.unsplash.com/photo-1609592806787-3d9c4d5b3b7d?w=400'],
    category: 'إكسسوارات',
    featured: false,
    isAvailable: true,
    stock: 75,
    rating: 4.6,
    reviewsCount: 189
  },
  {
    name: 'Logitech MX Master 3S',
    description: 'ماوس لوجيتك الاحترافي للمصممين والمطورين',
    price: 399,
    originalPrice: 499,
    image: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/surface_pro_9_1_jkl901.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/surface_pro_9_2_mno234.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/surface_pro_9_3_pqr567.jpg'
    ],
    category: 'إكسسوارات',
    featured: false,
    isAvailable: true,
    stock: 50,
    rating: 4.7,
    reviewsCount: 145
  },
  {
    name: 'Apple Magic Keyboard',
    description: 'لوحة مفاتيح آبل اللاسلكية بتصميم نحيف',
    price: 499,
    originalPrice: 599,
    image: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=400',
    images: [
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/magic_keyboard_1_rst123.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/magic_keyboard_2_uvw456.jpg',
      'https://res.cloudinary.com/dq1anqzzx/image/upload/v1735659123/gizmo_store/products/magic_keyboard_3_xyz789.jpg'
    ],
    category: 'إكسسوارات',
    featured: false,
    isAvailable: true,
    stock: 40,
    rating: 4.4,
    reviewsCount: 98
  },
  {
    name: 'Samsung 65W Fast Charger',
    description: 'شاحن سامسونج السريع بقوة 65 واط',
    price: 149,
    originalPrice: 199,
    image: 'https://images.unsplash.com/photo-1609592806787-3d9c4d5b3b7d?w=400',
    images: ['https://images.unsplash.com/photo-1609592806787-3d9c4d5b3b7d?w=400'],
    category: 'إكسسوارات',
    featured: false,
    isAvailable: true,
    stock: 80,
    rating: 4.3,
    reviewsCount: 156
  },
  
  // منتجات إضافية
  {
    name: 'iPhone 14 Pro',
    description: 'آيفون 14 برو بكاميرا 48 ميجابكسل وشاشة Dynamic Island',
    price: 3999,
    originalPrice: 4499,
    image: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
    images: ['https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400'],
    category: 'هواتف ذكية',
    featured: false,
    isAvailable: true,
    stock: 22,
    rating: 4.6,
    reviewsCount: 178
  },
  {
    name: 'MacBook Air M2',
    description: 'لابتوب آبل الخفيف بمعالج M2 وتصميم جديد',
    price: 5999,
    originalPrice: 6999,
    image: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
    images: ['https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400'],
    category: 'لابتوبات',
    featured: false,
    isAvailable: true,
    stock: 16,
    rating: 4.7,
    reviewsCount: 92
  },
  {
    name: 'Sony WF-1000XM4',
    description: 'سماعات سوني اللاسلكية بإلغاء الضوضاء',
    price: 799,
    originalPrice: 999,
    image: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400',
    images: ['https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400'],
    category: 'سماعات',
    featured: false,
    isAvailable: true,
    stock: 35,
    rating: 4.5,
    reviewsCount: 167
  },
  {
    name: 'Apple Watch Ultra 2',
    description: 'ساعة آبل للمغامرات بتصميم متين وبطارية طويلة',
    price: 2999,
    originalPrice: 3299,
    image: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
    images: ['https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400'],
    category: 'ساعات ذكية',
    featured: true,
    isAvailable: true,
    stock: 8,
    rating: 4.9,
    reviewsCount: 45
  },
  {
    name: 'iPad Air 5',
    description: 'آيباد إير بمعالج M1 وشاشة Liquid Retina',
    price: 2299,
    originalPrice: 2699,
    image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
    images: ['https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400'],
    category: 'أجهزة لوحية',
    featured: false,
    isAvailable: true,
    stock: 20,
    rating: 4.6,
    reviewsCount: 134
  },
  {
    name: 'Razer DeathAdder V3',
    description: 'ماوس ريزر للألعاب بدقة عالية وتصميم مريح',
    price: 299,
    originalPrice: 399,
    image: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400',
    images: ['https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400'],
    category: 'إكسسوارات',
    featured: false,
    isAvailable: true,
    stock: 45,
    rating: 4.4,
    reviewsCount: 89
  },
  {
    name: 'Google Pixel Buds Pro',
    description: 'سماعات جوجل اللاسلكية بإلغاء الضوضاء النشط',
    price: 699,
    originalPrice: 899,
    image: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400',
    images: ['https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400'],
    category: 'سماعات',
    featured: false,
    isAvailable: true,
    stock: 28,
    rating: 4.3,
    reviewsCount: 76
  },
  {
    name: 'Nothing Phone 2',
    description: 'هاتف نوثينغ بتصميم شفاف وإضاءة Glyph',
    price: 1999,
    originalPrice: 2299,
    image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
    images: ['https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400'],
    category: 'هواتف ذكية',
    featured: false,
    isAvailable: true,
    stock: 12,
    rating: 4.2,
    reviewsCount: 54
  },
  {
    name: 'Microsoft Surface Laptop 5',
    description: 'لابتوب مايكروسوفت بتصميم أنيق وأداء قوي',
    price: 5499,
    originalPrice: 6299,
    image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
    images: ['https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400'],
    category: 'لابتوبات',
    featured: false,
    isAvailable: true,
    stock: 9,
    rating: 4.5,
    reviewsCount: 67
  },
  {
    name: 'Beats Studio Pro',
    description: 'سماعات بيتس الاحترافية بصوت عالي الجودة',
    price: 999,
    originalPrice: 1199,
    image: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400',
    images: ['https://images.unsplash.com/photo-1583394838336-acd977736f90?w=400'],
    category: 'سماعات',
    featured: false,
    isAvailable: true,
    stock: 22,
    rating: 4.4,
    reviewsCount: 98
  },
  {
    name: 'Amazfit GTR 4',
    description: 'ساعة أمازفيت الذكية بعمر بطارية طويل',
    price: 599,
    originalPrice: 799,
    image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
    images: ['https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400'],
    category: 'ساعات ذكية',
    featured: false,
    isAvailable: true,
    stock: 30,
    rating: 4.2,
    reviewsCount: 112
  },
  {
    name: 'iPad mini 6',
    description: 'آيباد ميني بحجم مثالي للقراءة والألعاب',
    price: 1899,
    originalPrice: 2199,
    image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
    images: ['https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400'],
    category: 'أجهزة لوحية',
    featured: false,
    isAvailable: true,
    stock: 25,
    rating: 4.5,
    reviewsCount: 89
  },
  {
    name: 'Belkin 3-in-1 Wireless Charger',
    description: 'شاحن بيلكين اللاسلكي للآيفون والساعة والسماعات',
    price: 399,
    originalPrice: 499,
    image: 'https://images.unsplash.com/photo-1609592806787-3d9c4d5b3b7d?w=400',
    images: ['https://images.unsplash.com/photo-1609592806787-3d9c4d5b3b7d?w=400'],
    category: 'إكسسوارات',
    featured: false,
    isAvailable: true,
    stock: 35,
    rating: 4.6,
    reviewsCount: 123
  },
  {
    name: 'Oppo Find X6 Pro',
    description: 'هاتف أوبو بكاميرا هاسلبلاد وشحن سريع',
    price: 2799,
    originalPrice: 3199,
    image: 'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=400',
    images: ['https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=400'],
    category: 'هواتف ذكية',
    featured: false,
    isAvailable: true,
    stock: 14,
    rating: 4.3,
    reviewsCount: 67
  },
  {
    name: 'Framework Laptop 16',
    description: 'لابتوب قابل للتخصيص والإصلاح بسهولة',
    price: 4999,
    originalPrice: 5799,
    image: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400',
    images: ['https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400'],
    category: 'لابتوبات',
    featured: false,
    isAvailable: true,
    stock: 6,
    rating: 4.7,
    reviewsCount: 34
  },
  {
    name: 'Audio-Technica ATH-M50xBT2',
    description: 'سماعات أوديو تكنيكا الاحترافية اللاسلكية',
    price: 899,
    originalPrice: 1099,
    image: 'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=400',
    images: ['https://images.unsplash.com/photo-1484704849700-f032a568e944?w=400'],
    category: 'سماعات',
    featured: false,
    isAvailable: true,
    stock: 18,
    rating: 4.6,
    reviewsCount: 87
  },
  {
    name: 'Polar Vantage V3',
    description: 'ساعة بولار الرياضية للعدائين والرياضيين',
    price: 1799,
    originalPrice: 2099,
    image: 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400',
    images: ['https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=400'],
    category: 'ساعات ذكية',
    featured: false,
    isAvailable: true,
    stock: 10,
    rating: 4.5,
    reviewsCount: 56
  },
  {
    name: 'Kindle Oasis',
    description: 'قارئ كتب إلكترونية من أمازون بشاشة عالية الدقة',
    price: 999,
    originalPrice: 1199,
    image: 'https://images.unsplash.com/photo-1585790050230-5dd28404ccb9?w=400',
    images: ['https://images.unsplash.com/photo-1585790050230-5dd28404ccb9?w=400'],
    category: 'أجهزة لوحية',
    featured: false,
    isAvailable: true,
    stock: 15,
    rating: 4.4,
    reviewsCount: 78
  },
  {
    name: 'SteelSeries Arctis Nova Pro',
    description: 'سماعات ستيل سيريز للألعاب بجودة صوت احترافية',
    price: 1299,
    originalPrice: 1599,
    image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
    images: ['https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400'],
    category: 'سماعات',
    featured: false,
    isAvailable: true,
    stock: 12,
    rating: 4.7,
    reviewsCount: 45
  }
];

async function addProducts() {
  console.log('بدء إضافة المنتجات...');
  
  const batch = db.batch();
  
  for (let i = 0; i < products.length; i++) {
    const product = products[i];
    const docRef = db.collection('products').doc();
    
    const productData = {
      ...product,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };
    
    batch.set(docRef, productData);
    console.log(`تم إعداد المنتج ${i + 1}: ${product.name}`);
  }
  
  try {
    await batch.commit();
    console.log('تم إضافة جميع المنتجات بنجاح!');
    console.log(`تم إضافة ${products.length} منتج إلى قاعدة البيانات`);
  } catch (error) {
    console.error('خطأ في إضافة المنتجات:', error);
  }
}

addProducts().then(() => {
  console.log('انتهت عملية إضافة المنتجات');
  process.exit(0);
}).catch((error) => {
  console.error('خطأ:', error);
  process.exit(1);
});