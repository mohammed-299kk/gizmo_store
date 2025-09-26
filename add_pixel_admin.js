import admin from 'firebase-admin';
import fs from 'fs';

// Initialize Firebase Admin SDK
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    projectId: 'gizmostore-2a3ff'
  });
}

const db = admin.firestore();

async function addPixelProduct() {
  try {
    // Read product data
    const productData = JSON.parse(fs.readFileSync('pixel_data.json', 'utf8'));
    
    // Add timestamps
    productData.createdAt = admin.firestore.FieldValue.serverTimestamp();
    productData.updatedAt = admin.firestore.FieldValue.serverTimestamp();
    
    // Add to Firestore
    await db.collection('products').doc('google-pixel-8').set(productData);
    
    console.log('✅ تم إضافة منتج Google Pixel 8 بنجاح!');
    console.log('Product ID: google-pixel-8');
    
  } catch (error) {
    console.error('❌ خطأ في إضافة المنتج:', error);
    process.exit(1);
  }
}

addPixelProduct();