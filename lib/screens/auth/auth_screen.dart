import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import 'package:gizmo_store/providers/auth_provider.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/theme_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Login or create account function
  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.fillAllRequiredFields)),
      );
      return;
    }

    if (!isLogin) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      if (firstName.isEmpty || lastName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.enterFirstAndLastName)),
        );
        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.passwordsDoNotMatch)),
        );
        return;
      }

      if (password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.passwordMinLength)),
        );
        return;
      }
    }

    setState(() => isLoading = true);

    try {
      final authProvider =
          Provider.of<auth.AuthProvider>(context, listen: false);

      if (isLogin) {
        await authProvider.signIn(email, password);
      } else {
        await authProvider.signUp(
          email,
          password,
          _confirmPasswordController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          context: context,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  // دالة تسجيل الدخول كضيف
  Future<void> _continueAsGuest() async {
    try {
      final authProvider =
          Provider.of<auth.AuthProvider>(context, listen: false);
      await authProvider.signInAsGuest();
      // لا حاجة للانتقال يدوياً - AuthGate سيتولى ذلك
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Theme toggle button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: themeProvider.isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          onPressed: () {
                            themeProvider.toggleTheme();
                          },
                          icon: Icon(
                            themeProvider.isDarkMode
                                ? Icons.wb_sunny
                                : Icons.nightlight_round,
                            color: themeProvider.isDarkMode
                                ? Colors.yellow
                                : Colors.grey[700],
                            size: 24,
                          ),
                          tooltip: themeProvider.isDarkMode
                              ? 'الوضع الفاتح'
                              : 'الوضع المظلم',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // شعار التطبيق
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB71C1C), // Red color
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Gizmo Store',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    isLogin
                        ? AppLocalizations.of(context)!.welcomeBack
                        : AppLocalizations.of(context)!.createNewAccount,
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  Text(
                    isLogin
                        ? AppLocalizations.of(context)!.signInToContinue
                        : AppLocalizations.of(context)!.joinGizmoFamily,
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Colors.white70
                          : Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Input fields
                  if (!isLogin) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _firstNameController,
                            label: AppLocalizations.of(context)!.firstName,
                            icon: Icons.person,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _lastNameController,
                            label: AppLocalizations.of(context)!.lastName,
                            icon: Icons.person_outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  _buildTextField(
                    controller: _emailController,
                    label: AppLocalizations.of(context)!.email,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    controller: _passwordController,
                    label: AppLocalizations.of(context)!.password,
                    icon: Icons.lock,
                    isPassword: true,
                    isPasswordVisible: !_obscurePassword,
                    onToggleVisibility: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  if (!isLogin) ...[
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: AppLocalizations.of(context)!.confirmPassword,
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: !_obscureConfirmPassword,
                      onToggleVisibility: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Sign in/register button
                  if (isLoading)
                    const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFB71C1C)),
                    )
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFB71C1C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isLogin
                            ? AppLocalizations.of(context)!.signIn
                            : AppLocalizations.of(context)!.createAccount,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // زر التبديل
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? AppLocalizations.of(context)!.noAccountCreateNew
                          : AppLocalizations.of(context)!.haveAccountSignIn,
                      style: const TextStyle(
                        color: Color(0xFFB71C1C),
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // خط فاصل
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                              color: themeProvider.isDarkMode
                                  ? Colors.white24
                                  : Colors.black26)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          AppLocalizations.of(context)!.or,
                          style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.black54),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                              color: themeProvider.isDarkMode
                                  ? Colors.white24
                                  : Colors.black26)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // زر الدخول كضيف
                  OutlinedButton(
                    onPressed: _continueAsGuest,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      side: const BorderSide(color: Color(0xFFB71C1C)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.continueAsGuest,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // دالة لبناء حقل الإدخال
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    bool isPassword = false,
    VoidCallback? onToggleVisibility,
    bool? isPasswordVisible,
  }) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return TextField(
          controller: controller,
          obscureText: isPassword ? !(isPasswordVisible ?? false) : obscureText,
          keyboardType: keyboardType,
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
            ),
            prefixIcon: Icon(
              icon,
              color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
            ),
            suffixIcon: isPassword && onToggleVisibility != null
                ? IconButton(
                    icon: Icon(
                      (isPasswordVisible ?? false)
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      size: 24,
                    ),
                    onPressed: onToggleVisibility,
                    tooltip: (isPasswordVisible ?? false)
                        ? AppLocalizations.of(context)!.hidePassword
                        : AppLocalizations.of(context)!.showPassword,
                    splashRadius: 20,
                  )
                : null,
            filled: true,
            fillColor: themeProvider.isDarkMode
                ? const Color(0xFF2A2A2A)
                : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: Color(0xFFB71C1C), width: 2), // Red color
            ),
          ),
        );
      },
    );
  }
}
