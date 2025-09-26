// Script to create admin user document in Firestore using Firebase CLI
const { execSync } = require('child_process');

const adminUID = 'q3x9weNlEmYpRnM4NSGB8I8kvd73';
const adminEmail = 'admin@gizmo.com';

// Admin user data
const adminData = {
  uid: adminUID,
  email: adminEmail,
  displayName: 'Admin User',
  isAdmin: true,
  role: 'admin',
  userType: 'admin',
  permissions: {
    products: {
      create: true,
      read: true,
      update: true,
      delete: true
    },
    users: {
      create: true,
      read: true,
      update: true,
      delete: true
    },
    orders: {
      create: true,
      read: true,
      update: true,
      delete: true
    },
    categories: {
      create: true,
      read: true,
      update: true,
      delete: true
    },
    coupons: {
      create: true,
      read: true,
      update: true,
      delete: true
    },
    analytics: {
      read: true
    },
    settings: {
      read: true,
      update: true
    }
  },
  createdAt: new Date().toISOString(),
  updatedAt: new Date().toISOString(),
  lastLogin: new Date().toISOString(),
  lastLoginAt: new Date().toISOString()
};

try {
  console.log('🔄 Creating admin user document in Firestore...');
  
  // Write data to temporary file
  const fs = require('fs');
  const tempFile = 'temp_admin_data.json';
  fs.writeFileSync(tempFile, JSON.stringify(adminData, null, 2));
  
  // Use Firebase CLI to set the document
  const command = `firebase firestore:set users/${adminUID} ${tempFile} --project gizmostore-2a3ff`;
  
  console.log('📝 Executing:', command);
  const result = execSync(command, { encoding: 'utf8' });
  
  console.log('✅ Admin user document created successfully!');
  console.log('📧 Email:', adminEmail);
  console.log('🔑 UID:', adminUID);
  console.log('👑 Role: admin');
  console.log('🛡️ isAdmin: true');
  console.log('📝 userType: admin');
  console.log('✨ Full permissions granted');
  
  // Clean up temp file
  fs.unlinkSync(tempFile);
  
  console.log('\n🎯 Now the admin user should redirect to AdminPanel on login!');
  
} catch (error) {
  console.error('❌ Error creating admin user document:', error.message);
  
  // Try alternative method using direct Firebase CLI command
  console.log('\n🔄 Trying alternative method...');
  
  try {
    const directCommand = `firebase firestore:set users/${adminUID} '{"uid":"${adminUID}","email":"${adminEmail}","displayName":"Admin User","isAdmin":true,"role":"admin","userType":"admin"}' --project gizmostore-2a3ff`;
    
    console.log('📝 Executing direct command...');
    execSync(directCommand, { encoding: 'utf8' });
    
    console.log('✅ Admin user document created with direct method!');
    console.log('🎯 Admin user should now redirect to AdminPanel!');
    
  } catch (directError) {
    console.error('❌ Direct method also failed:', directError.message);
    console.log('\n💡 Manual solution:');
    console.log('1. Open Firebase Console: https://console.firebase.google.com/');
    console.log('2. Go to Firestore Database');
    console.log('3. Create document: users/' + adminUID);
    console.log('4. Add fields:');
    console.log('   - isAdmin: true (boolean)');
    console.log('   - role: "admin" (string)');
    console.log('   - userType: "admin" (string)');
    console.log('   - email: "' + adminEmail + '" (string)');
  }
}

console.log('\n🔧 Script completed.');