// Script to update products using Firebase CLI commands
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

async function updateProductsWithCLI() {
  console.log('🚀 بدء تحديث المنتجات باستخدام Firebase CLI...');
  
  try {
    // First, let's get all products to see what we're working with
    console.log('📦 جلب قائمة المنتجات...');
    
    // Create a simple update script for each product
    const updateCommands = [
      // Update all products to have stock and be available
      `firebase firestore:update products --data '{"stock": 25, "stockQuantity": 25, "isAvailable": true, "inStock": true}' --where 'stock <= 0'`,
      `firebase firestore:update products --data '{"isAvailable": true, "inStock": true}' --where 'stock > 0'`
    ];
    
    for (const command of updateCommands) {
      console.log(`🔄 تنفيذ: ${command}`);
      try {
        const { stdout, stderr } = await execAsync(command);
        if (stdout) console.log('✅ النتيجة:', stdout);
        if (stderr) console.log('⚠️ تحذير:', stderr);
      } catch (error) {
        console.log('❌ خطأ في الأمر:', error.message);
      }
    }
    
    console.log('🎉 انتهى تحديث المنتجات!');
    
  } catch (error) {
    console.error('❌ خطأ عام:', error.message);
  }
}

// Run the update
updateProductsWithCLI();