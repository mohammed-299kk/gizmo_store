import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text('Gizmo Store - ${AppLocalizations.of(context)!.test}'),
        backgroundColor: Color(0xFFB71C1C),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag,
              size: 100,
              color: Color(0xFFB71C1C),
            ),
            const SizedBox(height: 20),
            const Text(
              'Gizmo Store',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.smartElectronicsStore,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              AppLocalizations.of(context)!.appWorkingSuccessfully,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.redScreenFreezeFixed,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Functions can be added here later
        },
        backgroundColor: Color(0xFFB71C1C),
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
