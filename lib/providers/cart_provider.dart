
import 'package:flutter/material.dart';

// Represents a single item entry within the shopping cart
class CartItem {
  final String id; // Unique identifier for this cart entry
  final String productId; // Reference to the product's ID
  final String title;
  final int quantity; // Number of this item in the cart
  final double price; // Price per unit of the item
  final String imageUrl; // URL of the product's image

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    this.imageUrl = '', // Default to empty string if no image URL is provided
  });
}

// Manages the state of the shopping cart
class CartProvider with ChangeNotifier {
  // Use a Map to store CartItem objects, keyed by productId for easy access and updates
  Map<String, CartItem> _items = {};

  // Getter to return a copy of the current cart items
  Map<String, CartItem> get items {
    return {..._items}; // Return a copy to prevent external modifications
  }

  // Getter for the count of unique item types in the cart
  int get itemCount {
    return _items.length;
  }

  // Getter to calculate the total cost of all items in the cart
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      // Sum up the price multiplied by quantity for each item
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // Method to add an item to the cart
  void addItem({
    required String productId,
    required double price,
    required String title,
    String imageUrl = '',
  }) {
    if (_items.containsKey(productId)) {
      // If the product is already in the cart, increment its quantity
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1, // Increment quantity
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl, // Maintain existing image URL
        ),
      );
    } else {
      // If it's a new product, add it to the cart with quantity 1
      _items.putIfAbsent(
        productId,
        () => CartItem(
          // Generate a unique ID for this cart entry (e.g., timestamp + productId)
          id: DateTime.now().toIso8601String() + '_' + productId,
          productId: productId,
          title: title,
          quantity: 1,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners(); // Notify listeners about the state change
  }

  // Method to remove an item completely from the cart using its productId
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Method to decrease the quantity of an item by one, or remove if quantity becomes 0
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return; // Exit if the item is not in the cart
    }
    final existingItem = _items[productId]!;
    if (existingItem.quantity > 1) {
      // If quantity is greater than 1, decrement it
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          productId: value.productId,
          title: value.title,
          quantity: value.quantity - 1,
          price: value.price,
          imageUrl: value.imageUrl,
        ),
      );
    } else {
      // If quantity is 1, remove the item entirely from the cart
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Method to clear all items from the cart
  void clear() {
    _items = {}; // Reset the items map to empty
    notifyListeners();
  }
}
