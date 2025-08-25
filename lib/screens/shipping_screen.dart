
import 'package:flutter/material.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الشحن'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('الشحن العادي'),
            subtitle: const Text('يستغرق من 5-7 أيام عمل'),
            trailing: Radio(value: 'standard', groupValue: 'shipping', onChanged: (value) {}),
          ),
          ListTile(
            title: const Text('الشحن السريع'),
            subtitle: const Text('يستغرق من 2-3 أيام عمل'),
            trailing: Radio(value: 'express', groupValue: 'shipping', onChanged: (value) {}),
          ),
          ListTile(
            title: const Text('الشحن في نفس اليوم'),
            subtitle: const Text('يصلك طلبك في نفس اليوم'),
            trailing: Radio(value: 'same_day', groupValue: 'shipping', onChanged: (value) {}),
          ),
        ],
      ),
    );
  }
}
