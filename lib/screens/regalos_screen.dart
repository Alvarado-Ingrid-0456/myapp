import 'package:flutter/material.dart';

// Dummy data for gift items
final List<Map<String, dynamic>> _giftItems = [
  {
    'id': 'g1',
    'name': 'Taza Personalizada con Foto',
    'description': 'Un regalo único con tu foto favorita.',
    'price': 18.00,
    'imageUrl': 'https://picsum.photos/seed/gift1/200/300',
  },
  {
    'id': 'g2',
    'name': 'Marco de Fotos Digital Inteligente',
    'description': 'Muestra tus recuerdos en alta definición.',
    'price': 75.00,
    'imageUrl': 'https://picsum.photos/seed/gift2/200/300',
  },
  {
    'id': 'g3',
    'name': 'Set de Velas Aromáticas Artesanales',
    'description': 'Crea un ambiente relajante con fragancias naturales.',
    'price': 26.00,
    'imageUrl': 'https://picsum.photos/seed/gift3/200/300',
  },
];

class RegalosScreen extends StatelessWidget {
  const RegalosScreen({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regalos Personalizados'),
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
        itemCount: _giftItems.length,
        itemBuilder: (ctx, i) {
          final item = _giftItems[i];
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
                      content: Text('Viewing details for ${item['name']}')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Item Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(item['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child:
                          item['imageUrl'] == null || item['imageUrl'].isEmpty
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
                            item['name'].toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '\$${item['price'].toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.green),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['description'].toString(),
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
      // Removed the bottom navigation bar to avoid the 'bottom' named parameter error
      // The navigation is now handled by the drawer.
    );
  }
}
