# Setup Cloudinary as Firebase Storage Alternative
# This script sets up Cloudinary as a quick alternative to Firebase Storage

Write-Host "=== إعداد Cloudinary كبديل لـ Firebase Storage ===" -ForegroundColor Green
Write-Host ""

# Step 1: Add Cloudinary dependency
Write-Host "الخطوة 1: إضافة مكتبة Cloudinary..." -ForegroundColor Yellow

# Check if pubspec.yaml exists
if (Test-Path "pubspec.yaml") {
    Write-Host "تم العثور على pubspec.yaml" -ForegroundColor Green
    
    # Read current pubspec.yaml
    $pubspecContent = Get-Content "pubspec.yaml" -Raw
    
    # Check if cloudinary_public already exists
    if ($pubspecContent -notmatch "cloudinary_public:") {
        Write-Host "إضافة cloudinary_public إلى pubspec.yaml..." -ForegroundColor Cyan
        
        # Add cloudinary_public dependency
        $newDependency = "  cloudinary_public: ^0.21.0"
        
        # Find dependencies section and add the new dependency
        $lines = $pubspecContent -split "`n"
        $newLines = @()
        $dependenciesFound = $false
        
        foreach ($line in $lines) {
            $newLines += $line
            if ($line -match "^dependencies:") {
                $dependenciesFound = $true
                $newLines += $newDependency
            }
        }
        
        if ($dependenciesFound) {
            $newLines -join "`n" | Set-Content "pubspec.yaml"
            Write-Host "تم إضافة cloudinary_public بنجاح!" -ForegroundColor Green
        } else {
            Write-Host "لم يتم العثور على قسم dependencies في pubspec.yaml" -ForegroundColor Red
        }
    } else {
        Write-Host "cloudinary_public موجود بالفعل في pubspec.yaml" -ForegroundColor Green
    }
} else {
    Write-Host "خطأ: لم يتم العثور على pubspec.yaml" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Step 2: Run flutter pub get
Write-Host "الخطوة 2: تحديث المكتبات..." -ForegroundColor Yellow
try {
    flutter pub get
    Write-Host "تم تحديث المكتبات بنجاح!" -ForegroundColor Green
} catch {
    Write-Host "خطأ في تحديث المكتبات: $_" -ForegroundColor Red
}

Write-Host ""

# Step 3: Create services directory
Write-Host "الخطوة 3: إنشاء مجلد الخدمات..." -ForegroundColor Yellow
if (!(Test-Path "lib\services")) {
    New-Item -ItemType Directory -Path "lib\services" -Force
    Write-Host "تم إنشاء مجلد lib/services" -ForegroundColor Green
} else {
    Write-Host "مجلد lib/services موجود بالفعل" -ForegroundColor Green
}

Write-Host ""

# Step 4: Create Cloudinary service file
Write-Host "الخطوة 4: إنشاء خدمة Cloudinary..." -ForegroundColor Yellow

# Create the Cloudinary service content as separate file
$cloudinaryContent = @"
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  // TODO: Replace with your Cloudinary credentials
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String uploadPreset = 'YOUR_UPLOAD_PRESET';
  
  static final CloudinaryPublic cloudinary = CloudinaryPublic(
    cloudName,
    uploadPreset,
  );
  
  /// Upload a single image to Cloudinary
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
      throw Exception('Failed to upload image: `$e');
    }
  }
  
  /// Upload multiple images to Cloudinary
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
        print('Error uploading image `${imageFile.path}: `$e');
        // Continue with other images even if one fails
      }
    }
    
    return urls;
  }
  
  /// Delete an image from Cloudinary
  static Future<bool> deleteImage(String publicId) async {
    try {
      await cloudinary.destroy(publicId);
      return true;
    } catch (e) {
      print('Error deleting image: `$e');
      return false;
    }
  }
}
"@

$cloudinaryContent | Set-Content "lib\services\cloudinary_service.dart" -Encoding UTF8
Write-Host "تم إنشاء lib/services/cloudinary_service.dart" -ForegroundColor Green

Write-Host ""

# Step 5: Create image upload service
Write-Host "الخطوة 5: إنشاء خدمة رفع الصور..." -ForegroundColor Yellow

$imageUploadContent = @"
import 'dart:io';
import 'cloudinary_service.dart';

class ImageUploadService {
  /// Upload product images
  static Future<List<String>> uploadProductImages(List<File> images) async {
    try {
      return await CloudinaryService.uploadMultipleImages(
        images,
        folder: 'gizmo_store/products',
      );
    } catch (e) {
      throw Exception('Failed to upload product images: `$e');
    }
  }
  
  /// Upload category images
  static Future<String> uploadCategoryImage(File image) async {
    try {
      return await CloudinaryService.uploadImage(
        image,
        folder: 'gizmo_store/categories',
      );
    } catch (e) {
      throw Exception('Failed to upload category image: `$e');
    }
  }
  
  /// Upload user profile image
  static Future<String> uploadProfileImage(File image, String userId) async {
    try {
      return await CloudinaryService.uploadImage(
        image,
        folder: 'gizmo_store/profiles/`$userId',
      );
    } catch (e) {
      throw Exception('Failed to upload profile image: `$e');
    }
  }
}
"@

$imageUploadContent | Set-Content "lib\services\image_upload_service.dart" -Encoding UTF8
Write-Host "تم إنشاء lib/services/image_upload_service.dart" -ForegroundColor Green

Write-Host ""
Write-Host "=== تم الإعداد بنجاح! ===" -ForegroundColor Green
Write-Host ""
Write-Host "الخطوات التالية:" -ForegroundColor Yellow
Write-Host "1. اقرأ ملف storage_alternatives_guide.md" -ForegroundColor White
Write-Host "2. سجل حساب في Cloudinary (https://cloudinary.com/users/register_free)" -ForegroundColor White
Write-Host "3. احصل على Cloud Name و Upload Preset" -ForegroundColor White
Write-Host "4. حدث lib/services/cloudinary_service.dart" -ForegroundColor White
Write-Host "5. ابدأ استخدام الخدمة في تطبيقك" -ForegroundColor White
Write-Host ""
Write-Host "Cloudinary جاهز كبديل ممتاز لـ Firebase Storage!" -ForegroundColor Green