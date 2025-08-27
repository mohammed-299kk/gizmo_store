import 'package:flutter/material.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              icon: Icons.add,
              title: 'Add Product',
              subtitle: 'Add a new product to store',
              color: Colors.green,
              onTap: () {
                // Navigate to add product
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              icon: Icons.category,
              title: 'Manage Categories',
              subtitle: 'Add or edit categories',
              color: Colors.blue,
              onTap: () {
                // Navigate to categories
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              icon: Icons.people,
              title: 'View Users',
              subtitle: 'Manage user accounts',
              color: Colors.orange,
              onTap: () {
                // Navigate to users
              },
            ),
            const SizedBox(height: 12),
            _buildActionButton(
              icon: Icons.analytics,
              title: 'View Reports',
              subtitle: 'Sales and analytics',
              color: Colors.purple,
              onTap: () {
                // Navigate to reports
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
