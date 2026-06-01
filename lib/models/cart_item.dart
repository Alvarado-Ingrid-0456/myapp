class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl; // Added imageUrl

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}
