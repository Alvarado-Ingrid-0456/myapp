import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/providers/cart_provider.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing both ProductProvider and CartProvider
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final products = productProvider.items; // Get the list of products

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        centerTitle: true,
        actions: <Widget>[
          // IconButton to navigate to the cart screen
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Ver Carrito',
            onPressed: () {
              Navigator.of(context).pushNamed(
                  '/cart'); // Assuming '/cart' is the route for CartScreen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 10.0, // Horizontal space between items
            mainAxisSpacing: 10.0, // Vertical space between items
            childAspectRatio: 0.75, // Aspect ratio of each item (width/height)
          ),
          itemCount: products.length,
          itemBuilder: (ctx, index) {
            final product = products[index];
            return GridTile(
              header: GridTileBar(
                backgroundColor: Colors.black
                    .withOpacity(0.4), // Deprecated withOpacity replaced
                title: Text(
                  product.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black
                    .withOpacity(0.6), // Deprecated withOpacity replaced
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Add to Cart button
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      color: Theme.of(context).colorScheme.secondary,
                      tooltip: 'Agregar al Carrito',
                      onPressed: () {
                        // Call addItem with product details as positional arguments
                        cartProvider.addItem(
                          product.id,
                          product.title,
                          product.price,
                          product.imageUrl,
                        );
                        // Show a confirmation snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('"${product.title}" agregado al carrito.'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Ver Carrito',
                              onPressed: () {
                                Navigator.of(context).pushNamed('/cart');
                              },
                            ),
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigate to product detail screen, passing the product ID
                  Navigator.of(context).pushNamed(
                    '/product-detail', // Assuming '/product-detail' is the route
                    arguments: product.id, // Pass the product ID as an argument
                  );
                },
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 50), // Handle image loading errors
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
