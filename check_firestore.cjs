const admin = require('firebase-admin');

// Initialize Firebase Admin
const serviceAccount = require('./admin_auth.json');
serviceAccount.project_id = 'gizmostore-2a3ff'; // إضافة project_id

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'gizmostore-2a3ff'
});

const db = admin.firestore();

async function checkFirestore() {
  try {
    console.log('🔍 Checking Firestore collections...');
    
    // Check products collection
    const productsSnapshot = await db.collection('products').limit(5).get();
    console.log(`📦 Found ${productsSnapshot.size} products`);
    
    if (!productsSnapshot.empty) {
      console.log('📋 Sample products:');
      productsSnapshot.forEach(doc => {
        const data = doc.data();
        console.log(`   - ${data.name} (${data.price} SDG)`);
      });
    } else {
      console.log('❌ No products found in database');
    }
    
    // Check categories collection
    const categoriesSnapshot = await db.collection('categories').get();
    console.log(`📂 Found ${categoriesSnapshot.size} categories`);
    
    if (!categoriesSnapshot.empty) {
      console.log('📋 Categories:');
      categoriesSnapshot.forEach(doc => {
        const data = doc.data();
        console.log(`   - ${data.name || data.nameAr} (${data.nameEn})`);
      });
    }
    
  } catch (error) {
    console.error('❌ Error checking Firestore:', error);
  }
}

checkFirestore();