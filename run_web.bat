@echo off
echo جاري تشغيل Gizmo Store على Chrome...
echo.

REM تنظيف الكاش السريع
flutter clean > nul 2>&1

REM تحديث التبعيات
flutter pub get

REM تشغيل التطبيق مع إعدادات محسنة
flutter run -d chrome --web-port=8080 --web-renderer=html --dart-define=FLUTTER_WEB_USE_SKIA=false

pause
