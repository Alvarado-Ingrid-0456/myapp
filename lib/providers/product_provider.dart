import 'package:flutter/foundation.dart';

// Dummy Product model
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class ProductProvider with ChangeNotifier {
  // Dummy product data
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Laptop Moderna',
      description: 'Una laptop potente y ligera para profesionales.',
      price: 1200.00,
      imageUrl:
          'https://via.placeholder.com/150/0000FF/FFFFFF?text=Laptop', // Example URL
    ),
    Product(
      id: 'p2',
      title: 'Smartphone Avanzado',
      description: 'El último smartphone con cámara de alta resolución.',
      price: 800.00,
      imageUrl:
          'https://via.placeholder.com/150/FF0000/FFFFFF?text=Smartphone', // Example URL
    ),
    Product(
      id: 'p3',
      title: 'Auriculares Inalámbricos',
      description: 'Sonido de alta fidelidad y cancelación de ruido.',
      price: 150.00,
      imageUrl:
          'https://via.placeholder.com/150/00FF00/FFFFFF?text=Auriculares', // Example URL
    ),
    Product(
      id: 'p4',
      title: 'Smartwatch Elegante',
      description: 'Monitoriza tu salud y mantente conectado con estilo.',
      price: 250.00,
      imageUrl:
          'https://via.placeholder.com/150/FFFF00/000000?text=Smartwatch', // Example URL
    ),
    Product(
      id: 'p5',
      title: 'Tablet Versátil',
      description: 'Ideal para trabajar, estudiar y entretenerte.',
      price: 400.00,
      imageUrl:
          'https://via.placeholder.com/150/FFA500/FFFFFF?text=Tablet', // Example URL
    ),
    Product(
      id: 'p6',
      title: 'Cámara Profesional',
      description: 'Captura momentos con calidad profesional.',
      price: 950.00,
      imageUrl:
          'https://via.placeholder.com/150/800080/FFFFFF?text=Camera', // Example URL
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // You can add methods to add, update, or delete products if needed
}
