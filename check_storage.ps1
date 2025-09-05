# سكريبت PowerShell لفحص حالة Firebase Storage

Write-Host "🔍 فحص حالة Firebase Storage..." -ForegroundColor Cyan
Write-Host "" 

# التحقق من وجود Dart
try {
    $dartVersion = dart --version 2>&1
    Write-Host "✅ Dart متوفر: $dartVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Dart غير متوفر. تأكد من تثبيت Flutter SDK" -ForegroundColor Red
    exit 1
}

# التحقق من وجود ملف الفحص
if (-not (Test-Path "check_firebase_storage.dart")) {
    Write-Host "❌ ملف الفحص غير موجود" -ForegroundColor Red
    exit 1
}

# تشغيل فحص Firebase Storage
Write-Host "🚀 تشغيل فحص Firebase Storage..." -ForegroundColor Yellow
Write-Host "" 

try {
    # تشغيل السكريبت
    dart run check_firebase_storage.dart
    
    Write-Host "" 
    Write-Host "✅ اكتمل الفحص بنجاح" -ForegroundColor Green
    
} catch {
    Write-Host "" 
    Write-Host "❌ فشل في تشغيل الفحص: $_" -ForegroundColor Red
    
    Write-Host "" 
    Write-Host "💡 نصائح لحل المشكلة:" -ForegroundColor Yellow
    Write-Host "1. تأكد من إعداد Firebase Storage في وحة التحكم" -ForegroundColor White
    Write-Host "2. تحقق من اتصال الإنترنت" -ForegroundColor White
    Write-Host "3. تأكد من صحة إعدادات Firebase" -ForegroundColor White
}

Write-Host "" 
Write-Host "📋 للمزيد من المعلومات، راجع: FIREBASE_STORAGE_SETUP.md" -ForegroundColor Cyan
Write-Host "" 

# انتظار ضغطة مفتاح قبل الإغلاق
Write-Host "اضغط أي مفتاح للمتابعة..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")