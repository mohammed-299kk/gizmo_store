import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmo_store/l10n/app_localizations.dart';
import '../../widgets/image_upload_widget.dart';
import '../../utils/image_helper.dart';
import '../../services/image_upload_service.dart';

class CategoryField {
  final String key;
  final String label;
  final String type; // 'input', 'select', 'textarea'
  final List<Map<String, String>>? options;
  final String? placeholder;
  final IconData? icon;
  final bool required;

  CategoryField({
    required this.key,
    required this.label,
    required this.type,
    this.options,
    this.placeholder,
    this.icon,
    this.required = false,
  });
}

class ProductCategory {
  final String id;
  final String name;
  final IconData icon;
  final List<CategoryField> fields;
  final String defaultImage;

  ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.fields,
    required this.defaultImage,
  });
}

class ProductFormData {
  String name;
  String brand;
  String model;
  String price;
  String currency;
  String description;
  String category;
  String color;
  String warranty;
  String availability;
  String discount;
  String stock;
  bool featured;
  List<String> tags;
  List<String> images;
  Map<String, String> specifications;

  ProductFormData({
    this.name = '',
    this.brand = '',
    this.model = '',
    this.price = '',
    this.currency = 'ج.س',
    this.description = '',
    this.category = '',
    this.color = '',
    this.warranty = '',
    this.availability = '',
    this.discount = '',
    this.stock = '',
    this.featured = false,
    this.tags = const [],
    this.images = const [],
    this.specifications = const {},
  });
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late ProductFormData _formData;
  String _newTag = '';
  ProductCategory? _selectedCategory;
  bool _isLoading = false;

  // تعريف فئات المنتجات
  final List<ProductCategory> _productCategories = [
    ProductCategory(
      id: 'smartphones',
      name: 'الهواتف الذكية',
      icon: Icons.smartphone,
      defaultImage:
          "https://images.unsplash.com/photo-1592647416962-838a003e9859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBzbWFydHBob25lJTIwbW9iaWxlJTIwcGhvbmV8ZW58MXx8fHwxNzU4MzU2NDI1fDA&ixlib=rb-4.1.0&q=80&w=1080",
      fields: [
        CategoryField(
          key: 'processor',
          label: 'المعالج',
          type: 'input',
          placeholder: 'A17 Pro',
          icon: Icons.memory,
          required: true,
        ),
        CategoryField(
          key: 'ram',
          label: 'ذاكرة التشغيل',
          type: 'select',
          icon: Icons.storage,
          options: [
            {'value': '4gb', 'label': '4 جيجابايت'},
            {'value': '6gb', 'label': '6 جيجابايت'},
            {'value': '8gb', 'label': '8 جيجابايت'},
            {'value': '12gb', 'label': '12 جيجابايت'},
            {'value': '16gb', 'label': '16 جيجابايت'},
          ],
        ),
        CategoryField(
          key: 'storage',
          label: 'مساحة التخزين',
          type: 'select',
          options: [
            {'value': '64gb', 'label': '64 جيجابايت'},
            {'value': '128gb', 'label': '128 جيجابايت'},
            {'value': '256gb', 'label': '256 جيجابايت'},
            {'value': '512gb', 'label': '512 جيجابايت'},
            {'value': '1tb', 'label': '1 تيرابايت'},
          ],
        ),
        CategoryField(
          key: 'display',
          label: 'الشاشة',
          type: 'input',
          placeholder: '6.7 بوصة OLED',
          icon: Icons.phone_android,
        ),
        CategoryField(
          key: 'camera',
          label: 'الكاميرا',
          type: 'input',
          placeholder: '48 ميجابكسل ثلاثية',
          icon: Icons.camera_alt,
        ),
        CategoryField(
          key: 'battery',
          label: 'البطارية',
          type: 'input',
          placeholder: '4422 مللي أمبير',
          icon: Icons.battery_full,
        ),
        CategoryField(
          key: 'os',
          label: 'نظام التشغيل',
          type: 'select',
          options: [
            {'value': 'ios', 'label': 'iOS'},
            {'value': 'android', 'label': 'Android'},
            {'value': 'harmonyos', 'label': 'HarmonyOS'},
          ],
        ),
        CategoryField(
          key: 'network',
          label: 'شبكة الاتصال',
          type: 'select',
          options: [
            {'value': '4g', 'label': '4G LTE'},
            {'value': '5g', 'label': '5G'},
          ],
        ),
      ],
    ),
    ProductCategory(
      id: 'laptops',
      name: 'أجهزة اللابتوب',
      icon: Icons.laptop,
      defaultImage:
          "https://images.unsplash.com/photo-1737868131581-6379cdee4ec3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxsYXB0b3AlMjBjb21wdXRlciUyMHRlY2hub2xvZ3l8ZW58MXx8fHwxNzU4MzQxMDI4fDA&ixlib=rb-4.1.0&q=80&w=1080",
      fields: [
        CategoryField(
          key: 'processor',
          label: 'المعالج',
          type: 'input',
          placeholder: 'Intel Core i7-13700H',
          icon: Icons.memory,
          required: true,
        ),
        CategoryField(
          key: 'ram',
          label: 'ذاكرة التشغيل',
          type: 'select',
          icon: Icons.storage,
          options: [
            {'value': '8gb', 'label': '8 جيجابايت'},
            {'value': '16gb', 'label': '16 جيجابايت'},
            {'value': '32gb', 'label': '32 جيجابايت'},
            {'value': '64gb', 'label': '64 جيجابايت'},
          ],
        ),
        CategoryField(
          key: 'storage',
          label: 'التخزين',
          type: 'select',
          options: [
            {'value': '256gb', 'label': '256 جيجابايت SSD'},
            {'value': '512gb', 'label': '512 جيجابايت SSD'},
            {'value': '1tb', 'label': '1 تيرابايت SSD'},
            {'value': '2tb', 'label': '2 تيرابايت SSD'},
          ],
        ),
        CategoryField(
          key: 'display',
          label: 'الشاشة',
          type: 'input',
          placeholder: '15.6 بوصة FHD',
          icon: Icons.monitor,
        ),
        CategoryField(
          key: 'graphics',
          label: 'كرت الرسومات',
          type: 'input',
          placeholder: 'NVIDIA RTX 4070',
        ),
        CategoryField(
          key: 'os',
          label: 'نظام التشغيل',
          type: 'select',
          options: [
            {'value': 'windows11', 'label': 'Windows 11'},
            {'value': 'macos', 'label': 'macOS'},
            {'value': 'linux', 'label': 'Linux'},
          ],
        ),
        CategoryField(
          key: 'weight',
          label: 'الوزن',
          type: 'input',
          placeholder: '2.1 كيلوجرام',
        ),
        CategoryField(
          key: 'ports',
          label: 'المنافذ',
          type: 'textarea',
          placeholder: 'USB-C, USB 3.0, HDMI, Audio Jack',
        ),
      ],
    ),
    ProductCategory(
      id: 'headphones',
      name: 'سماعات الرأس',
      icon: Icons.headphones,
      defaultImage:
          "https://images.unsplash.com/photo-1632200004922-bc18602c79fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoZWFkcGhvbmVzJTIwd2lyZWxlc3MlMjBhdWRpb3xlbnwxfHx8fDE3NTgyOTY1NDJ8MA&ixlib=rb-4.1.0&q=80&w=1080",
      fields: [
        CategoryField(
          key: 'type',
          label: 'النوع',
          type: 'select',
          options: [
            {'value': 'wireless', 'label': 'لاسلكية'},
            {'value': 'wired', 'label': 'سلكية'},
            {'value': 'true-wireless', 'label': 'لاسلكية بالكامل'},
          ],
          required: true,
        ),
        CategoryField(
          key: 'driver_size',
          label: 'حجم السائق',
          type: 'input',
          placeholder: '40mm',
          icon: Icons.speaker,
        ),
        CategoryField(
          key: 'frequency_response',
          label: 'نطاق التردد',
          type: 'input',
          placeholder: '20Hz - 20kHz',
        ),
        CategoryField(
          key: 'impedance',
          label: 'المقاومة',
          type: 'input',
          placeholder: '32 Ohm',
        ),
        CategoryField(
          key: 'battery_life',
          label: 'عمر البطارية',
          type: 'input',
          placeholder: '30 ساعة',
          icon: Icons.battery_full,
        ),
        CategoryField(
          key: 'noise_cancellation',
          label: 'إلغاء الضوضاء',
          type: 'select',
          options: [
            {'value': 'active', 'label': 'إلغاء نشط'},
            {'value': 'passive', 'label': 'إلغاء سلبي'},
            {'value': 'none', 'label': 'بدون إلغاء'},
          ],
        ),
        CategoryField(
          key: 'connectivity',
          label: 'الاتصال',
          type: 'select',
          icon: Icons.bluetooth,
          options: [
            {'value': 'bluetooth5', 'label': 'Bluetooth 5.0'},
            {'value': 'bluetooth52', 'label': 'Bluetooth 5.2'},
            {'value': 'bluetooth53', 'label': 'Bluetooth 5.3'},
            {'value': 'wired', 'label': 'سلكي فقط'},
          ],
        ),
        CategoryField(
          key: 'microphone',
          label: 'الميكروفون',
          type: 'select',
          options: [
            {'value': 'built-in', 'label': 'مدمج'},
            {'value': 'detachable', 'label': 'قابل للفصل'},
            {'value': 'none', 'label': 'بدون ميكروفون'},
          ],
        ),
      ],
    ),
    ProductCategory(
      id: 'tablets',
      name: 'الأجهزة اللوحية',
      icon: Icons.tablet,
      defaultImage:
          "https://images.unsplash.com/photo-1630042461973-179ca2cfa7bd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0YWJsZXQlMjBkZXZpY2UlMjB0ZWNobm9sb2d5fGVufDF8fHx8MTc1ODI1MTczNHww&ixlib=rb-4.1.0&q=80&w=1080",
      fields: [
        CategoryField(
          key: 'processor',
          label: 'المعالج',
          type: 'input',
          placeholder: 'M2 Chip',
          icon: Icons.memory,
          required: true,
        ),
        CategoryField(
          key: 'ram',
          label: 'ذاكرة التشغيل',
          type: 'select',
          icon: Icons.storage,
          options: [
            {'value': '4gb', 'label': '4 جيجابايت'},
            {'value': '6gb', 'label': '6 جيجابايت'},
            {'value': '8gb', 'label': '8 جيجابايت'},
            {'value': '16gb', 'label': '16 جيجابايت'},
          ],
        ),
        CategoryField(
          key: 'storage',
          label: 'مساحة التخزين',
          type: 'select',
          options: [
            {'value': '64gb', 'label': '64 جيجابايت'},
            {'value': '128gb', 'label': '128 جيجابايت'},
            {'value': '256gb', 'label': '256 جيجابايت'},
            {'value': '512gb', 'label': '512 جيجابايت'},
            {'value': '1tb', 'label': '1 تيرابايت'},
          ],
        ),
        CategoryField(
          key: 'display',
          label: 'الشاشة',
          type: 'input',
          placeholder: '10.9 بوصة Liquid Retina',
          icon: Icons.monitor,
        ),
        CategoryField(
          key: 'camera',
          label: 'الكاميرا',
          type: 'input',
          placeholder: '12 ميجابكسل خلفية',
          icon: Icons.camera_alt,
        ),
        CategoryField(
          key: 'battery_life',
          label: 'عمر البطارية',
          type: 'input',
          placeholder: '10 ساعات',
          icon: Icons.battery_full,
        ),
        CategoryField(
          key: 'connectivity',
          label: 'الاتصال',
          type: 'select',
          icon: Icons.wifi,
          options: [
            {'value': 'wifi', 'label': 'Wi-Fi فقط'},
            {'value': 'cellular', 'label': 'Wi-Fi + Cellular'},
          ],
        ),
        CategoryField(
          key: 'os',
          label: 'نظام التشغيل',
          type: 'select',
          options: [
            {'value': 'ipados', 'label': 'iPadOS'},
            {'value': 'android', 'label': 'Android'},
            {'value': 'windows', 'label': 'Windows'},
          ],
        ),
      ],
    ),
    ProductCategory(
      id: 'smartwatches',
      name: 'الساعات الذكية',
      icon: Icons.watch,
      defaultImage:
          "https://images.unsplash.com/photo-1592647416962-838a003e9859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBzbWFydHBob25lJTIwbW9iaWxlJTIwcGhvbmV8ZW58MXx8fHwxNzU4MzU2NDI1fDA&ixlib=rb-4.1.0&q=80&w=1080",
      fields: [
        CategoryField(
          key: 'display',
          label: 'الشاشة',
          type: 'input',
          placeholder: '1.9 بوصة AMOLED',
          icon: Icons.monitor,
          required: true,
        ),
        CategoryField(
          key: 'battery_life',
          label: 'عمر البطارية',
          type: 'input',
          placeholder: '7 أيام',
          icon: Icons.battery_full,
        ),
        CategoryField(
          key: 'water_resistance',
          label: 'مقاومة الماء',
          type: 'select',
          options: [
            {'value': 'ip67', 'label': 'IP67'},
            {'value': 'ip68', 'label': 'IP68'},
            {'value': '5atm', 'label': '5ATM'},
            {'value': '10atm', 'label': '10ATM'},
          ],
        ),
        CategoryField(
          key: 'health_sensors',
          label: 'أجهزة الاستشعار الصحية',
          type: 'textarea',
          placeholder: 'مراقب نبضات القلب، أكسجين الدم، النوم',
          icon: Icons.favorite,
        ),
        CategoryField(
          key: 'connectivity',
          label: 'الاتصال',
          type: 'select',
          icon: Icons.bluetooth,
          options: [
            {'value': 'bluetooth', 'label': 'Bluetooth'},
            {'value': 'wifi', 'label': 'Wi-Fi + Bluetooth'},
            {'value': 'cellular', 'label': 'Cellular + Wi-Fi + Bluetooth'},
          ],
        ),
        CategoryField(
          key: 'compatibility',
          label: 'التوافق',
          type: 'select',
          options: [
            {'value': 'ios', 'label': 'iOS فقط'},
            {'value': 'android', 'label': 'Android فقط'},
            {'value': 'both', 'label': 'iOS و Android'},
          ],
        ),
        CategoryField(
          key: 'case_material',
          label: 'مادة العلبة',
          type: 'input',
          placeholder: 'ألومنيوم',
        ),
        CategoryField(
          key: 'band_material',
          label: 'مادة السوار',
          type: 'input',
          placeholder: 'سيليكون رياضي',
        ),
      ],
    ),
    ProductCategory(
      id: 'accessories',
      name: 'الإكسسوارات',
      icon: Icons.usb,
      defaultImage:
          "https://images.unsplash.com/photo-1592647416962-838a003e9859?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb2Rlcm4lMjBzbWFydHBob25lJTIwbW9iaWxlJTIwcGhvbmV8ZW58MXx8fHwxNzU4MzU2NDI1fDA&ixlib=rb-4.1.0&q=80&w=1080",
      fields: [
        CategoryField(
          key: 'accessory_type',
          label: 'نوع الإكسسوار',
          type: 'select',
          options: [
            {'value': 'charger', 'label': 'شاحن'},
            {'value': 'cable', 'label': 'كابل'},
            {'value': 'case', 'label': 'حافظة'},
            {'value': 'screen_protector', 'label': 'واقي شاشة'},
            {'value': 'power_bank', 'label': 'بطارية محمولة'},
            {'value': 'stand', 'label': 'حامل'},
            {'value': 'adapter', 'label': 'محول'},
          ],
          required: true,
        ),
        CategoryField(
          key: 'compatibility',
          label: 'التوافق',
          type: 'textarea',
          placeholder: 'متوافق مع iPhone، Samsung Galaxy، وغيرها',
        ),
        CategoryField(
          key: 'material',
          label: 'المادة',
          type: 'input',
          placeholder: 'بلاستيك مقوى، سيليكون',
        ),
        CategoryField(
          key: 'power_output',
          label: 'قوة الخرج (للشواحن)',
          type: 'input',
          placeholder: '20W، 65W',
          icon: Icons.battery_full,
        ),
        CategoryField(
          key: 'cable_length',
          label: 'طول الكابل',
          type: 'input',
          placeholder: '1 متر، 2 متر',
        ),
        CategoryField(
          key: 'features',
          label: 'المميزات الخاصة',
          type: 'textarea',
          placeholder: 'شحن لاسلكي، مقاوم للصدمات، مضاد للبكتيريا',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _formData = ProductFormData();
  }

  void _handleInputChange(String field, String value) {
    setState(() {
      switch (field) {
        case 'name':
          _formData.name = value;
          break;
        case 'brand':
          _formData.brand = value;
          break;
        case 'model':
          _formData.model = value;
          break;
        case 'price':
          _formData.price = value;
          break;
        case 'currency':
          _formData.currency = value;
          break;
        case 'description':
          _formData.description = value;
          break;
        case 'category':
          _formData.category = value;
          try {
            _selectedCategory =
                _productCategories.firstWhere((cat) => cat.id == value);
          } catch (e) {
            print('⚠️ لم يتم العثور على الفئة: $value');
            _selectedCategory = null;
          }
          _formData.specifications = {};
          break;
        case 'color':
          _formData.color = value;
          break;
        case 'warranty':
          _formData.warranty = value;
          break;
        case 'availability':
          _formData.availability = value;
          break;
        case 'discount':
          _formData.discount = value;
          break;
        case 'stock':
          _formData.stock = value;
          break;
      }
    });
  }

  void _handleSpecificationChange(String key, String value) {
    setState(() {
      _formData.specifications[key] = value;
    });
  }

  void _addTag() {
    if (_newTag.trim().isNotEmpty && !_formData.tags.contains(_newTag.trim())) {
      setState(() {
        _formData.tags = [..._formData.tags, _newTag.trim()];
        _newTag = '';
      });
    }
  }

  void _removeTag(String tagToRemove) {
    setState(() {
      _formData.tags =
          _formData.tags.where((tag) => tag != tagToRemove).toList();
    });
  }

  Future<void> _addImage() async {
    try {
      final imageUrl = await ImageUploadService.pickAndUploadSingleImage(
        context,
        folder: 'gizmo_store/products',
      );

      if (imageUrl != null) {
        setState(() {
          _formData.images = [..._formData.images, imageUrl];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في رفع الصورة: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _formData.images.removeAt(index);
    });
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final productData = {
        'name': _formData.name,
        'brand': _formData.brand,
        'model': _formData.model,
        'price': double.tryParse(_formData.price) ?? 0.0,
        'currency': _formData.currency,
        'description': _formData.description,
        'category': _formData.category,
        'color': _formData.color,
        'warranty': _formData.warranty,
        'availability': _formData.availability,
        'discount': double.tryParse(_formData.discount) ?? 0.0,
        'stock': int.tryParse(_formData.stock) ?? 0,
        'featured': _formData.featured,
        'tags': _formData.tags,
        'images': _formData.images,
        // إضافة الصورة الرئيسية (أول صورة من القائمة)
        'image': _formData.images.isNotEmpty ? _formData.images.first : null,
        'imageUrl': _formData.images.isNotEmpty ? _formData.images.first : null,
        'specifications': _formData.specifications,
        'isAvailable': _formData.availability == 'متوفر',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('products').add(productData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ المنتج بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في حفظ المنتج: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSpecificationField(CategoryField field) {
    final value = _formData.specifications[field.key] ?? '';

    if (field.type == 'select') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (field.icon != null) Icon(field.icon, size: 16),
              if (field.icon != null) const SizedBox(width: 8),
              Text(field.label),
              if (field.required)
                const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value.isEmpty ? null : value,
            decoration: InputDecoration(
              hintText: 'اختر ${field.label}',
              border: const OutlineInputBorder(),
            ),
            items: field.options?.map((option) {
              return DropdownMenuItem<String>(
                value: option['value'],
                child: Text(option['label']!),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                _handleSpecificationChange(field.key, newValue);
              }
            },
            validator: field.required
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  }
                : null,
          ),
        ],
      );
    }

    if (field.type == 'textarea') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (field.icon != null) Icon(field.icon, size: 16),
              if (field.icon != null) const SizedBox(width: 8),
              Text(field.label),
              if (field.required)
                const Text(' *', style: TextStyle(color: Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: value,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: field.placeholder,
              border: const OutlineInputBorder(),
            ),
            onChanged: (newValue) =>
                _handleSpecificationChange(field.key, newValue),
            validator: field.required
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  }
                : null,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (field.icon != null) Icon(field.icon, size: 16),
            if (field.icon != null) const SizedBox(width: 8),
            Text(field.label),
            if (field.required)
              const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            hintText: field.placeholder,
            border: const OutlineInputBorder(),
          ),
          onChanged: (newValue) =>
              _handleSpecificationChange(field.key, newValue),
          validator: field.required
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.add_box),
            SizedBox(width: 8),
            Text('إضافة منتج جديد'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // اختيار فئة المنتج
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.category),
                          SizedBox(width: 8),
                          Text('فئة المنتج',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _productCategories.length,
                        itemBuilder: (context, index) {
                          final category = _productCategories[index];
                          final isSelected = _formData.category == category.id;

                          return GestureDetector(
                            onTap: () =>
                                _handleInputChange('category', category.id),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: isSelected
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1)
                                    : null,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(category.icon,
                                      size: 32,
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : null),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              if (_formData.category.isNotEmpty) ...[
                const SizedBox(height: 16),

                // المعلومات الأساسية
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info),
                            SizedBox(width: 8),
                            Text('المعلومات الأساسية',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'اسم المنتج *',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) =>
                                  _handleInputChange('name', value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'هذا الحقل مطلوب';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'العلامة التجارية',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) =>
                                  _handleInputChange('brand', value),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'رقم الطراز',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) =>
                                  _handleInputChange('model', value),
                            ),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'اللون',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'black', child: Text('أسود')),
                                DropdownMenuItem(
                                    value: 'white', child: Text('أبيض')),
                                DropdownMenuItem(
                                    value: 'blue', child: Text('أزرق')),
                                DropdownMenuItem(
                                    value: 'gold', child: Text('ذهبي')),
                                DropdownMenuItem(
                                    value: 'silver', child: Text('فضي')),
                                DropdownMenuItem(
                                    value: 'red', child: Text('أحمر')),
                                DropdownMenuItem(
                                    value: 'green', child: Text('أخضر')),
                                DropdownMenuItem(
                                    value: 'purple', child: Text('بنفسجي')),
                              ],
                              onChanged: (value) =>
                                  _handleInputChange('color', value ?? ''),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // السعر والتوفر
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.attach_money),
                            SizedBox(width: 8),
                            Text('السعر والتوفر',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          childAspectRatio: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'السعر *',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  _handleInputChange('price', value),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'هذا الحقل مطلوب';
                                }
                                return null;
                              },
                            ),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'العملة',
                                border: OutlineInputBorder(),
                              ),
                              value: _formData.currency,
                              items: const [
                                DropdownMenuItem(
                                    value: 'ج.س', child: Text('جنيه سوداني')),
                                DropdownMenuItem(
                                    value: 'ريال', child: Text('ريال سعودي')),
                                DropdownMenuItem(
                                    value: 'درهم', child: Text('درهم إماراتي')),
                                DropdownMenuItem(
                                    value: 'دولار',
                                    child: Text('دولار أمريكي')),
                                DropdownMenuItem(
                                    value: 'يورو', child: Text('يورو')),
                              ],
                              onChanged: (value) =>
                                  _handleInputChange('currency', value ?? ''),
                            ),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'حالة التوفر',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'available', child: Text('متوفر')),
                                DropdownMenuItem(
                                    value: 'limited',
                                    child: Text('مخزون محدود')),
                                DropdownMenuItem(
                                    value: 'preorder', child: Text('طلب مسبق')),
                                DropdownMenuItem(
                                    value: 'outofstock',
                                    child: Text('نفد المخزون')),
                              ],
                              onChanged: (value) => _handleInputChange(
                                  'availability', value ?? ''),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'نسبة الخصم %',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  _handleInputChange('discount', value),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'الكمية المتوفرة',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) =>
                                  _handleInputChange('stock', value),
                            ),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'فترة الضمان',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: '6months', child: Text('6 أشهر')),
                                DropdownMenuItem(
                                    value: '1year', child: Text('سنة واحدة')),
                                DropdownMenuItem(
                                    value: '2years', child: Text('سنتان')),
                                DropdownMenuItem(
                                    value: '3years', child: Text('ثلاث سنوات')),
                                DropdownMenuItem(
                                    value: '5years', child: Text('خمس سنوات')),
                              ],
                              onChanged: (value) =>
                                  _handleInputChange('warranty', value ?? ''),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // المواصفات التقنية
                if (_selectedCategory != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_selectedCategory!.icon),
                              const SizedBox(width: 8),
                              Text(
                                  'المواصفات التقنية - ${_selectedCategory!.name}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            children: _selectedCategory!.fields
                                .map(_buildSpecificationField)
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // وصف المنتج
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('وصف المنتج',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        TextFormField(
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText:
                                'أدخل وصفاً مفصلاً عن المنتج وميزاته الرئيسية...',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) =>
                              _handleInputChange('description', value),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // العلامات
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('العلامات (Tags)',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'أضف علامة جديدة',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) => _newTag = value,
                                onFieldSubmitted: (_) => _addTag(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _addTag,
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        if (_formData.tags.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _formData.tags.map((tag) {
                              return Chip(
                                label: Text(tag),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => _removeTag(tag),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // صور المنتج
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('صور المنتج',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: _formData.images.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _formData.images.length) {
                              return GestureDetector(
                                onTap: _addImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload, size: 32),
                                      SizedBox(height: 8),
                                      Text('رفع صورة',
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageHelper.buildCachedImage(
                                    imageUrl: _formData.images[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // أزرار الحفظ
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveProduct,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('حفظ المنتج'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
