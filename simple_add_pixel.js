import { initializeApp } from 'firebase/app';
import { getFirestore, doc, setDoc, serverTimestamp } from 'firebase/firestore';

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

async function addPixelProduct() {
  try {
    const productData = {
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
      images: [
        'https://res.cloudinary.com/dqhqkqjqz/image/upload/v1640123456/pixel-8-front.jpg',
        'https://res.cloudinary.com/dqhqkqjqz/image/upload/v1640123456/pixel-8-back.jpg',
        'https://res.cloudinary.com/dqhqkqjqz/image/upload/v1640123456/pixel-8-side.jpg'
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
      features: [
        '5G',
        'Pure Android',
        'AI Photography',
        'Wireless Charging'
      ],
      imageUrl: 'https://res.cloudinary.com/dqhqkqjqz/image/upload/v1640123456/pixel-8-main.jpg',
      image: 'https://res.cloudinary.com/dqhqkqjqz/image/upload/v1640123456/pixel-8-main.jpg',
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp()
    };

    const productRef = doc(db, 'products', 'google-pixel-8');
    await setDoc(productRef, productData);
    console.log('تم إضافة منتج Google Pixel 8 بنجاح');
    process.exit(0);
  } catch (error) {
    console.error('خطأ في إضافة المنتج:', error);
    process.exit(1);
  }
}

addPixelProduct();