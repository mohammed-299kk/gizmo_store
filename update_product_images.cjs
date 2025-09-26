const admin = require('firebase-admin');

// Initialize Firebase Admin
const serviceAccount = require('./admin_auth.json');
serviceAccount.project_id = 'gizmostore-2a3ff';

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'gizmostore-2a3ff'
});

const db = admin.firestore();

// Product image mappings from figma-design file
const productImageMappings = {
  'Apple AirPods Pro': 'https://m.media-amazon.com/images/I/61SUj2aAoQS._AC_SL1500_.jpg',
  'AirPods Pro 2': 'https://m.media-amazon.com/images/I/61SUj2aAoQS._AC_SL1500_.jpg',
  'AirPods Pro': 'https://m.media-amazon.com/images/I/61SUj2aAoQS._AC_SL1500_.jpg',
  'Sony WH-1000XM5': 'https://m.media-amazon.com/images/I/61VPY3p+f0L._AC_SL1500_.jpg',
  'Bose QuietComfort 45': 'https://m.media-amazon.com/images/I/71m5rZfh88L._AC_SL1500_.jpg',
  'Bose QuietComfort': 'https://m.media-amazon.com/images/I/71m5rZfh88L._AC_SL1500_.jpg',
  'Beats Studio3 Wireless': 'https://m.media-amazon.com/images/I/61drpbBuCxL._AC_SL1500_.jpg',
  'Beats Studio3': 'https://m.media-amazon.com/images/I/61drpbBuCxL._AC_SL1500_.jpg',
  'Sennheiser Momentum 4': 'https://m.media-amazon.com/images/I/61Z3n3U5ZTL._AC_SL1500_.jpg',
  'JBL Live 660NC': 'https://m.media-amazon.com/images/I/61kBiws284L._AC_SL1500_.jpg',
  'Audio-Technica ATH-M50xBT2': 'https://m.media-amazon.com/images/I/71x6j45M+jL._AC_SL1500_.jpg',
  'Marshall Major IV': 'https://m.media-amazon.com/images/I/61hzl5n3k+L._AC_SL1500_.jpg'
};

async function updateProductImages() {
  try {
    console.log('🔄 بدء تحديث روابط صور المنتجات...');
    
    // Get all products
    const productsSnapshot = await db.collection('products').get();
    console.log(`📦 تم العثور على ${productsSnapshot.size} منتج`);
    
    let updatedCount = 0;
    
    for (const doc of productsSnapshot.docs) {
      const productData = doc.data();
      const productName = productData.name;
      
      // Check if we have a mapping for this product
      let newImageUrl = null;
      
      // Try exact match first
      if (productImageMappings[productName]) {
        newImageUrl = productImageMappings[productName];
      } else {
        // Try partial matches
        for (const [mappingName, imageUrl] of Object.entries(productImageMappings)) {
          if (productName.includes(mappingName) || mappingName.includes(productName)) {
            newImageUrl = imageUrl;
            break;
          }
        }
      }
      
      if (newImageUrl && productData.image !== newImageUrl) {
        // Update the product with new image URL
        await doc.ref.update({
          image: newImageUrl,
          imageUrl: newImageUrl // Also update imageUrl field if it exists
        });
        
        console.log(`✅ تم تحديث صورة المنتج: ${productName}`);
        console.log(`   الرابط الجديد: ${newImageUrl}`);
        updatedCount++;
      } else if (newImageUrl) {
        console.log(`⏭️  المنتج ${productName} يحتوي بالفعل على الرابط الصحيح`);
      } else {
        console.log(`⚠️  لم يتم العثور على رابط صورة للمنتج: ${productName}`);
      }
    }
    
    console.log(`\n🎉 تم تحديث ${updatedCount} منتج بنجاح!`);
    
  } catch (error) {
    console.error('❌ خطأ في تحديث صور المنتجات:', error);
  }
}

updateProductImages();