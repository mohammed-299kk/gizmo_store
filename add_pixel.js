import { readFileSync } from 'fs';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

async function addPixelProduct() {
  try {
    // Read the product data
    const productData = JSON.parse(readFileSync('pixel_product.json', 'utf8'));
    
    // Add timestamps
    const now = new Date().toISOString();
    productData.createdAt = now;
    productData.updatedAt = now;
    
    // Convert to Firebase CLI format
    const firestoreData = JSON.stringify(productData, null, 2);
    
    console.log('إضافة منتج Google Pixel 8 إلى قاعدة البيانات...');
    console.log('البيانات:', firestoreData);
    
    // Use Firebase CLI to add the document
    const command = `firebase firestore:set products/google-pixel-8 --data '${JSON.stringify(productData)}'`;
    const { stdout, stderr } = await execAsync(command);
    
    if (stderr) {
      console.error('خطأ:', stderr);
    } else {
      console.log('تم إضافة المنتج بنجاح:', stdout);
    }
  } catch (error) {
    console.error('خطأ في إضافة المنتج:', error);
  }
}

addPixelProduct();