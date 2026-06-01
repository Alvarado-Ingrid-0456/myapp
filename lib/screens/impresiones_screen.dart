import 'package:flutter/material.dart';

// Dummy data for printing services
final List<Map<String, dynamic>> _printingServices = [
  {
    'id': 'p1',
    'name': 'Impresión Digital Full Color',
    'description': 'Ideal para folletos, tarjetas y volantes.',
    'price': 50.0,
    'imageUrl': 'https://picsum.photos/seed/print1/200/300',
  },
  {
    'id': 'p2',
    'name': 'Impresión Offset Gran Formato',
    'description': 'Para tiradas largas de catálogos, revistas y afiches.',
    'price': 150.0,
    'imageUrl': 'https://picsum.photos/seed/print2/200/300',
  },
  {
    'id': 'p3',
    'name': 'Impresión 3D Personalizada',
    'description': 'Crea prototipos y modelos únicos a medida.',
    'price': 75.0,
    'imageUrl': 'https://picsum.photos/seed/print3/200/300',
  },
];

class ImpresionesScreen extends StatelessWidget {
  const ImpresionesScreen({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios de Impresión'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _printingServices.length,
        itemBuilder: (ctx, i) {
          final service = _printingServices[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                // Navigate to a service detail screen or show a modal
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Viewing details for ${service['name']}')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Service Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(service['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Using Placeholder for image to avoid direct network calls if not needed.
                      // In a real app, use CachedNetworkImage for better performance.
                      child: service['imageUrl'] == null ||
                              service['imageUrl'].isEmpty
                          ? Icon(Icons.image_not_supported,
                              color: Colors.grey[400])
                          : null,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['name'].toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '\$${service['price'].toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.green),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service['description'].toString(),
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
