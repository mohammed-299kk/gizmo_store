const { initializeApp, cert } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');
const { readFileSync } = require('fs');

// Initialize Firebase Admin
let serviceAccount;
try {
  // Try different service account files
  try {
    serviceAccount = JSON.parse(readFileSync('./admin_auth.json', 'utf8'));
  } catch (e) {
    console.log('admin_auth.json not found or invalid, trying alternative...');
    // Create a minimal service account for web-based access
    serviceAccount = {
      type: "service_account",
      project_id: "gizmostore-2a3ff",
      private_key_id: "dummy",
      private_key: "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC7VJTUt9Us8cKB\n-----END PRIVATE KEY-----\n",
      client_email: "firebase-adminsdk@gizmostore-2a3ff.iam.gserviceaccount.com",
      client_id: "dummy",
      auth_uri: "https://accounts.google.com/o/oauth2/auth",
      token_uri: "https://oauth2.googleapis.com/token"
    };
  }
} catch (error) {
  console.error('❌ Error reading service account:', error.message);
  process.exit(1);
}

// Initialize Firebase
try {
  initializeApp({
    credential: cert(serviceAccount),
    projectId: serviceAccount.project_id
  });
} catch (error) {
  console.error('❌ Firebase initialization failed:', error.message);
  console.log('🔄 Trying alternative initialization...');
  
  // Alternative: Use environment variables or default credentials
  try {
    initializeApp({
      projectId: "gizmostore-2a3ff"
    });
  } catch (altError) {
    console.error('❌ Alternative initialization also failed:', altError.message);
    process.exit(1);
  }
}

const db = getFirestore();

async function cleanBrokenProducts() {
  console.log('🧹 Starting cleanup of products with broken images...\n');

  try {
    const snapshot = await db.collection('products').get();
    console.log(`📊 Total products found: ${snapshot.size}`);
    console.log('=' * 50);

    let deletedCount = 0;
    const deletedProducts = [];
    const batch = db.batch();

    snapshot.forEach((doc) => {
      const data = doc.data();
      const name = data.name || 'Unknown';
      const imageUrl = data.image || '';
      const featured = data.featured || false;

      // Check if image is broken or missing
      const isBrokenImage = !imageUrl || 
          imageUrl === 'null' || 
          imageUrl.includes('placeholder') || 
          imageUrl.includes('example.com') ||
          imageUrl.includes('via.placeholder.com') ||
          imageUrl.includes('assets/images/') ||
          imageUrl.startsWith('assets/') ||
          !imageUrl.startsWith('http');

      if (isBrokenImage) {
        console.log(`🗑️ Marking for deletion: ${featured ? '[FEATURED] ' : ''}${name}`);
        console.log(`   Broken image: ${imageUrl}`);
        
        batch.delete(doc.ref);
        deletedCount++;
        deletedProducts.push(name);
      } else {
        console.log(`✅ Keeping: ${featured ? '[FEATURED] ' : ''}${name}`);
      }
    });

    if (deletedCount > 0) {
      console.log(`\n🔄 Committing deletion of ${deletedCount} products...`);
      await batch.commit();
      console.log('✅ Batch deletion completed successfully!');
    } else {
      console.log('\n✅ No products with broken images found!');
    }

    console.log('\n' + '=' * 50);
    console.log('📈 Cleanup Summary:');
    console.log(`🗑️ Products deleted: ${deletedCount}`);
    console.log(`✅ Products remaining: ${snapshot.size - deletedCount}`);

    if (deletedProducts.length > 0) {
      console.log('\n📝 Deleted products:');
      deletedProducts.forEach(product => {
        console.log(`  - ${product}`);
      });
    }

    console.log('\n🎉 Cleanup completed successfully!');

  } catch (error) {
    console.error('❌ Error during cleanup:', error.message);
    console.error('Full error:', error);
  }
}

cleanBrokenProducts();