import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmo_store/providers/auth_provider.dart' as auth;
import 'package:gizmo_store/services/firebase_auth_service.dart';
import 'package:gizmo_store/widgets/image_upload_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _showPasswordFields = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userData = await FirebaseAuthService.getUserData(user.uid, context);
        if (userData != null) {
          setState(() {
            _emailController.text = userData['email'] ?? '';

            // Parse full name
            final fullName = userData['name'] ?? '';
            final nameParts = fullName.split(' ');
            if (nameParts.isNotEmpty) {
              _firstNameController.text = nameParts[0];
              if (nameParts.length > 1) {
                _lastNameController.text = nameParts.last;
                if (nameParts.length > 2) {
                  _middleNameController.text = nameParts.sublist(1, nameParts.length - 1).join(' ');
                }
              }
            }

            // Load profile data
            final profile = userData['profile'] ?? {};
            _phoneController.text = profile['phone'] ?? '';
            _profileImageUrl = userData['photoURL'] ?? user.photoURL;
          });
        }
      } catch (e) {
        _showErrorMessage('${AppLocalizations.of(context)!.failedToLoadUserData}: $e');
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editProfile, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: Text(
                AppLocalizations.of(context)!.save,
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProfileImageSection(),
              const SizedBox(height: 24),
              _buildPersonalInfoSection(),
              const SizedBox(height: 24),
              _buildContactInfoSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.profilePicture,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headlineSmall?.color),
          ),
          const SizedBox(height: 16),
          ImageUploadWidget(
            initialImages: _profileImageUrl != null ? [_profileImageUrl!] : [],
            onImagesChanged: (imageUrls) {
              setState(() {
                _profileImageUrl = imageUrls.isNotEmpty ? imageUrls.first : null;
              });
            },
            folder: 'gizmo_store/profiles',
            allowMultiple: false,
            height: 120,
            width: 120,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.personalInformation,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headlineSmall?.color),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _firstNameController,
            label: AppLocalizations.of(context)!.firstName,
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context)!.firstNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _middleNameController,
            label: AppLocalizations.of(context)!.middleNameOptional,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _lastNameController,
            label: AppLocalizations.of(context)!.lastName,
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context)!.lastNameRequired;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.contactInformation,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headlineSmall?.color),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: AppLocalizations.of(context)!.email,
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context)!.emailRequired;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return AppLocalizations.of(context)!.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: AppLocalizations.of(context)!.phoneOptional,
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }



  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
    bool? isPasswordVisible,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword ? !(isPasswordVisible ?? false) : obscureText,
      validator: validator,
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)),
        prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.error),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  (isPasswordVisible ?? false) ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).iconTheme.color?.withValues(alpha: 0.7),
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
        ),
      ),
    );
  }













  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorMessage('المستخدم غير مسجل الدخول');
        return;
      }

      // Update display name
      final fullName = '${_firstNameController.text.trim()} '
          '${_middleNameController.text.trim().isNotEmpty ? '${_middleNameController.text.trim()} ' : ''}'
          '${_lastNameController.text.trim()}';

      await user.updateDisplayName(fullName);

      // Update email if changed
      if (_emailController.text.trim() != user.email) {
        await user.verifyBeforeUpdateEmail(_emailController.text.trim());
      }

      // Update password if requested
      if (_showPasswordFields && _newPasswordController.text.isNotEmpty) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPasswordController.text);
      }

      // Update profile picture if changed
      String? photoURL = _profileImageUrl;
      if (photoURL != null && photoURL != user.photoURL) {
        await user.updatePhotoURL(photoURL);
        // Also update the auth provider to refresh the UI
        if (mounted) {
          final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);
          await authProvider.refreshUser();
        }
      }

      // Update Firestore data
      final updateData = {
        'name': fullName,
        'email': _emailController.text.trim(),
        'profile.phone': _phoneController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (photoURL != null) {
        updateData['photoURL'] = photoURL;
        updateData['profile.photoURL'] = photoURL; // Also update in profile sub-document
      }

      await FirebaseAuthService.updateUserData(user.uid, updateData, context);

      _showSuccessMessage(AppLocalizations.of(context)!.changesSavedSuccess);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorMessage('${AppLocalizations.of(context)!.saveChangesFailed}: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
