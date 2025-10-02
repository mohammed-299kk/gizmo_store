import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)!.settings),
      ),
    );
  }
}
