# 🚀 دليل التشغيل السريع - Gizmo Store

## للتطوير السريع (الأسرع)
```bash
flutter run -d windows
```

## للويب مع تحسينات
```bash
flutter run -d chrome --web-renderer=html --web-port=8080
```

## للويب على Edge (أحياناً أسرع)
```bash
flutter run -d edge --web-renderer=html
```

## نصائح لتسريع التطوير

### 1. استخدام Hot Reload
- بعد التشغيل الأول، استخدم `r` للـ Hot Reload
- استخدم `R` للـ Hot Restart
- لا تغلق التطبيق، فقط احفظ الملفات

### 2. تحسين VS Code
- استخدم `Ctrl+F5` للتشغيل السريع
- فعّل Auto Save في VS Code
- استخدم Flutter Inspector للتصحيح

### 3. تقليل الاستيرادات
- تجنب استيراد مكتبات كبيرة في البداية
- استخدم lazy loading للصور
- قلل من استخدام Firebase في التطوير

### 4. استخدام المحاكي
```bash
# لعرض المحاكيات المتاحة
flutter emulators

# لتشغيل محاكي Android
flutter emulators --launch <emulator_id>
```

## أوامر مفيدة

```bash
# تنظيف سريع
flutter clean && flutter pub get

# تشغيل مع تصحيح الأخطاء
flutter run --debug

# تشغيل بدون تصحيح (أسرع)
flutter run --release
```

## إعدادات VS Code المحسنة

في `.vscode/settings.json`:
```json
{
    "dart.flutterHotReloadOnSave": "always",
    "dart.previewFlutterUiGuides": true,
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000
}
```
