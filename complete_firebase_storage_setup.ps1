# Complete Firebase Storage Setup Script
# This script will guide you through the final setup steps

Write-Host "=== Firebase Storage Setup - Final Steps ===" -ForegroundColor Green
Write-Host ""

# Step 1: Open Firebase Console
Write-Host "Step 1: Opening Firebase Storage Console..." -ForegroundColor Yellow
Start-Process "https://console.firebase.google.com/project/gizmostore-2a3ff/storage"
Write-Host "Firebase Console opened in your default browser." -ForegroundColor Green
Write-Host ""

# Step 2: Login Instructions
Write-Host "Step 2: Login to Firebase Console" -ForegroundColor Yellow
Write-Host "Email: chatgpt0242@gmail.com" -ForegroundColor Cyan
Write-Host "Password: Chat-GPT-0242" -ForegroundColor Cyan
Write-Host ""

# Step 3: Setup Instructions
Write-Host "Step 3: Complete Firebase Storage Setup" -ForegroundColor Yellow
Write-Host "1. Click Get Started" -ForegroundColor White
Write-Host "2. Choose Start in test mode" -ForegroundColor White
Write-Host "3. Select location: us-central1" -ForegroundColor White
Write-Host "4. Click Done" -ForegroundColor White
Write-Host ""

# Wait for user confirmation
Write-Host "Press any key after completing the setup in the browser..." -ForegroundColor Magenta
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Step 4: Deploy Storage Rules
Write-Host ""
Write-Host "Step 4: Deploying Firebase Storage Rules..." -ForegroundColor Yellow
try {
    firebase deploy --only storage
    Write-Host "Storage rules deployed successfully!" -ForegroundColor Green
} catch {
    Write-Host "Error deploying storage rules" -ForegroundColor Red
    Write-Host "Please try running: firebase deploy --only storage" -ForegroundColor Yellow
}

# Step 5: Test Storage Connection
Write-Host ""
Write-Host "Step 5: Testing Firebase Storage Connection..." -ForegroundColor Yellow
if (Test-Path "check_firebase_storage.dart") {
    try {
        dart run check_firebase_storage.dart
        Write-Host "Storage connection test completed!" -ForegroundColor Green
    } catch {
        Write-Host "Error running storage test" -ForegroundColor Red
        Write-Host "Please run: dart run check_firebase_storage.dart" -ForegroundColor Yellow
    }
} else {
    Write-Host "Storage test file not found. Skipping test." -ForegroundColor Yellow
}

# Final Summary
Write-Host ""
Write-Host "=== Setup Complete! ===" -ForegroundColor Green
Write-Host "Firebase Storage should now be ready for use." -ForegroundColor White
Write-Host "You can now test image uploads in your Flutter app." -ForegroundColor White
Write-Host ""
Write-Host "If you encounter any issues, check the troubleshooting guide:" -ForegroundColor Yellow
Write-Host "firebase_storage_troubleshooting.md" -ForegroundColor Cyan

Pause