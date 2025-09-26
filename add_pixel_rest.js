import fs from 'fs';
import https from 'https';

// Read product data
const productData = JSON.parse(fs.readFileSync('pixel_data.json', 'utf8'));

// Add timestamps
productData.createdAt = new Date().toISOString();
productData.updatedAt = new Date().toISOString();

// Firebase REST API endpoint
const projectId = 'gizmostore-2a3ff';
const url = `https://firestore.googleapis.com/v1/projects/${projectId}/databases/(default)/documents/products/google-pixel-8`;

// Convert data to Firestore format
function convertToFirestoreFormat(obj) {
  const result = {};
  for (const [key, value] of Object.entries(obj)) {
    if (typeof value === 'string') {
      result[key] = { stringValue: value };
    } else if (typeof value === 'number') {
      result[key] = { doubleValue: value };
    } else if (typeof value === 'boolean') {
      result[key] = { booleanValue: value };
    } else if (Array.isArray(value)) {
      result[key] = {
        arrayValue: {
          values: value.map(item => 
            typeof item === 'string' ? { stringValue: item } : { stringValue: String(item) }
          )
        }
      };
    } else if (typeof value === 'object' && value !== null) {
      result[key] = {
        mapValue: {
          fields: convertToFirestoreFormat(value)
        }
      };
    }
  }
  return result;
}

const firestoreData = {
  fields: convertToFirestoreFormat(productData)
};

console.log('🔄 محاولة إضافة منتج Google Pixel 8...');
console.log('📝 البيانات:', JSON.stringify(firestoreData, null, 2));

// Note: This would require authentication token
console.log('⚠️  ملاحظة: هذا المثال يتطلب رمز مصادقة Firebase');
console.log('✅ تم إعداد البيانات بتنسيق Firestore بنجاح');