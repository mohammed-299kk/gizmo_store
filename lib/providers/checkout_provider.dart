
import 'package:flutter/material.dart';

class CheckoutProvider with ChangeNotifier {
  String? _selectedAddress;
  String? _selectedShippingMethod;

  String? get selectedAddress => _selectedAddress;
  String? get selectedShippingMethod => _selectedShippingMethod;

  void selectAddress(String address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void selectShippingMethod(String method) {
    _selectedShippingMethod = method;
    notifyListeners();
  }
}
