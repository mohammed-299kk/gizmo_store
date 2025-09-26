import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import 'home/home_screen.dart';
import '../services/firebase_auth_service.dart';
import '../providers/theme_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Admin access icon
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/admin_login');
                      },
                      icon: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.orange,
                        size: 24,
                      ),
                      tooltip: 'دخول الأدمن',
                    ),
                  ),
                  // Theme toggle button
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => themeProvider.toggleTheme(),
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          isDark ? Icons.wb_sunny : Icons.nightlight_round,
                          key: ValueKey(isDark),
                          color:
                              isDark ? Colors.amber : const Color(0xFFB71C1C),
                          size: 24,
                        ),
                      ),
                      tooltip: isDark
                          ? 'التبديل للوضع النهاري'
                          : 'التبديل للوضع الليلي',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // App logo
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.appTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                isLogin
                    ? AppLocalizations.of(context)!.signInToContinue
                    : AppLocalizations.of(context)!.joinGizmoFamily,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Input fields
              if (!isLogin) ...[
                _buildTextField(
                  controller: _nameController,
                  label: AppLocalizations.of(context)!.fullName,
                  icon: Icons.person,
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

              const SizedBox(height: 32),

              // زر التسجيل/الدخول
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isLoading ? 0 : 3,
                  ),
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.loading,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Text(
                          isLogin
                              ? AppLocalizations.of(context)!.signIn
                              : AppLocalizations.of(context)!.createAccount,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Toggle button
              TextButton(
                onPressed:
                    isLoading ? null : () => setState(() => isLogin = !isLogin),
                child: Text(
                  isLogin
                      ? AppLocalizations.of(context)!.noAccountCreateNew
                      : AppLocalizations.of(context)!.haveAccountSignIn,
                  style: TextStyle(
                    color: isLoading ? Colors.grey : const Color(0xFFB71C1C),
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Divider line
              Row(
                children: [
                  Expanded(
                      child: Divider(
                          color: isDark ? Colors.white24 : Colors.black26)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      AppLocalizations.of(context)!.or,
                      style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                          color: isDark ? Colors.white24 : Colors.black26)),
                ],
              ),

              const SizedBox(height: 24),

              // زر الدخول كضيف
              OutlinedButton(
                onPressed: isLoading ? null : _continueAsGuest,
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : Colors.black87,
                  side: BorderSide(
                      color: isLoading ? Colors.grey : const Color(0xFFB71C1C)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.continueAsGuest,
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 40),

              // معلومات إضافية
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.security,
                      color: Color(0xFFB71C1C),
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'بياناتك آمنة معنا',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'نحن نحمي خصوصيتك ونؤمن بياناتك بأعلى معايير الأمان',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    return TextField(
      controller: controller,
      obscureText: isPassword ? !(isPasswordVisible ?? false) : obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
        prefixIcon: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
        suffixIcon: isPassword && onToggleVisibility != null
            ? IconButton(
                icon: Icon(
                  (isPasswordVisible ?? false)
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 24,
                ),
                onPressed: onToggleVisibility,
                tooltip: (isPasswordVisible ?? false)
                    ? 'إخفاء كلمة المرور'
                    : 'إظهار كلمة المرور',
                splashRadius: 20,
              )
            : null,
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isDark
              ? BorderSide.none
              : const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: isDark
              ? BorderSide.none
              : const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB71C1C), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    // التحقق من صحة البيانات
    if (email.isEmpty || password.isEmpty) {
      _showErrorMessage('يرجى ملء جميع الحقول المطلوبة');
      return;
    }

    if (!isLogin && name.isEmpty) {
      _showErrorMessage('يرجى إدخال الاسم الكامل');
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorMessage('يرجى إدخال بريد إلكتروني صحيح');
      return;
    }

    if (password.length < 6) {
      _showErrorMessage('كلمة المرور يجب أن تكون 6 أحرف على الأقل');
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        // تسجيل الدخول باستخدام Firebase Auth
        await FirebaseAuthService.signInWithEmailAndPassword(
          email: email,
          password: password,
          context: context,
        );

        if (mounted) {
          _showSuccessMessage(AppLocalizations.of(context)!.signInSuccess);
        }
      } else {
        // إنشاء حساب جديد باستخدام Firebase Auth
        await FirebaseAuthService.createUserWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
          context: context,
        );

        if (mounted) {
          _showSuccessMessage(
              AppLocalizations.of(context)!.accountCreatedSuccess);
        }
      }

      if (mounted) {
        setState(() => isLoading = false);

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showErrorMessage(e.toString());
      }
    }
  }

  Future<void> _continueAsGuest() async {
    setState(() => isLoading = true);

    try {
      // Sign in as guest using Firebase Auth
      await FirebaseAuthService.signInAnonymously(context);

      if (mounted) {
        setState(() => isLoading = false);

        _showSuccessMessage(AppLocalizations.of(context)!.welcomeGuest);

        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showErrorMessage(e.toString());
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'إغلاق',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
