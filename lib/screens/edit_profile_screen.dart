import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:gizmo_store/providers/auth_provider.dart' as auth;
import 'package:gizmo_store/services/firebase_auth_service.dart';

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
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showPasswordFields = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userData = await FirebaseAuthService.getUserData(user.uid);
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
          });
        }
      } catch (e) {
        _showErrorMessage('فشل في تحميل بيانات المستخدم: $e');
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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('تعديل الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'حفظ',
                style: TextStyle(color: Color(0xFFB71C1C), fontWeight: FontWeight.bold),
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
              const SizedBox(height: 24),
              _buildPasswordSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const Text(
            'صورة الملف الشخصي',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFB71C1C), width: 3),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[800],
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!) as ImageProvider
                    : (user?.photoURL != null ? NetworkImage(user!.photoURL!) as ImageProvider : null),
                child: _selectedImage == null && user?.photoURL == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.grey[400],
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.edit, color: Color(0xFFB71C1C)),
            label: Text(
              (_selectedImage != null || user?.photoURL != null) ? 'تغيير الصورة' : 'إضافة صورة',
              style: const TextStyle(color: Color(0xFFB71C1C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'المعلومات الشخصية',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _firstNameController,
            label: 'الاسم الأول',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'الاسم الأول مطلوب';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _middleNameController,
            label: 'الاسم الأوسط (اختياري)',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _lastNameController,
            label: 'الاسم الأخير',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'الاسم الأخير مطلوب';
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
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات الاتصال',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'البريد الإلكتروني',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'البريد الإلكتروني مطلوب';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'البريد الإلكتروني غير صحيح';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: 'رقم الهاتف (اختياري)',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'تغيير كلمة المرور',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Switch(
                value: _showPasswordFields,
                onChanged: (value) {
                  setState(() {
                    _showPasswordFields = value;
                    if (!value) {
                      _currentPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                    }
                  });
                },
                activeThumbColor: const Color(0xFFB71C1C),
              ),
            ],
          ),
          if (_showPasswordFields) ...[
            const SizedBox(height: 16),
            _buildTextField(
              controller: _currentPasswordController,
              label: 'كلمة المرور الحالية',
              icon: Icons.lock_outline,
              isPassword: true,
              isPasswordVisible: !_obscureCurrentPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
              validator: (value) {
                if (_showPasswordFields && (value == null || value.trim().isEmpty)) {
                  return 'كلمة المرور الحالية مطلوبة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _newPasswordController,
              label: 'كلمة المرور الجديدة',
              icon: Icons.lock,
              isPassword: true,
              isPasswordVisible: !_obscureNewPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
              validator: (value) {
                if (_showPasswordFields) {
                  if (value == null || value.trim().isEmpty) {
                    return 'كلمة المرور الجديدة مطلوبة';
                  }
                  if (value.length < 6) {
                    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'تأكيد كلمة المرور الجديدة',
              icon: Icons.lock_outline,
              isPassword: true,
              isPasswordVisible: !_obscureConfirmPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              validator: (value) {
                if (_showPasswordFields) {
                  if (value == null || value.trim().isEmpty) {
                    return 'تأكيد كلمة المرور مطلوب';
                  }
                  if (value != _newPasswordController.text) {
                    return 'كلمات المرور غير متطابقة';
                  }
                }
                return null;
              },
            ),
          ],
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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: const Color(0xFFB71C1C)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  (isPasswordVisible ?? false) ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB71C1C), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF2A2A2A),
        builder: (context) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'اختر مصدر الصورة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageSourceOption(
                    icon: Icons.camera_alt,
                    label: 'الكاميرا',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromSource(ImageSource.camera);
                    },
                  ),
                  _buildImageSourceOption(
                    icon: Icons.photo_library,
                    label: 'المعرض',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImageFromSource(ImageSource.gallery);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    } catch (e) {
      _showErrorMessage('حدث خطأ في اختيار الصورة');
    }
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFB71C1C), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFB71C1C), size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showErrorMessage('فشل في اختيار الصورة');
    }
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showErrorMessage('المستخدم غير مسجل الدخول');
        return null;
      }

      // Show upload progress
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('جاري رفع الصورة...'),
          backgroundColor: Color(0xFFB71C1C),
          duration: Duration(seconds: 2),
        ),
      );

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child('${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم رفع الصورة بنجاح'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }

      return downloadUrl;
    } catch (e) {
      _showErrorMessage('فشل في رفع الصورة: ${e.toString()}');
      return null;
    }
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

      // Upload profile picture if selected
      String? photoURL = user.photoURL;
      if (_selectedImage != null) {
        photoURL = await _uploadImageToFirebase(_selectedImage!);
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
          // Also update the auth provider to refresh the UI
          if (mounted) {
            final authProvider = Provider.of<auth.AuthProvider>(context, listen: false);
            await authProvider.refreshUser();
          }
        } else {
          // Upload failed, don't proceed with saving other data
          setState(() {
            _isLoading = false;
          });
          return;
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
      }

      await FirebaseAuthService.updateUserData(user.uid, updateData);

      _showSuccessMessage('تم حفظ التغييرات بنجاح');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorMessage('فشل في حفظ التغييرات: $e');
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
          backgroundColor: Colors.red,
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