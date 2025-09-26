import admin from 'firebase-admin';
import { readFileSync } from 'fs';

const serviceAccount = JSON.parse(readFileSync('./admin_auth.json', 'utf8'));

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function updateFeaturedProducts() {
  try {
    console.log('🔄 Updating products to add featured field...');
    
    // Get all products
    const productsSnapshot = await db.collection('products').get();
    
    if (productsSnapshot.empty) {
      console.log('❌ No products found!');
      return;
    }
    
    const batch = db.batch();
    let count = 0;
    
    // Featured product IDs
    const featuredProductIds = [
      'airpods-pro-2',
      'apple-watch-series-9', 
      'anker-powerbank'
    ];
    
    productsSnapshot.forEach((doc) => {
      const productRef = db.collection('products').doc(doc.id);
      const isFeatured = featuredProductIds.includes(doc.id);
      
      batch.update(productRef, {
        featured: isFeatured
      });
      
      count++;
      console.log(`📝 ${doc.id}: featured = ${isFeatured}`);
    });
    
    // Commit the batch
    await batch.commit();
    
    console.log(`✅ Successfully updated ${count} products with featured field!`);
    console.log(`🌟 ${featuredProductIds.length} products marked as featured`);
    
  } catch (error) {
    console.error('❌ Error updating products:', error);
  } finally {
    process.exit(0);
  }
}

// Run the update
updateFeaturedProducts();