# Setup Cloudinary as Firebase Storage Alternative

Write-Host "Setting up Cloudinary as Firebase Storage Alternative..." -ForegroundColor Green
Write-Host ""

# Step 1: Add Cloudinary dependency
Write-Host "Step 1: Adding Cloudinary dependency..." -ForegroundColor Yellow

if (Test-Path "pubspec.yaml") {
    Write-Host "Found pubspec.yaml" -ForegroundColor Green
    
    $content = Get-Content "pubspec.yaml" -Raw
    
    if ($content -notmatch "cloudinary_public:") {
        Write-Host "Adding cloudinary_public to pubspec.yaml..." -ForegroundColor Cyan
        
        $newContent = $content -replace "(dependencies:)", "`$1`n  cloudinary_public: ^0.21.0"
        $newContent | Set-Content "pubspec.yaml" -Encoding UTF8
        
        Write-Host "Added cloudinary_public successfully!" -ForegroundColor Green
    }
    else {
        Write-Host "cloudinary_public already exists" -ForegroundColor Green
    }
}
else {
    Write-Host "Error: pubspec.yaml not found" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Run flutter pub get
Write-Host "Step 2: Running flutter pub get..." -ForegroundColor Yellow
flutter pub get
Write-Host "Dependencies updated!" -ForegroundColor Green

Write-Host ""

# Step 3: Create services directory
Write-Host "Step 3: Creating services directory..." -ForegroundColor Yellow
if (!(Test-Path "lib\services")) {
    New-Item -ItemType Directory -Path "lib\services" -Force | Out-Null
    Write-Host "Created lib/services directory" -ForegroundColor Green
}
else {
    Write-Host "lib/services directory already exists" -ForegroundColor Green
}

Write-Host ""

# Step 4: Create Cloudinary service
Write-Host "Step 4: Creating Cloudinary service..." -ForegroundColor Yellow

$cloudinaryCode = @'
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String uploadPreset = 'YOUR_UPLOAD_PRESET';
  
  static final CloudinaryPublic cloudinary = CloudinaryPublic(
    cloudName,
    uploadPreset,
  );
  
  static Future<String> uploadImage(File imageFile, {String? folder}) async {
    try {
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          folder: folder ?? 'gizmo_store/products',
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
  
  static Future<List<String>> uploadMultipleImages(
    List<File> imageFiles, {
    String? folder,
  }) async {
    List<String> urls = [];
    
    for (File imageFile in imageFiles) {
      try {
        String url = await uploadImage(imageFile, folder: folder);
        urls.add(url);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    
    return urls;
  }
}
'@

$cloudinaryCode | Set-Content "lib\services\cloudinary_service.dart" -Encoding UTF8
Write-Host "Created cloudinary_service.dart" -ForegroundColor Green

Write-Host ""

# Step 5: Create image upload service
Write-Host "Step 5: Creating image upload service..." -ForegroundColor Yellow

$uploadCode = @'
import 'dart:io';
import 'cloudinary_service.dart';

class ImageUploadService {
  static Future<List<String>> uploadProductImages(List<File> images) async {
    return await CloudinaryService.uploadMultipleImages(
      images,
      folder: 'gizmo_store/products',
    );
  }
  
  static Future<String> uploadCategoryImage(File image) async {
    return await CloudinaryService.uploadImage(
      image,
      folder: 'gizmo_store/categories',
    );
  }
  
  static Future<String> uploadProfileImage(File image, String userId) async {
    return await CloudinaryService.uploadImage(
      image,
      folder: 'gizmo_store/profiles/$userId',
    );
  }
}
'@

$uploadCode | Set-Content "lib\services\image_upload_service.dart" -Encoding UTF8
Write-Host "Created image_upload_service.dart" -ForegroundColor Green

Write-Host ""
Write-Host "Setup completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Read storage_alternatives_guide.md" -ForegroundColor White
Write-Host "2. Register at: https://cloudinary.com/users/register_free" -ForegroundColor White
Write-Host "3. Get your Cloud Name and Upload Preset" -ForegroundColor White
Write-Host "4. Update lib/services/cloudinary_service.dart" -ForegroundColor White
Write-Host "5. Start using the service in your app" -ForegroundColor White
Write-Host ""
Write-Host "Cloudinary is ready as an excellent Firebase Storage alternative!" -ForegroundColor Green