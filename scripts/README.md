# Firebase Admin User Creation Tool

## 🔐 Secure Admin User Setup

This tool allows you to securely create admin users for your Firebase project without hardcoding sensitive credentials.

## Prerequisites

### 1. Firebase Service Account Key
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your `gizmostore-2a3ff` project
3. Go to **Project Settings** → **Service Accounts**
4. Click **Generate New Private Key**
5. Save the JSON file as `gizmostore-2a3ff-firebase-adminsdk.json` in the `scripts/` directory

### 2. Node.js Setup
```bash
# Navigate to scripts directory
cd scripts

# Install dependencies
npm install

# Or install Firebase Admin SDK directly
npm install firebase-admin
```

## Usage

### Method 1: Interactive Script (Recommended)
```bash
# Run the interactive admin creation tool
npm run create-admin

# Or directly
node create_admin_user.js
```

The script will prompt you for:
- Admin email address
- Password (hidden input)
- Display name (optional)

### Method 2: Environment Variables (More Secure)
```bash
# Set environment variables
export ADMIN_EMAIL="your-admin@email.com"
export ADMIN_PASSWORD="your-secure-password"
export ADMIN_NAME="Admin User"

# Run the script
node create_admin_user.js
```

## What the Script Does

1. **Initializes Firebase Admin SDK** with your service account
2. **Validates input** (email format, password strength)
3. **Checks for existing users** to prevent duplicates
4. **Creates Firebase Auth user** with the provided credentials
5. **Sets custom claims** (`admin: true`, `role: "admin"`)
6. **Creates Firestore document** in `users` collection
7. **Verifies the setup** was successful

## Security Features

✅ **No hardcoded passwords** - prompts for secure input  
✅ **Hidden password input** - passwords are masked during entry  
✅ **Input validation** - checks email format and password strength  
✅ **Error handling** - provides clear error messages and solutions  
✅ **Duplicate prevention** - checks for existing users  
✅ **Verification** - confirms admin privileges were set correctly  

## Output Example

```
🔐 Firebase Admin User Creation Tool
=====================================

Enter admin email: admin@gizmostore.com
Enter admin password: ********
Enter display name (optional): Store Administrator

🔄 Creating user account...
✅ User created successfully: admin@gizmostore.com
   UID: abc123def456ghi789
✅ Admin privileges assigned to admin@gizmostore.com
✅ User document created in Firestore

🎉 Admin user setup completed successfully!

User can now login with:
   Email: admin@gizmostore.com
   Role: admin
   Custom Claims: { admin: true, role: "admin" }
```

## Firestore Security Rules

Ensure your Firestore rules check for admin claims:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check admin status
    function isAdmin() {
      return request.auth != null && 
             request.auth.token.admin == true;
    }
    
    // Admin-only collections
    match /users/{userId} {
      allow read, write: if isAdmin();
    }
    
    match /products/{productId} {
      allow read: if true; // Public read
      allow write: if isAdmin(); // Admin write only
    }
  }
}
```

## Troubleshooting

### Common Issues:

1. **"Service account key not found"**
   - Ensure `gizmostore-2a3ff-firebase-adminsdk.json` is in the scripts directory
   - Check the file path in the script

2. **"Permission denied"**
   - Verify your service account has the necessary permissions
   - Check that Firebase Authentication is enabled in your project

3. **"Email already exists"**
   - The script will offer to update the existing user to admin
   - Or use a different email address

4. **"Weak password"**
   - Use a password with at least 6 characters
   - Include a mix of letters, numbers, and symbols

### Verification

To verify the admin user was created correctly:

```bash
# Check Firebase Console → Authentication → Users
# Look for your admin email with custom claims

# Or use the verification script
node verify_admin_user.js
```

## Security Best Practices

1. **Never commit service account keys** to version control
2. **Use environment variables** for sensitive data in production
3. **Rotate service account keys** regularly
4. **Limit service account permissions** to only what's needed
5. **Use strong passwords** for admin accounts
6. **Enable 2FA** when possible

## Production Considerations

For production environments:
- Use Firebase Admin SDK in a secure server environment
- Implement proper user registration flows
- Use Firebase Auth triggers for automatic role assignment
- Consider using Firebase Functions for user management
- Implement audit logging for admin actions

## Support

If you encounter issues:
1. Check the Firebase Console for error details
2. Verify your service account permissions
3. Ensure Firebase Authentication is properly configured
4. Review the Firestore security rules

This tool provides a secure foundation for admin user management in your Firebase project.
