
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.shipping),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.standardShipping),
            subtitle: Text(AppLocalizations.of(context)!.standardShippingDesc),
            trailing: Radio(value: 'standard', groupValue: 'shipping', onChanged: (value) {}),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.expressShipping),
            subtitle: Text(AppLocalizations.of(context)!.expressShippingDesc),
            trailing: Radio(value: 'express', groupValue: 'shipping', onChanged: (value) {}),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.sameDayShipping),
            subtitle: Text(AppLocalizations.of(context)!.sameDayShippingDesc),
            trailing: Radio(value: 'same_day', groupValue: 'shipping', onChanged: (value) {}),
          ),
        ],
      ),
    );
  }
}
