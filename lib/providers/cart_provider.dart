import 'package:flutter/foundation.dart';

// Define the CartItem model
class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  // Method to add an item to the cart
  void addItem(String productId, String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      // Increment quantity if item already exists
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
        ),
      );
    } else {
      // Add new item to the cart using map assignment
      _items[productId] = CartItem(
        id: productId,
        title: title,
        quantity: 1,
        price: price,
        imageUrl: imageUrl,
      );
    }
    notifyListeners();
  }

  // Method to remove one quantity of an item or the whole item
  void removeItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    final existingItem = _items[productId]!;
    if (existingItem.quantity > 1) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity - 1,
          price: value.price,
          imageUrl: value.imageUrl,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Method to delete an item completely from the cart
  void deleteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Method to clear the entire cart
  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
