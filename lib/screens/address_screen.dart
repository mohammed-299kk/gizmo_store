
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'address_management_screen.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate directly to AddressManagementScreen which has full functionality
    return const AddressManagementScreen();
  }
}
