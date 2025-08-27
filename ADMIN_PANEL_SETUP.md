# Gizmo Store Admin Panel Setup Guide

## Overview
This guide will help you set up the Flutter Web Admin Panel for your Gizmo Store mobile app.

## Prerequisites
- Flutter SDK (latest stable version)
- Firebase project (same as your mobile app)
- Web browser for testing

## Setup Instructions

### 1. Firebase Configuration

#### A. Enable Web Platform
1. Go to your Firebase Console
2. Select your Gizmo Store project
3. Click on "Project Settings" (gear icon)
4. Scroll down to "Your apps" section
5. Click "Add app" and select Web (</>) icon
6. Register your web app with nickname "Gizmo Store Admin"
7. Copy the Firebase configuration

#### B. Update Firebase Options
1. Replace the placeholder values in `admin_panel/lib/firebase_options.dart` with your actual Firebase config:
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-web-api-key',
  appId: 'your-web-app-id',
  messagingSenderId: 'your-messaging-sender-id',
  projectId: 'your-project-id',
  authDomain: 'your-project-id.firebaseapp.com',
  storageBucket: 'your-project-id.appspot.com',
  measurementId: 'your-measurement-id',
);
```

### 2. Firestore Database Structure

#### A. Collections Structure
Create these collections in your Firestore database:

```
/users/{userId}
  - email: string
  - name: string
  - role: string ("admin" | "user")
  - isAdmin: boolean
  - isBlocked: boolean
  - createdAt: timestamp
  - lastLogin: timestamp

/products/{productId}
  - name: string
  - description: string
  - price: number
  - originalPrice: number (optional)
  - image: string (URL)
  - images: array of strings (URLs)
  - category: string
  - featured: boolean
  - isAvailable: boolean
  - stock: number
  - rating: number
  - reviewsCount: number
  - createdAt: timestamp
  - updatedAt: timestamp

/categories/{categoryId}
  - name: string
  - imageUrl: string
  - order: number
  - isActive: boolean

/orders/{orderId}
  - userId: string
  - userEmail: string
  - userName: string
  - items: array of objects
    - productId: string
    - productName: string
    - productImage: string
    - price: number
    - quantity: number
  - total: number
  - status: string ("pending" | "shipped" | "delivered" | "canceled")
  - shippingAddress: string
  - phoneNumber: string
  - createdAt: timestamp
  - updatedAt: timestamp
```

#### B. Sample Categories Data
Add these sample categories to your Firestore:

```javascript
// Collection: categories
{
  name: "هواتف ذكية",
  imageUrl: "https://via.placeholder.com/300x300?text=Smartphones",
  order: 1,
  isActive: true
}

{
  name: "لابتوبات",
  imageUrl: "https://via.placeholder.com/300x300?text=Laptops",
  order: 2,
  isActive: true
}

{
  name: "سماعات",
  imageUrl: "https://via.placeholder.com/300x300?text=Headphones",
  order: 3,
  isActive: true
}

{
  name: "ساعات ذكية",
  imageUrl: "https://via.placeholder.com/300x300?text=Smartwatches",
  order: 4,
  isActive: true
}

{
  name: "أجهزة لوحية",
  imageUrl: "https://via.placeholder.com/300x300?text=Tablets",
  order: 5,
  isActive: true
}

{
  name: "إكسسوارات",
  imageUrl: "https://via.placeholder.com/300x300?text=Accessories",
  order: 6,
  isActive: true
}
```

### 3. Firestore Security Rules

Update your Firestore rules to allow admin access:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == userId || isAdmin());
    }
    
    // Products collection
    match /products/{productId} {
      allow read: if true; // Public read access
      allow write: if request.auth != null && isAdmin();
    }
    
    // Categories collection
    match /categories/{categoryId} {
      allow read: if true; // Public read access
      allow write: if request.auth != null && isAdmin();
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if request.auth != null && 
        (resource.data.userId == request.auth.uid || isAdmin());
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
      allow update: if request.auth != null && isAdmin();
    }
    
    // Helper function to check admin status
    function isAdmin() {
      return exists(/databases/$(database)/documents/users/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

### 4. Create Admin User

1. Create a user account in Firebase Authentication
2. Add the user to Firestore users collection with admin role:

```javascript
// Document ID: {userId from Firebase Auth}
{
  email: "admin@gizmostore.com",
  name: "Admin User",
  role: "admin",
  isAdmin: true,
  isBlocked: false,
  createdAt: new Date(),
  lastLogin: new Date()
}
```

### 5. Run the Admin Panel

1. Navigate to the admin_panel directory:
```bash
cd admin_panel
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the web app:
```bash
flutter run -d chrome
```

### 6. Mobile App Updates

Update your mobile app's pubspec.yaml to include the cached_network_image package:

```yaml
dependencies:
  cached_network_image: ^3.4.1
```

Then run:
```bash
flutter pub get
```

## Features

### Admin Panel Features:
- ✅ Dashboard with statistics
- ✅ User authentication with admin role checking
- ✅ Responsive design for desktop and tablet
- ✅ Modern, clean interface
- 🔄 Products management (coming soon)
- 🔄 Orders management (coming soon)
- 🔄 Users management (coming soon)

### Mobile App Improvements:
- ✅ Dynamic categories loading from Firebase
- ✅ Enhanced category UI with larger images
- ✅ Network image caching
- ✅ Password visibility toggle in login
- ✅ Improved error handling and loading states

## Troubleshooting

### Common Issues:

1. **Firebase connection issues**: Ensure your firebase_options.dart has correct configuration
2. **Admin access denied**: Verify the user has role: "admin" in Firestore
3. **Categories not loading**: Check Firestore rules and internet connection
4. **Images not displaying**: Verify image URLs are accessible

### Support
For additional support, check the Firebase documentation or Flutter web documentation.
