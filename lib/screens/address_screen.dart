
import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العناوين'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Add new address
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('المنزل'),
            subtitle: const Text('شارع الملك فهد، الرياض، المملكة العربية السعودية'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Edit address
              },
            ),
          ),
          ListTile(
            title: const Text('العمل'),
            subtitle: const Text('طريق الملك عبدالله، الرياض، المملكة العربية السعودية'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Edit address
              },
            ),
          ),
        ],
      ),
    );
  }
}
