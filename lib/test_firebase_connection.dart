// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'firebase_options.dart';

// class FirebaseConnectionTest extends StatefulWidget {
//   const FirebaseConnectionTest({super.key});

//   @override
//   State<FirebaseConnectionTest> createState() => _FirebaseConnectionTestState();
// }

// class _FirebaseConnectionTestState extends State<FirebaseConnectionTest> {
//   String _status = 'جاري التحقق من الاتصال...';
//   bool _isLoading = true;
//   List<String> _testResults = [];

//   @override
//   void initState() {
//     super.initState();
//     _testFirebaseConnection();
//   }

//   Future<void> _testFirebaseConnection() async {
//     List<String> results = [];

//     try {
//       // 1. اختبار تهيئة Firebase
//       results.add('✅ Firebase تم تهيئته بنجاح');

//       // 2. اختبار Firestore
//       try {
//         final firestore = FirebaseFirestore.instance;
//         await firestore.collection('test').doc('connection').set({
//           'timestamp': FieldValue.serverTimestamp(),
//           'message': 'اختبار الاتصال',
//         });
//         results.add('✅ Firestore متصل ويعمل بشكل صحيح');

//         // قراءة البيانات للتأكد
//         final doc = await firestore.collection('test').doc('connection').get();
//         if (doc.exists) {
//           results.add('✅ قراءة البيانات من Firestore تمت بنجاح');
//         }
//       } catch (e) {
//         results.add('❌ خطأ في Firestore: $e');
//       }

//       // 3. اختبار Firebase Auth
//       try {
//         final auth = FirebaseAuth.instance;
//         results.add('✅ Firebase Auth جاهز');

//         // اختبار تسجيل دخول مجهول
//         try {
//           await auth.signInAnonymously();
//           results.add('✅ تسجيل الدخول المجهول يعمل');
//           await auth.signOut();
//           results.add('✅ تسجيل الخروج يعمل');
//         } catch (e) {
//           results.add('⚠️ تسجيل الدخول المجهول: $e');
//         }
//       } catch (e) {
//         results.add('❌ خطأ في Firebase Auth: $e');
//       }

//       // 4. اختبار جلب التصنيفات
//       try {
//         final categories = await FirebaseFirestore.instance
//             .collection('categories')
//             .limit(1)
//             .get();
//         if (categories.docs.isNotEmpty) {
//           results.add('✅ مجموعة التصنيفات موجودة');
//         } else {
//           results.add('⚠️ مجموعة التصنيفات فارغة');
//         }
//       } catch (e) {
//         results.add('❌ خطأ في جلب التصنيفات: $e');
//       }

//       // 5. اختبار جلب المنتجات
//       try {
//         final products = await FirebaseFirestore.instance
//             .collection('products')
//             .limit(1)
//             .get();
//         if (products.docs.isNotEmpty) {
//           results.add('✅ مجموعة المنتجات موجودة');
//         } else {
//           results.add('⚠️ مجموعة المنتجات فارغة');
//         }
//       } catch (e) {
//         results.add('❌ خطأ في جلب المنتجات: $e');
//       }

//       setState(() {
//         _testResults = results;
//         _status = 'اكتمل الاختبار';
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _testResults = ['❌ خطأ عام في Firebase: $e'];
//         _status = 'فشل الاختبار';
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _addSampleData() async {
//     try {
//       final sampleDataService = SampleDataService();
//       await sampleDataService.addAllSampleData(context);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text(
//                   'تم إضافة جميع البيانات التجريبية بنجاح! (منتجات كثيرة مع صور)')),
//         );

//         // إعادة تشغيل الاختبار
//         setState(() {
//           _isLoading = true;
//           _testResults = [];
//         });
//         _testFirebaseConnection();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('خطأ في إضافة البيانات: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('اختبار اتصال Firebase'),
//         backgroundColor: Color(0xFFB71C1C),
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'حالة الاتصال: $_status',
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10),
//                     if (_isLoading)
//                       const Center(child: CircularProgressIndicator())
//                     else
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: _testResults
//                             .map((result) => Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 2),
//                                   child: Text(result,
//                                       style: const TextStyle(fontSize: 14)),
//                                 ))
//                             .toList(),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (!_isLoading)
//               Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isLoading = true;
//                         _testResults = [];
//                       });
//                       _testFirebaseConnection();
//                     },
//                     child: const Text('إعادة الاختبار'),
//                   ),
//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: _addSampleData,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFFB71C1C),
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text('إضافة بيانات تجريبية'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
