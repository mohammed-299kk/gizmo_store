# Firebase Storage Setup and Fix Script
# This script helps resolve Firebase Storage setup issues

Write-Host "=== Firebase Storage Setup and Fix Script ===" -ForegroundColor Green
Write-Host ""

# Step 1: Re-authenticate Firebase CLI
Write-Host "Step 1: Re-authenticating Firebase CLI..." -ForegroundColor Yellow
firebase logout
firebase login --reauth

# Step 2: Set project
Write-Host "Step 2: Setting Firebase project..." -ForegroundColor Yellow
$projectId = "gizmostore-2a3ff"
firebase use $projectId

# Step 3: Open Firebase Console for manual setup
Write-Host "Step 3: Opening Firebase Console for manual setup..." -ForegroundColor Yellow
$storageConsoleUrl = "https://console.firebase.google.com/project/$projectId/storage"
Write-Host "Opening: $storageConsoleUrl" -ForegroundColor Cyan
Start-Process $storageConsoleUrl

Write-Host ""
Write-Host "MANUAL SETUP REQUIRED:" -ForegroundColor Red
Write-Host "1. Click 'Get Started' in Firebase Storage"
Write-Host "2. Select 'Start in test mode' for rules"
Write-Host "3. Choose 'us-central1' as location"
Write-Host "4. Click 'Done'"
Write-Host ""

# Wait for user confirmation
Read-Host "Press Enter after completing the manual setup in Firebase Console"

# Step 4: Deploy storage rules
Write-Host "Step 4: Deploying Firebase Storage rules..." -ForegroundColor Yellow
firebase deploy --only storage

# Step 5: Run diagnostic tool
Write-Host "Step 5: Running diagnostic tool..." -ForegroundColor Yellow
dart run check_firebase_storage.dart

Write-Host ""
Write-Host "=== SETUP COMPLETE ===" -ForegroundColor Green
Write-Host "Files created:"
Write-Host "  - FIREBASE_STORAGE_SETUP.md (Setup Guide)"
Write-Host "  - FIREBASE_STORAGE_ERROR_SOLUTIONS.md (Error Solutions)"
Write-Host "  - check_firebase_storage.dart (Diagnostic Tool)"
Write-Host "  - check_storage.ps1 (Automation Script)"
Write-Host "  - fix_firebase_storage.ps1 (This Script)"
Write-Host ""
Write-Host "Next Steps:"
Write-Host "1. Test image upload in your Flutter app"
Write-Host "2. Check Firebase Console for uploaded images"
Write-Host "3. Update security rules for production"
Write-Host ""
Write-Host "If issues persist:"
Write-Host "  - Check Firebase status: https://status.firebase.google.com"
Write-Host "  - Review error logs in Firebase Console"
Write-Host "  - Contact Firebase Support if needed"
Write-Host ""
