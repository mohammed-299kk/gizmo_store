const admin = require('firebase-admin');
const serviceAccount = require('./gizmo-store-firebase-adminsdk-ixqzj-b5b8b7b8b8.json');

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

async function deleteUser() {
  try {
    const uid = 'Hj11wZ1FlANccDf5xoi9ujdZiFM2';
    
    console.log(`Attempting to delete user with UID: ${uid}`);
    
    await admin.auth().deleteUser(uid);
    
    console.log('Successfully deleted user');
    process.exit(0);
  } catch (error) {
    console.error('Error deleting user:', error);
    process.exit(1);
  }
}

deleteUser();