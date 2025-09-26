import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // تحديث أسعار المنتجات لتكون أسعار حقيقية
  final firestore = FirebaseFirestore.instance;
  
  // أسعار حقيقية للمنتجات
  final Map<String, Map<String, dynamic>> realPrices = {
    'iphone-15-pro': {
      'price': 1199.99,
      'originalPrice': 1299.99,
      'discount': 8,
    },
    'samsung-galaxy-s24': {
      'price': 899.99,
      'originalPrice': 999.99,
      'discount': 10,
    },
    'macbook-pro-m3': {
      'price': 1999.99,
      'originalPrice': 2199.99,
      'discount': 9,
    },
    'ipad-air': {
      'price': 599.99,
      'originalPrice': 649.99,
      'discount': 8,
    },
    'airpods-pro': {
      'price': 249.99,
      'originalPrice': 279.99,
      'discount': 11,
    },
    'apple-watch-series-9': {
      'price': 399.99,
      'originalPrice': 429.99,
      'discount': 7,
    },
    'hp-spectre-x360': {
      'price': 1299.99,
      'originalPrice': 1399.99,
      'discount': 7,
    },
    'dell-xps-13': {
      'price': 1099.99,
      'originalPrice': 1199.99,
      'discount': 8,
    },
    'sony-wh-1000xm5': {
      'price': 349.99,
      'originalPrice': 399.99,
      'discount': 13,
    },
    'nintendo-switch': {
      'price': 299.99,
      'originalPrice': 329.99,
      'discount': 9,
    },
  };

  try {
    // الحصول على جميع المنتجات
    final productsSnapshot = await firestore.collection('products').get();
    
    for (final doc in productsSnapshot.docs) {
      final productId = doc.id;
      final productData = doc.data();
      
      // البحث عن السعر الحقيقي للمنتج
      String? matchingKey;
      for (final key in realPrices.keys) {
        if (productId.toLowerCase().contains(key.toLowerCase()) ||
            productData['name']?.toString().toLowerCase().contains(key.toLowerCase()) == true) {
          matchingKey = key;
          break;
        }
      }
      
      if (matchingKey != null) {
        final priceData = realPrices[matchingKey]!;
        
        // تحديث السعر
        await doc.reference.update({
          'price': priceData['price'],
          'originalPrice': priceData['originalPrice'],
          'discount': priceData['discount'],
        });
        
        print('تم تحديث سعر المنتج: ${productData['name']} - السعر الجديد: \$${priceData['price']}');
      } else {
        // إذا لم نجد سعر محدد، نضع سعر افتراضي معقول
        final currentPrice = productData['price'] ?? 0;
        double newPrice;
        
        if (currentPrice < 50) {
          newPrice = 199.99; // للإكسسوارات الصغيرة
        } else if (currentPrice < 200) {
          newPrice = 399.99; // للأجهزة المتوسطة
        } else if (currentPrice < 500) {
          newPrice = 799.99; // للأجهزة الكبيرة
        } else {
          newPrice = 1299.99; // للأجهزة المتقدمة
        }
        
        await doc.reference.update({
          'price': newPrice,
          'originalPrice': newPrice + (newPrice * 0.1),
          'discount': 10,
        });
        
        print('تم تحديث سعر المنتج: ${productData['name']} - السعر الجديد: \$${newPrice}');
      }
    }
    
    print('تم تحديث جميع أسعار المنتجات بنجاح!');
  } catch (e) {
    print('خطأ في تحديث الأسعار: $e');
  }
}