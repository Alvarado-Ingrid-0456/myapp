
import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Camisa Elegante',
      description: 'Una camisa de alta calidad para ocasiones especiales.',
      price: 49.99,
      imageUrl: 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Shirt',
    ),
    Product(
      id: 'p2',
      title: 'Pantalón Vaquero',
      description: 'Pantalón vaquero clásico y cómodo.',
      price: 35.50,
      imageUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?text=Pants',
    ),
    Product(
      id: 'p3',
      title: 'Zapatos Deportivos',
      description: 'Zapatos perfectos para correr o entrenar.',
      price: 75.00,
      imageUrl: 'https://via.placeholder.com/150/00FF00/FFFFFF?text=Shoes',
    ),
    Product(
      id: 'p4',
      title: 'Chaqueta de Cuero',
      description: 'Chaqueta moderna y resistente.',
      price: 120.00,
      imageUrl: 'https://via.placeholder.com/150/FFFF00/000000?text=Jacket',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product? findById(String id) {
    try {
      return _items.firstWhere((prod) => prod.id == id);
    } catch (e) {
      return null;
    }
  }

  void addProduct() {
    // TODO: Implement add product logic
    notifyListeners();
  }
}
