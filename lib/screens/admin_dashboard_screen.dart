import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _dashboardCard(
                context, Icons.table_chart, 'Manage Tables', '/admin_tables'),
            const SizedBox(height: 20),
            _dashboardCard(context, Icons.people, 'Manage Users',
                '/admin_users'), // Assuming /admin_users route exists
            const SizedBox(height: 20),
            _dashboardCard(context, Icons.settings, 'Settings',
                '/admin_settings'), // Assuming /admin_settings route exists
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(
      BuildContext context, IconData icon, String title, String route) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use minimum space
            children: [
              Icon(
                icon,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
