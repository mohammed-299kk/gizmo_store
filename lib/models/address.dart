import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class Address {
  final String? id;
  final String name;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    this.id,
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create Address from Firestore document
  factory Address.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Address(
      id: documentId,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      street: data['street'] ?? '',
      city: data['city'] ?? '',
      state: data['state'] ?? '',
      postalCode: data['postalCode'] ?? '',
      country: data['country'] ?? '',
      isDefault: data['isDefault'] ?? false,
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt']?.toDate() ?? DateTime.now(),
    );
  }

  // Convert Address to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'isDefault': isDefault,
      'createdAt': createdAt,
      'updatedAt': DateTime.now(),
    };
  }

  // Create a copy of Address with updated fields
  Address copyWith({
    String? id,
    String? name,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get formatted address string
  String get formattedAddress {
    return '$street, $city, $state $postalCode, $country';
  }

  // Validation methods
  static String? validateName(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationNameRequired;
    }
    if (value.trim().length < 2) {
      return localizations.validationNameTooShort;
    }
    return null;
  }

  static String? validatePhone(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationPhoneRequired;
    }
    // Saudi phone number validation
    final phoneRegex = RegExp(r'^(\+966|966|0)?[5][0-9]{8}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', '').replaceAll('-', ''))) {
      return localizations.validationPhoneInvalid;
    }
    return null;
  }

  static String? validateStreet(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationStreetRequired;
    }
    if (value.trim().length < 5) {
      return localizations.validationStreetTooShort;
    }
    return null;
  }

  static String? validateCity(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationCityRequired;
    }
    if (value.trim().length < 2) {
      return localizations.validationCityTooShort;
    }
    return null;
  }

  static String? validateState(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationStateRequired;
    }
    return null;
  }

  static String? validatePostalCode(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationPostalCodeRequired;
    }
    // Saudi postal code validation (5 digits)
    final postalRegex = RegExp(r'^[0-9]{5}$');
    if (!postalRegex.hasMatch(value.trim())) {
      return localizations.validationPostalCodeInvalid;
    }
    return null;
  }

  static String? validateCountry(String? value, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return localizations.validationCountryRequired;
    }
    return null;
  }

  @override
  String toString() {
    return 'Address(id: $id, name: $name, phone: $phone, formattedAddress: $formattedAddress, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address &&
        other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.street == street &&
        other.city == city &&
        other.state == state &&
        other.postalCode == postalCode &&
        other.country == country &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      phone,
      street,
      city,
      state,
      postalCode,
      country,
      isDefault,
    );
  }
}
