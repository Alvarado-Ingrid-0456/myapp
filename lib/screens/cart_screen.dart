
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:myapp/providers/cart_provider.dart'; // Import CartProvider
import 'package:myapp/widgets/cart_item.dart'; // Assuming CartItem widget is in this path

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // Access CartProvider using Provider.of
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.payment),
            onPressed: () {
              if (cart.itemCount > 0) {
                Navigator.of(context).pushNamed('/payment');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('El carrito está vacío. Agrega productos antes de pagar.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            tooltip: 'Pagar',
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    // Use Consumer for efficient rebuilding of the Chip when totalAmount changes
                    child: Consumer<CartProvider>(
                      builder: (ctx, cartProvider, _) => Text(
                        '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: cart.itemCount > 0
                        ? () {
                            Navigator.of(context).pushNamed('/payment');
                          }
                        : null, // Disable button if cart is empty
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Ordenar ahora'),
                  ),
                ],
              ),
            ),
          ),
          // Display cart items if any, otherwise show a message
          if (cart.itemCount > 0)
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) {
                  // Use the CartItem widget for each item in the cart
                  final cartItem = cart.items.values.toList()[index];
                  return CartItem(
                    id: cartItem.id,
                    productId: cartItem.productId, // Pass productId
                    title: cartItem.title,
                    quantity: cartItem.quantity,
                    price: cartItem.price,
                  );
                },
              ),
            )
          else
            const Expanded(
              child: Center(
                child: Text(
                  'Tu carrito está vacío.\n¡Empieza a comprar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
