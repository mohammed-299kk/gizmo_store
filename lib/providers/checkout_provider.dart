
import 'package:flutter/material.dart';

class CheckoutProvider with ChangeNotifier {
  String? _selectedAddress;
  String? _selectedShippingMethod;
  String? _selectedPaymentMethod;

  String? get selectedAddress => _selectedAddress;
  String? get selectedShippingMethod => _selectedShippingMethod;
  String? get selectedPaymentMethod => _selectedPaymentMethod;

  void selectAddress(String address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void selectShippingMethod(String method) {
    _selectedShippingMethod = method;
    notifyListeners();
  }

  void selectPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }
}
