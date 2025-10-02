import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// مساعد لمعالجة الصور وتحسين عرضها
class ImageHelper {
  /// فك ترميز روابط Noon التي تحتوي على معلمات مشفرة
  static String decodeNoonUrl(String encodedUrl) {
    try {
      final uri = Uri.parse(encodedUrl);
      final queryParams = uri.queryParameters;
      final imageUrl = queryParams['url'];
      return imageUrl != null ? Uri.decodeFull(imageUrl) : encodedUrl;
    } catch (e) {
      // في حالة فشل فك الترميز، إرجاع الرابط الأصلي
      return encodedUrl;
    }
  }

  /// معالجة رابط الصورة بناءً على مصدرها
  static String processImageUrl(String imageUrl) {
    if (imageUrl.contains('noon.com')) {
      return decodeNoonUrl(imageUrl);
    }
    return imageUrl;
  }

  /// إنشاء CachedNetworkImage محسن مع معالجة الأخطاء
  static Widget buildCachedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget Function(BuildContext, String)? placeholder,
    Widget Function(BuildContext, String, dynamic)? errorWidget,
    Map<String, String>? httpHeaders,
  }) {
    final processedUrl = processImageUrl(imageUrl);
    
    return CachedNetworkImage(
      imageUrl: processedUrl,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: httpHeaders ?? {
        "Accept": "*/*",
        "User-Agent": "Gizmo-Store/1.0",
        "Accept-Encoding": "gzip, deflate, br",
        "Cache-Control": "no-cache",
      },
      placeholder: placeholder ?? 
        (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ),
      errorWidget: errorWidget ?? 
        (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.broken_image,
                color: Colors.grey[600],
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'فشل تحميل الصورة',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );
  }

  /// إنشاء صورة مع تأثير FadeIn
  static Widget buildFadeInImage({
    required String imageUrl,
    required String placeholderAsset,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final processedUrl = processImageUrl(imageUrl);
    
    return FadeInImage(
      placeholder: AssetImage(placeholderAsset),
      image: CachedNetworkImageProvider(
        processedUrl,
        headers: {
          "Accept": "*/*",
          "User-Agent": "Gizmo-Store/1.0",
        },
      ),
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 300),
      imageErrorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(
            Icons.broken_image,
            color: Colors.grey,
            size: 40,
          ),
        );
      },
    );
  }

  /// التحقق من صحة رابط الصورة
  static bool isValidImageUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && 
             (uri.scheme == 'http' || uri.scheme == 'https') &&
             uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  /// الحصول على رؤوس HTTP افتراضية محسنة
  static Map<String, String> getDefaultHeaders() {
    return {
      "Accept": "*/*",
      "User-Agent": "Gizmo-Store/1.0",
      "Accept-Encoding": "gzip, deflate, br",
      "Cache-Control": "no-cache",
      "Pragma": "no-cache",
    };
  }
}