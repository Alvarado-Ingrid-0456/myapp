import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  // The product ID is passed as an argument when navigating to this screen
  // final String productId;
  // const ProductDetailScreen({super.key, required this.productId});

  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Retrieve the product ID passed as an argument
    final productId = ModalRoute.of(context)?.settings.arguments as String;

    // Access ProductProvider to find the product details using the ID
    // We use 'read' here because we only need to get the product data, not listen for changes.
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final loadedProduct =
        productProvider.items.firstWhere((prod) => prod.id == productId);

    // Access CartProvider to add the product to the cart
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Ver Carrito',
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/cart'); // Navigate to the cart screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Product Image
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              width: double.infinity,
              height: 250,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 100), // Handle image loading errors
              ),
            ),
            const SizedBox(height: 10),

            // Product Title and Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      loadedProduct.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${loadedProduct.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Product Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 16),
                softWrap: true,
              ),
            ),
            const SizedBox(height: 30),

            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al Carrito',
                    style: TextStyle(fontSize: 16)),
                onPressed: () {
                  // Call addItem with product details as positional arguments
                  cartProvider.addItem(
                    loadedProduct.id,
                    loadedProduct.title,
                    loadedProduct.price,
                    loadedProduct.imageUrl,
                  );
                  // Show confirmation snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('"${loadedProduct.title}" agregado al carrito.'),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context)
                      .primaryColor, // Use primary color for button background
                  foregroundColor: Colors.white, // Use white for text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30), // Add some bottom spacing
          ],
        ),
      ),
    );
  }
}
