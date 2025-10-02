import 'package:flutter/material.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedPaymentMethod = 'cash';
  final List<Map<String, dynamic>> _savedCards = [];
  
  @override
  void initState() {
    super.initState();
    _loadSavedPaymentMethod();
    _loadSavedCards();
  }

  Future<void> _loadSavedPaymentMethod() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPaymentMethod = prefs.getString('selected_payment_method') ?? 'cash';
    });
  }

  Future<void> _savePaymentMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_payment_method', method);
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Future<void> _loadSavedCards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cardsList = prefs.getStringList('saved_cards');
    if (cardsList != null) {
      setState(() {
        _savedCards.clear();
        for (String cardData in cardsList) {
          final parts = cardData.split('|');
          if (parts.length >= 4) {
            _savedCards.add({
              'type': parts[0],
              'number': parts[1],
              'holder': parts[2],
              'expiry': parts[3],
            });
          }
        }
      });
    }
  }

  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cardsList = _savedCards.map((card) {
      return '${card['type']}|${card['number']}|${card['holder']}|${card['expiry']}';
    }).toList();
    await prefs.setStringList('saved_cards', cardsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.paymentMethods),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('طرق الدفع المتاحة'),
          
          // الدفع النقدي
          _buildPaymentMethodTile(
            icon: Icons.money,
            title: 'الدفع النقدي',
            subtitle: 'الدفع عند الاستلام',
            value: 'cash',
            color: Colors.green,
          ),
          
          // فيزا كارد
          _buildPaymentMethodTile(
            icon: Icons.credit_card,
            title: 'فيزا كارد',
            subtitle: 'الدفع بواسطة بطاقة فيزا',
            value: 'visa',
            color: Colors.blue,
          ),
          
          // ماستر كارد
          _buildPaymentMethodTile(
            icon: Icons.credit_card,
            title: 'ماستر كارد',
            subtitle: 'الدفع بواسطة بطاقة ماستر كارد',
            value: 'mastercard',
            color: Colors.orange,
          ),
          
          const SizedBox(height: 20),
          
          // البطاقات المحفوظة
          if (_savedCards.isNotEmpty) ...[
            _buildSectionTitle('البطاقات المحفوظة'),
            ..._savedCards.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> card = entry.value;
              return _buildSavedCardTile(card, index);
            }).toList(),
            const SizedBox(height: 20),
          ],
          
          // إضافة بطاقة جديدة
          if (_selectedPaymentMethod == 'visa' || _selectedPaymentMethod == 'mastercard')
            _buildAddCardButton(),
          
          const SizedBox(height: 20),
          
          // معلومات الأمان
          _buildSecurityInfo(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge?.color,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: _selectedPaymentMethod == value
            ? Border.all(color: color, width: 2)
            : null,
      ),
      child: RadioListTile<String>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (String? newValue) {
          if (newValue != null) {
            _savePaymentMethod(newValue);
          }
        },
        title: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(right: 36),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
            ),
          ),
        ),
        activeColor: color,
      ),
    );
  }

  Widget _buildSavedCardTile(Map<String, dynamic> card, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          Icons.credit_card,
          color: card['type'] == 'visa' ? Colors.blue : Colors.orange,
        ),
        title: Text(
          '${card['type'].toString().toUpperCase()} **** ${card['number'].toString().substring(card['number'].toString().length - 4)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        subtitle: Text(
          '${card['holder']} • ${card['expiry']}',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => _deleteCard(index),
        ),
      ),
    );
  }

  Widget _buildAddCardButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton.icon(
        onPressed: () => _showAddCardDialog(),
        icon: const Icon(Icons.add),
        label: const Text('إضافة بطاقة جديدة'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'معلومات الأمان',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• جميع بيانات البطاقات محفوظة محلياً على جهازك فقط\n'
            '• لا يتم إرسال بيانات البطاقات إلى الخوادم\n'
            '• هذا نظام وهمي لأغراض العرض فقط\n'
            '• في التطبيق الحقيقي، استخدم بوابات دفع آمنة',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    final TextEditingController numberController = TextEditingController();
    final TextEditingController holderController = TextEditingController();
    final TextEditingController expiryController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('إضافة بطاقة جديدة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: numberController,
                  decoration: const InputDecoration(
                    labelText: 'رقم البطاقة',
                    hintText: '1234 5678 9012 3456',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 19,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: holderController,
                  decoration: const InputDecoration(
                    labelText: 'اسم حامل البطاقة',
                    hintText: 'Ahmed Ali',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expiryController,
                        decoration: const InputDecoration(
                          labelText: 'تاريخ الانتهاء',
                          hintText: 'MM/YY',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: cvvController,
                        decoration: const InputDecoration(
                          labelText: 'CVV',
                          hintText: '123',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_validateCardData(
                  numberController.text,
                  holderController.text,
                  expiryController.text,
                  cvvController.text,
                )) {
                  _addCard(
                    numberController.text,
                    holderController.text,
                    expiryController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  bool _validateCardData(String number, String holder, String expiry, String cvv) {
    if (number.replaceAll(' ', '').length < 16) {
      _showErrorSnackBar('رقم البطاقة غير صحيح');
      return false;
    }
    if (holder.trim().isEmpty) {
      _showErrorSnackBar('اسم حامل البطاقة مطلوب');
      return false;
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry)) {
      _showErrorSnackBar('تاريخ الانتهاء غير صحيح (MM/YY)');
      return false;
    }
    if (cvv.length != 3) {
      _showErrorSnackBar('CVV غير صحيح');
      return false;
    }
    return true;
  }

  void _addCard(String number, String holder, String expiry) {
    setState(() {
      _savedCards.add({
        'type': _selectedPaymentMethod,
        'number': number.replaceAll(' ', ''),
        'holder': holder.trim(),
        'expiry': expiry,
      });
    });
    _saveCards();
    _showSuccessSnackBar('تم حفظ البطاقة بنجاح');
  }

  void _deleteCard(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('حذف البطاقة'),
          content: const Text('هل أنت متأكد من حذف هذه البطاقة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _savedCards.removeAt(index);
                });
                _saveCards();
                Navigator.of(context).pop();
                _showSuccessSnackBar('تم حذف البطاقة');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}