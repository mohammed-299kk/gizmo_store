// lib/utils/formatters.dart
import 'package:intl/intl.dart';

class Formatters {
  // تنسيق السعر مع فواصل الآلاف
  static String formatPrice(double price) {
    // تحويل السعر إلى string بدون أرقام عشرية
    String priceStr = price.toStringAsFixed(0);

    // إضافة فواصل الآلاف
    String formattedInteger = '';
    for (int i = 0; i < priceStr.length; i++) {
      if (i > 0 && (priceStr.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += priceStr[i];
    }

    return formattedInteger;
  }

  // تنسيق العملة بالدولار
  static String currency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(amount);
  }

  // تنسيق التاريخ بالشكل yyyy-MM-dd
  static String date(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  // تنسيق الوقت بالشكل HH:mm
  static String time(DateTime date) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  // تنسيق التاريخ والوقت بالشكل yyyy-MM-dd HH:mm
  static String dateTime(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(date);
  }
}
