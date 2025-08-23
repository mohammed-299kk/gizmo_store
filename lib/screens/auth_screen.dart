import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import '../services/firebase_auth_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // شعار التطبيق
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFB71C1C),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Gizmo Store',
                        style: TextStyle(
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

              // العنوان
              Text(
                isLogin ? "مرحباً بعودتك!" : "إنشاء حساب جديد",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                isLogin ? "سجل دخولك للمتابعة" : "انضم إلى عائلة Gizmo Store",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // حقول الإدخال
              if (!isLogin) ...[
                _buildTextField(
                  controller: _nameController,
                  label: "الاسم الكامل",
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
              ],

              _buildTextField(
                controller: _emailController,
                label: "البريد الإلكتروني",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _passwordController,
                label: "كلمة المرور",
                icon: Icons.lock,
                obscureText: true,
              ),

              const SizedBox(height: 32),

              // زر التسجيل/الدخول
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB71C1C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isLoading ? 0 : 3,
                  ),
                  child: isLoading
                      ? const Row(
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
                              "جاري المعالجة...",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Text(
                          isLogin ? "تسجيل الدخول" : "إنشاء حساب",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // زر التبديل
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => setState(() => isLogin = !isLogin),
                child: Text(
                  isLogin
                      ? "ليس لديك حساب؟ إنشاء حساب جديد"
                      : "لديك حساب؟ تسجيل الدخول",
                  style: TextStyle(
                    color: isLoading ? Colors.grey : const Color(0xFFB71C1C),
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // خط فاصل
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "أو",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white24)),
                ],
              ),

              const SizedBox(height: 24),

              // زر الدخول كضيف
              OutlinedButton(
                onPressed: isLoading ? null : _continueAsGuest,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(
                      color: isLoading ? Colors.grey : const Color(0xFFB71C1C)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "الدخول كضيف",
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 40),

              // معلومات إضافية
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.security,
                      color: Color(0xFFB71C1C),
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'بياناتك آمنة معنا',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'نحن نحمي خصوصيتك ونؤمن بياناتك بأعلى معايير الأمان',
                      style: TextStyle(
                        color: Colors.white70,
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
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
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
        );
        
        if (mounted) {
          _showSuccessMessage('تم تسجيل الدخول بنجاح!');
        }
      } else {
        // إنشاء حساب جديد باستخدام Firebase Auth
        await FirebaseAuthService.createUserWithEmailAndPassword(
          email: email,
          password: password,
          name: name,
        );
        
        if (mounted) {
          _showSuccessMessage('تم إنشاء الحساب بنجاح!');
        }
      }

      if (mounted) {
        setState(() => isLoading = false);
        
        // الانتقال إلى الشاشة الرئيسية
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
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
      // تسجيل الدخول كضيف باستخدام Firebase Auth
      await FirebaseAuthService.signInAnonymously();

      if (mounted) {
        setState(() => isLoading = false);
        
        _showSuccessMessage('مرحباً بك كضيف!');

        // الانتقال إلى الشاشة الرئيسية
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
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