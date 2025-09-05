import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعدة والدعم'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          _buildSectionHeader('الأسئلة الشائعة'),
          _buildFAQSection(),
          const SizedBox(height: 20),
          _buildSectionHeader('تواصل معنا'),
          _buildContactSection(context),
          const SizedBox(height: 20),
          _buildSectionHeader('موارد مفيدة'),
          _buildResourcesSection(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.support_agent,
              size: 60,
              color: Color(0xFFB71C1C),
            ),
            const SizedBox(height: 12),
            const Text(
              'مرحباً بك في مركز المساعدة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'نحن هنا لمساعدتك في أي استفسار أو مشكلة قد تواجهها',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    final faqs = [
      {
        'question': 'كيف يمكنني تتبع طلبي؟',
        'answer': 'يمكنك تتبع طلبك من خلال الذهاب إلى قسم "طلباتي" في الملف الشخصي. ستجد هناك جميع تفاصيل الطلب وحالته الحالية.',
      },
      {
        'question': 'ما هي طرق الدفع المتاحة؟',
        'answer': 'نقبل جميع بطاقات الائتمان الرئيسية، الدفع عند الاستلام، والتحويل البنكي. يمكنك اختيار الطريقة المناسبة لك عند إتمام الطلب.',
      },
      {
        'question': 'كم تستغرق عملية التوصيل؟',
        'answer': 'عادة ما يستغرق التوصيل من 2-5 أيام عمل حسب موقعك. للطلبات العاجلة، يمكنك اختيار خدمة التوصيل السريع.',
      },
      {
        'question': 'هل يمكنني إرجاع أو استبدال المنتج؟',
        'answer': 'نعم، يمكنك إرجاع أو استبدال المنتج خلال 14 يوم من تاريخ الاستلام، بشرط أن يكون المنتج في حالته الأصلية.',
      },
      {
        'question': 'كيف يمكنني تغيير كلمة المرور؟',
        'answer': 'اذهب إلى الملف الشخصي > الأمان والخصوصية > تغيير كلمة المرور. ستحتاج إلى إدخال كلمة المرور الحالية والجديدة.',
      },
    ];

    return Column(
      children: faqs.map((faq) => _buildFAQItem(faq['question']!, faq['answer']!)).toList(),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      children: [
        _buildContactOption(
          icon: Icons.email_outlined,
          title: 'البريد الإلكتروني',
          subtitle: 'support@gizmostore.com',
          onTap: () => _showContactInfo(context, 'البريد الإلكتروني', 'support@gizmostore.com'),
        ),
        _buildContactOption(
          icon: Icons.phone_outlined,
          title: 'الهاتف',
          subtitle: '+966 11 123 4567',
          onTap: () => _showContactInfo(context, 'الهاتف', '+966 11 123 4567'),
        ),
        _buildContactOption(
          icon: Icons.chat_outlined,
          title: 'الدردشة المباشرة',
          subtitle: 'متاح من 9 صباحاً إلى 6 مساءً',
          onTap: () => _showLiveChatDialog(context),
        ),
        _buildContactOption(
          icon: Icons.location_on_outlined,
          title: 'زيارة المتجر',
          subtitle: 'الرياض، المملكة العربية السعودية',
          onTap: () => _showStoreLocationDialog(context),
        ),
      ],
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFFB71C1C),
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildResourcesSection(BuildContext context) {
    return Column(
      children: [
        _buildResourceOption(
          icon: Icons.article_outlined,
          title: 'دليل المستخدم',
          subtitle: 'تعلم كيفية استخدام التطبيق',
          onTap: () => _showUserGuideDialog(context),
        ),
        _buildResourceOption(
          icon: Icons.policy_outlined,
          title: 'سياسة الخصوصية',
          subtitle: 'اطلع على سياسة حماية البيانات',
          onTap: () => _showPrivacyPolicyDialog(context),
        ),
        _buildResourceOption(
          icon: Icons.gavel_outlined,
          title: 'الشروط والأحكام',
          subtitle: 'اقرأ شروط الاستخدام',
          onTap: () => _showTermsDialog(context),
        ),
        _buildResourceOption(
          icon: Icons.feedback_outlined,
          title: 'إرسال ملاحظات',
          subtitle: 'شاركنا رأيك لتحسين الخدمة',
          onTap: () => _showFeedbackDialog(context),
        ),
      ],
    );
  }

  Widget _buildResourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.green,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showContactInfo(BuildContext context, String title, String info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SelectableText(info),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showLiveChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الدردشة المباشرة'),
        content: const Text(
          'خدمة الدردشة المباشرة متاحة من الساعة 9 صباحاً إلى 6 مساءً، من الأحد إلى الخميس.\n\nيمكنك أيضاً إرسال رسالة عبر البريد الإلكتروني وسنرد عليك في أقرب وقت ممكن.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showStoreLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('موقع المتجر'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'العنوان:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('شارع الملك فهد، الرياض\nالمملكة العربية السعودية'),
            SizedBox(height: 12),
            Text(
              'ساعات العمل:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('الأحد - الخميس: 9:00 ص - 10:00 م\nالجمعة - السبت: 2:00 م - 11:00 م'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _showUserGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('دليل المستخدم'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. التسجيل والدخول:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('قم بإنشاء حساب جديد أو تسجيل الدخول بحسابك الموجود.\n'),
              Text(
                '2. تصفح المنتجات:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('استخدم شريط البحث أو تصفح الفئات للعثور على المنتجات.\n'),
              Text(
                '3. إضافة إلى السلة:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('اضغط على "إضافة إلى السلة" لحفظ المنتجات للشراء لاحقاً.\n'),
              Text(
                '4. إتمام الطلب:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('اذهب إلى السلة واتبع خطوات الدفع لإتمام طلبك.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('فهمت'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Text(
            'نحن في جيزمو ستور نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية.\n\n'
            'المعلومات التي نجمعها:\n'
            '- معلومات الحساب (الاسم، البريد الإلكتروني)\n'
            '- معلومات الطلبات والمدفوعات\n'
            '- بيانات الاستخدام لتحسين الخدمة\n\n'
            'كيف نستخدم المعلومات:\n'
            '- معالجة الطلبات والمدفوعات\n'
            '- تحسين تجربة المستخدم\n'
            '- إرسال التحديثات والعروض\n\n'
            'لن نشارك معلوماتك مع أطراف ثالثة دون موافقتك.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الشروط والأحكام'),
        content: const SingleChildScrollView(
          child: Text(
            'شروط الاستخدام:\n\n'
            '1. يجب أن تكون 18 سنة أو أكثر لاستخدام هذا التطبيق.\n\n'
            '2. جميع المعلومات المقدمة يجب أن تكون صحيحة ومحدثة.\n\n'
            '3. يحق لنا إلغاء أي طلب في حالة عدم توفر المنتج.\n\n'
            '4. الأسعار قابلة للتغيير دون إشعار مسبق.\n\n'
            '5. سياسة الإرجاع تطبق خلال 14 يوم من تاريخ الاستلام.\n\n'
            '6. نحتفظ بالحق في تعديل هذه الشروط في أي وقت.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إرسال ملاحظات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('نحن نقدر ملاحظاتك ونسعى لتحسين خدماتنا باستمرار.'),
            const SizedBox(height: 16),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'اكتب ملاحظاتك هنا...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (feedbackController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('شكراً لك! تم إرسال ملاحظاتك بنجاح.'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }
}