import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() => _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة العناوين'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('addresses')
            .orderBy('isDefault', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('خطأ في تحميل العناوين: ${snapshot.error}'),
            );
          }

          final addresses = snapshot.data?.docs ?? [];

          if (addresses.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              final data = address.data() as Map<String, dynamic>;
              return _buildAddressCard(address.id, data);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(),
        backgroundColor: Color(0xFFB71C1C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد عناوين محفوظة',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أضف عنوانك الأول للبدء',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddAddressDialog(),
            icon: const Icon(Icons.add),
            label: const Text('إضافة عنوان جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(String addressId, Map<String, dynamic> data) {
    final isDefault = data['isDefault'] ?? false;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data['title'] ?? 'عنوان',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'افتراضي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditAddressDialog(addressId, data);
                        break;
                      case 'default':
                        _setAsDefault(addressId);
                        break;
                      case 'delete':
                        _deleteAddress(addressId);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('تعديل'),
                        ],
                      ),
                    ),
                    if (!isDefault)
                      const PopupMenuItem(
                        value: 'default',
                        child: Row(
                          children: [
                            Icon(Icons.star, size: 20),
                            SizedBox(width: 8),
                            Text('جعل افتراضي'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('حذف', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data['fullAddress'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            if (data['phone'] != null && data['phone'].toString().isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    data['phone'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog() {
    _showAddressDialog();
  }

  void _showEditAddressDialog(String addressId, Map<String, dynamic> data) {
    _showAddressDialog(addressId: addressId, addressData: data);
  }

  void _showAddressDialog({String? addressId, Map<String, dynamic>? addressData}) {
    final titleController = TextEditingController(
      text: addressData?['title'] ?? '',
    );
    final addressController = TextEditingController(
      text: addressData?['fullAddress'] ?? '',
    );
    final phoneController = TextEditingController(
      text: addressData?['phone'] ?? '',
    );
    bool isDefault = addressData?['isDefault'] ?? false;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(addressId == null ? 'إضافة عنوان جديد' : 'تعديل العنوان'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'اسم العنوان (مثل: المنزل، العمل)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.label),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال اسم العنوان';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان الكامل',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                    hintText: 'مثال: شارع الملك فهد، الرياض، المملكة العربية السعودية',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'يرجى إدخال العنوان الكامل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'رقم الهاتف (اختياري)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('تعيين كعنوان افتراضي'),
                  value: isDefault,
                  onChanged: (value) {
                    setState(() {
                      isDefault = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _saveAddress(
                    addressId: addressId,
                    title: titleController.text.trim(),
                    fullAddress: addressController.text.trim(),
                    phone: phoneController.text.trim(),
                    isDefault: isDefault,
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB71C1C),
                foregroundColor: Colors.white,
              ),
              child: Text(addressId == null ? 'إضافة' : 'حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAddress({
    String? addressId,
    required String title,
    required String fullAddress,
    required String phone,
    required bool isDefault,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final addressData = {
        'title': title,
        'fullAddress': fullAddress,
        'phone': phone,
        'isDefault': isDefault,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (isDefault) {
        // إزالة الافتراضي من العناوين الأخرى
        final batch = _firestore.batch();
        final existingAddresses = await _firestore
            .collection('users')
            .doc(userId)
            .collection('addresses')
            .where('isDefault', isEqualTo: true)
            .get();

        for (final doc in existingAddresses.docs) {
          batch.update(doc.reference, {'isDefault': false});
        }

        await batch.commit();
      }

      if (addressId == null) {
        // إضافة عنوان جديد
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('addresses')
            .add(addressData);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة العنوان بنجاح')),
          );
        }
      } else {
        // تحديث عنوان موجود
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('addresses')
            .doc(addressId)
            .update(addressData);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث العنوان بنجاح')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في حفظ العنوان: $e')),
        );
      }
    }
  }

  Future<void> _setAsDefault(String addressId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final batch = _firestore.batch();
      
      // إزالة الافتراضي من جميع العناوين
      final existingAddresses = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .where('isDefault', isEqualTo: true)
          .get();

      for (final doc in existingAddresses.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }

      // جعل العنوان المحدد افتراضي
      batch.update(
        _firestore.collection('users').doc(userId).collection('addresses').doc(addressId),
        {'isDefault': true},
      );

      await batch.commit();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تعيين العنوان كافتراضي')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تعيين العنوان: $e')),
        );
      }
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا العنوان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final userId = _auth.currentUser?.uid;
        if (userId == null) return;

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('addresses')
            .doc(addressId)
            .delete();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف العنوان بنجاح')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ في حذف العنوان: $e')),
          );
        }
      }
    }
  }
}