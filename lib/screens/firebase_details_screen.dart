import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gizmo_store/firebase_options.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';

class FirebaseDetailsScreen extends StatelessWidget {
  const FirebaseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseApp app = Firebase.app();
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.firebaseDetails, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(AppLocalizations.of(context)!.appInfo),
            _buildDetailCard([
              _buildDetailRow('${AppLocalizations.of(context)!.appName}:', app.name),
              _buildDetailRow('${AppLocalizations.of(context)!.projectId}:', DefaultFirebaseOptions.currentPlatform.projectId),
              _buildDetailRow('${AppLocalizations.of(context)!.apiKey}:', DefaultFirebaseOptions.currentPlatform.apiKey),
              _buildDetailRow('${AppLocalizations.of(context)!.appId}:', DefaultFirebaseOptions.currentPlatform.appId),
              _buildDetailRow('${AppLocalizations.of(context)!.androidClientId}:', DefaultFirebaseOptions.currentPlatform.androidClientId ?? AppLocalizations.of(context)!.notAvailable),
              _buildDetailRow('${AppLocalizations.of(context)!.iosClientId}:', DefaultFirebaseOptions.currentPlatform.iosClientId ?? AppLocalizations.of(context)!.notAvailable),
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle(AppLocalizations.of(context)!.authStatus),
            _buildDetailCard([
              _buildDetailRow('${AppLocalizations.of(context)!.loginStatus}:', currentUser != null ? AppLocalizations.of(context)!.loggedIn : AppLocalizations.of(context)!.notLoggedIn),
              if (currentUser != null) ...[
                _buildDetailRow('${AppLocalizations.of(context)!.userId} (UID):', currentUser.uid),
                _buildDetailRow('${AppLocalizations.of(context)!.email}:', currentUser.email ?? AppLocalizations.of(context)!.notAvailable),
                _buildDetailRow('${AppLocalizations.of(context)!.displayName}:', currentUser.displayName ?? AppLocalizations.of(context)!.notAvailable),
                _buildDetailRow('${AppLocalizations.of(context)!.anonymous}:', currentUser.isAnonymous ? AppLocalizations.of(context)!.yes : AppLocalizations.of(context)!.no),
              ],
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle(AppLocalizations.of(context)!.servicesStatus),
            _buildDetailCard([
              _buildDetailRow('Firestore:', AppLocalizations.of(context)!.connectedIfAppRunning),
              _buildDetailRow('Messaging:', AppLocalizations.of(context)!.connectedIfConfigured),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}