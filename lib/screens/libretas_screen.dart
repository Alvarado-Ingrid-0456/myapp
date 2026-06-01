import 'package:flutter/material.dart';

// Dummy data for notebooks
final List<Map<String, dynamic>> _notebooks = [
  {
    'id': 'nb1',
    'name': 'Cuaderno Clásico A5',
    'description': 'Tapa dura, 100 hojas rayadas.',
    'price': 15.00,
    'imageUrl': 'https://picsum.photos/seed/notebook1/200/300',
  },
  {
    'id': 'nb2',
    'name': 'Libreta de Bocetos Profesional',
    'description': 'Papel grueso, ideal para lápiz y carboncillo.',
    'price': 20.00,
    'imageUrl': 'https://picsum.photos/seed/notebook2/200/300',
  },
  {
    'id': 'nb3',
    'name': 'Agenda Ejecutiva 2024',
    'description': 'Diseño moderno, con planificador semanal y mensual.',
    'price': 25.00,
    'imageUrl': 'https://picsum.photos/seed/notebook3/200/300',
  },
];

class LibretasScreen extends StatelessWidget {
  const LibretasScreen({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libretas y Agendas'),
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
        itemCount: _notebooks.length,
        itemBuilder: (ctx, i) {
          final notebook = _notebooks[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                // Navigate to a product detail screen or show a modal
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Viewing details for ${notebook['name']}')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Notebook Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(notebook['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: notebook['imageUrl'] == null ||
                              notebook['imageUrl'].isEmpty
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
                            notebook['name'].toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '\$${notebook['price'].toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.green),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notebook['description'].toString(),
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
