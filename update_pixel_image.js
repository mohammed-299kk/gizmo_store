import admin from 'firebase-admin';

// Initialize Firebase Admin
if (!admin.apps.length) {
  admin.initializeApp({
    projectId: 'gizmostore-2a3ff'
  });
}

const db = admin.firestore();

async function updatePixelImage() {
  try {
    const productRef = db.collection('products').doc('google-pixel-8');
    await productRef.update({
      imageUrl: 'https://images.unsplash.com/photo-1710866154584-2c4b0e2e8c1a?w=500&h=500&fit=crop&crop=center',
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
    console.log('تم تحديث صورة Google Pixel 8 بنجاح');
    process.exit(0);
  } catch (error) {
    console.error('خطأ في تحديث الصورة:', error);
    process.exit(1);
  }
}

updatePixelImage();