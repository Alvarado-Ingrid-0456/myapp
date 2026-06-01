import 'package:flutter/material.dart';

class AdminTablesScreen extends StatefulWidget {
  const AdminTablesScreen({super.key}); // Use super.key

  @override
  State<AdminTablesScreen> createState() => _AdminTablesScreenState();
}

class _AdminTablesScreenState extends State<AdminTablesScreen> {
  // Dummy data for tables
  final List<Map<String, dynamic>> _tables = [
    {'name': 'Users', 'count': 150, 'lastUpdated': '2023-10-26'},
    {'name': 'Products', 'count': 300, 'lastUpdated': '2023-10-25'},
    {'name': 'Orders', 'count': 75, 'lastUpdated': '2023-10-26'},
    {'name': 'Categories', 'count': 20, 'lastUpdated': '2023-10-24'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tables'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _tables.length,
        itemBuilder: (ctx, index) {
          final table = _tables[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: InkWell(
              onTap: () {
                // Navigate to a detailed view of the table
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Viewing details for ${table['name']}')),
                );
              },
              borderRadius: BorderRadius.circular(12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.table_view, // Generic table icon
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            table['name'].toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Records: ${table['count']}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Last Updated: ${table['lastUpdated']}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
