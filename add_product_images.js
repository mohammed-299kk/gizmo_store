import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, doc, updateDoc } from 'firebase/firestore';

// Firebase config
const firebaseConfig = {
  apiKey: "AIzaSyBGVJKJJKJKJKJKJKJKJKJKJKJKJKJKJKJ",
  authDomain: "gizmostore-2a3ff.firebaseapp.com",
  projectId: "gizmostore-2a3ff",
  storageBucket: "gizmostore-2a3ff.firebasestorage.app",
  messagingSenderId: "32902740595",
  appId: "1:32902740595:web:7de8f1273a64f9f28fc806"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// Product images mapping
const productImages = {
  'Acer Swift 3': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop',
  'Apple AirPods Pro 2': 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=500&h=500&fit=crop',
  'Amazfit GTR 4': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500&h=500&fit=crop',
  'Amazon Fire HD 10': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop',
  'Apple Watch Series 9': 'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=500&h=500&fit=crop',
  'Samsung Galaxy S24': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=500&fit=crop',
  'iPhone 15 Pro': 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500&h=500&fit=crop',
  'MacBook Pro': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500&h=500&fit=crop',
  'iPad Pro': 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500&h=500&fit=crop',
  'Sony WH-1000XM5': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=500&fit=crop',
  'Dell XPS 13': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=500&fit=crop',
  'Nintendo Switch': 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=500&h=500&fit=crop',
  'PlayStation 5': 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=500&h=500&fit=crop',
  'Xbox Series X': 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=500&h=500&fit=crop',
  'Samsung TV': 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=500&h=500&fit=crop',
  'LG OLED TV': 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=500&h=500&fit=crop',
  'Canon EOS R5': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=500&h=500&fit=crop',
  'Nikon D850': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=500&h=500&fit=crop',
  'GoPro Hero 12': 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=500&h=500&fit=crop',
  'DJI Mini 4 Pro': 'https://images.unsplash.com/photo-1473968512647-3e447244af8f?w=500&h=500&fit=crop'
};

// Default image for products without specific mapping
const defaultImage = 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=500&h=500&fit=crop';

async function addProductImages() {
  try {
    console.log('جاري إضافة الصور للمنتجات...');
    
    const querySnapshot = await getDocs(collection(db, 'products'));
    console.log(`عدد المنتجات: ${querySnapshot.size}`);
    
    let updatedCount = 0;
    
    for (const docSnapshot of querySnapshot.docs) {
      const data = docSnapshot.data();
      const productName = data.name;
      
      // Skip if already has image
      if (data.imageUrl && data.imageUrl.trim() !== '') {
        console.log(`تم تخطي ${productName} - يحتوي على صورة بالفعل`);
        continue;
      }
      
      // Find matching image or use default
      let imageUrl = defaultImage;
      for (const [name, url] of Object.entries(productImages)) {
        if (productName && productName.toLowerCase().includes(name.toLowerCase())) {
          imageUrl = url;
          break;
        }
      }
      
      // Update the document
      await updateDoc(doc(db, 'products', docSnapshot.id), {
        imageUrl: imageUrl
      });
      
      console.log(`تم تحديث ${productName} بالصورة: ${imageUrl}`);
      updatedCount++;
    }
    
    console.log(`\nتم تحديث ${updatedCount} منتج بنجاح!`);
    
  } catch (error) {
    console.error('خطأ في إضافة الصور:', error);
  }
}

addProductImages();