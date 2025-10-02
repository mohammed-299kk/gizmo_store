import { initializeApp } from 'firebase/app';
import { getFirestore, collection, addDoc } from 'firebase/firestore';
import fs from 'fs';

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

// Read products from figma-design file
const figmaDesignPath = 'd:\\Program Files\\gizmo_store\\figma-design';
const figmaContent = fs.readFileSync(figmaDesignPath, 'utf8');

// Parse products from the file content
function parseProducts() {
  const products = [];
  const lines = figmaContent.split('\n');
  
  let currentProduct = null;
  let currentImages = [];
  let currentCategory = '';
  let productCounter = 1;
  
  // Define prices for each category
  const categoryPrices = {
    'سماعات': [299, 399, 499, 599, 699, 799, 899, 999, 1099, 1199],
    'لاب توب': [2999, 3999, 4999, 5999, 6999, 7999, 8999, 9999, 10999, 11999],
    'هواتف': [1999, 2499, 2999, 3499, 3999, 4499, 4999, 5499, 5999, 6499],
    'تابلت': [1299, 1599, 1899, 2199, 2499, 2799, 3099, 3399, 3699, 3999],
    'ساعات': [799, 999, 1199, 1399, 1599, 1799, 1999, 2199, 2399, 2599],
    'أجهزة تلفاز': [1999, 2499, 2999, 3499, 3999, 4499, 4999, 5499, 5999, 6499]
  };
  
  for (let i = 0; i < lines.length; i++) {
    const trimmedLine = lines[i].trim();
    
    // Skip empty lines
    if (!trimmedLine) continue;
    
    // Check if it's a category header
    if (trimmedLine.startsWith('###')) {
      currentCategory = trimmedLine.replace('###', '').trim();
      // Extract category name before parentheses
      const categoryMatch = currentCategory.match(/^([^(]+)/);
      if (categoryMatch) {
        currentCategory = categoryMatch[1].trim();
      }
      continue;
    }
    
    // Check if it's a product line (starts with number)
    const productMatch = trimmedLine.match(/^(\d+)\.\s*(.+)/);
    if (productMatch) {
      // Save previous product if exists
      if (currentProduct) {
        currentProduct.images = [...currentImages];
        products.push(currentProduct);
      }
      
      const productNumber = parseInt(productMatch[1]);
      const productName = productMatch[2].trim();
      
      // Get price for this category and product number
      const categoryPriceList = categoryPrices[currentCategory] || [999];
      const price = categoryPriceList[(productNumber - 1) % categoryPriceList.length];
      
      currentProduct = {
        id: `product_${productCounter++}`,
        name: productName,
        category: currentCategory,
        price: price,
        description: `${productName} - منتج عالي الجودة من فئة ${currentCategory}`,
        rating: (Math.random() * 1.5 + 3.5).toFixed(1), // Rating between 3.5-5.0
        reviews: Math.floor(Math.random() * 200) + 10,
        inStock: true,
        featured: Math.random() > 0.7,
        discount: Math.random() > 0.8 ? Math.floor(Math.random() * 30) + 10 : 0
      };
      currentImages = [];
      continue;
    }
    
    // Check if it's an image URL
    if (trimmedLine.startsWith('رابط الصورة') && trimmedLine.includes('http')) {
      const urlMatch = trimmedLine.match(/https?:\/\/[^\s]+/);
      if (urlMatch) {
        currentImages.push(urlMatch[0]);
      }
    }
  }
  
  // Add the last product
  if (currentProduct) {
    currentProduct.images = [...currentImages];
    products.push(currentProduct);
  }
  
  return products;
}

async function addProducts() {
  try {
    console.log('📦 بدء إضافة المنتجات الجديدة...');
    
    const products = parseProducts();
    console.log(`تم استخراج ${products.length} منتج من ملف figma-design`);
    
    if (products.length === 0) {
      console.log('❌ لم يتم العثور على منتجات في الملف');
      return;
    }
    
    // Add each product to Firestore
    let addedCount = 0;
    for (const product of products) {
      try {
        await addDoc(collection(db, 'products'), product);
        addedCount++;
        console.log(`✅ تم إضافة المنتج ${addedCount}: ${product.name}`);
      } catch (error) {
        console.error(`❌ خطأ في إضافة المنتج ${product.name}:`, error);
      }
    }
    
    console.log(`🎉 تم إضافة ${addedCount} منتج بنجاح من أصل ${products.length}!`);
    
  } catch (error) {
    console.error('❌ خطأ في إضافة المنتجات:', error);
  }
}

addProducts();