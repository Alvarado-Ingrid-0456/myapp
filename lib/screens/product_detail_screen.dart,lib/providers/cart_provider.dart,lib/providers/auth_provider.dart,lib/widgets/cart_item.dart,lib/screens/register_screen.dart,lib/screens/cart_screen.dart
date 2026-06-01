
// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart'; // Assuming CartProvider is needed here

class ProductDetailScreen extends StatefulWidget {
  // Define the route name as a static constant
  static const routeName = '/product-detail';

  final String productId; // Assuming productId is passed to the detail screen

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Find the product using its ID
    // Assuming ProductProvider has a method like findById
    final loadedProduct = Provider.of<ProductProvider>(context, listen: false)
        .findById(widget.productId);
    final cart = Provider.of<CartProvider>(context, listen: false);

    if (loadedProduct == null) {
      // Handle the case where the product is not found
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Producto no encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Product Image - Use Image.network if URL is available, else AssetImage
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(loadedProduct.imageUrl), // Use NetworkImage if URL is valid
                  fit: BoxFit.cover,
                  // Add errorBuilder for NetworkImage
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder_product.png', // Fallback image
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      // Add to cart button at the bottom
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          cart.addItem(
            productId: loadedProduct.id,
            price: loadedProduct.price,
            title: loadedProduct.title,
            // imageUrl: loadedProduct.imageUrl, // Add imageUrl if CartItem expects it
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide previous snackbars
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('¡Producto añadido al carrito!'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'Deshacer',
                onPressed: () {
                  cart.removeSingleItem(loadedProduct.id);
                },
              ),
            ),
          );
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Añadir al carrito'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// lib/providers/cart_provider.dart (assuming this structure)
class CartItem {
  final String id;
  final String productId; // Added productId
  final String title;
  final int quantity;
  final double price;
  final String imageUrl; // Added imageUrl if needed by CartItem widget

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    this.imageUrl = '', // Provide a default empty string or handle appropriately
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length; // Assuming itemCount is the number of unique items
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem({
    required String productId,
    required double price,
    required String title,
    String imageUrl = '', // Added imageUrl parameter
  }) {
    if (_items.containsKey(productId)) {
      // If the product is already in the cart, increment quantity
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          productId: existingCartItem.productId,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      // If it's a new product, add it to the cart
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toIso8601String(), // Unique ID for the cart item entry
          productId: productId,
          title: title,
          quantity: 1,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    final existingItem = _items[productId]!;
    if (existingItem.quantity > 1) {
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
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}

// lib/providers/auth_provider.dart (Assuming AuthProvider structure)
class AuthProvider with ChangeNotifier {
  // Dummy method for demonstration. Replace with actual Firebase Auth logic.
  Future<void> register({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // In a real app, you would use FirebaseAuth here:
    // try {
    //   await firebase_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   notifyListeners();
    // } on firebase_auth.FirebaseAuthException catch (e) {
    //   throw Exception(e.message ?? 'Registration failed');
    // }

    print('Registering user: $email with password: $password');
    // For now, just simulate success
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty.');
    }
    // Simulate a successful registration
    notifyListeners();
  }

  // Dummy method for demonstration. Replace with actual Firebase Auth logic.
  Future<void> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1));
    print('Logging in user: $email with password: $password');
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty.');
    }
    // Simulate success
    notifyListeners();
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('User logged out');
    // In a real app: await firebase_auth.FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}

// lib/widgets/cart_item.dart (Assuming this structure)
class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  // final String imageUrl; // Add imageUrl if it's used and passed

  const CartItem({
    super.key,
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    // this.imageUrl = '', // Provide default if needed
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        cart.removeItem(productId); // Use productId to remove the correct item
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to remove the item from the cart?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false); // Return false to cancel dismiss
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true); // Return true to allow dismiss
                },
              ),
            ],
          ),
        );
      },
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            // leading: CircleAvatar( // Use CircleAvatar if imageUrl is available and needed
            //   backgroundImage: NetworkImage(imageUrl),
            //   // Add errorBuilder for NetworkImage if imageUrl might be invalid
            //   onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.image_not_supported),
            // ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('\$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x \$${price.toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }
}

// lib/screens/register_screen.dart (Update for named parameters)
// ... (previous imports and state variables)

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Pass named arguments for email and password
      await Provider.of<AuthProvider>(context, listen: false).register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Registro exitoso! Por favor, inicia sesión.')),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error desconocido.';
      if (e.code == 'weak-password') {
        message = 'La contraseña proporcionada es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Ya existe una cuenta con ese correo electrónico.';
      } else if (e.code == 'invalid-email') {
        message = 'El correo electrónico no es válido.';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
// ... (rest of RegisterScreen build method)

// lib/screens/cart_screen.dart (Correcting Chip and Consumer usage, adding productId to CartItem)
// ... (previous imports)

// Correcting Chip and Consumer usage
          Chip(
            label: Consumer<CartProvider>( // Use label for the text inside Chip
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
// ... (rest of CartScreen)

// Inside cart_screen.dart's ListView.builder:
// ...
                  final cartItem = cart.items.values.toList()[index];
                  return CartItem(
                    id: cartItem.id,
                    productId: cartItem.productId, // Ensure productId is passed
                    title: cartItem.title,
                    quantity: cartItem.quantity,
                    price: cartItem.price,
                    // imageUrl: cartItem.imageUrl, // Pass imageUrl if CartItem expects it
                  );
// ...
