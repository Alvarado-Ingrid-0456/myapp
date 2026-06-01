
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/providers/auth_provider.dart';
// Assuming these screens exist and are correctly imported
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/catalog_screen.dart';
import 'package:myapp/screens/product_detail_screen.dart'; // Ensure this is correctly imported
import 'package:myapp/screens/cart_screen.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/register_screen.dart';
import 'package:myapp/screens/welcome_screen.dart';
import 'package:myapp/screens/cuenta_screen.dart';
import 'package:myapp/screens/pagar_compra_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// Ensure firebase_options.dart is in the lib/ directory and generated correctly.
// If this import fails, run `flutterfire configure` again in your terminal.
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  try {
    // Initialize Firebase with platform-specific options from firebase_options.dart
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Use print for debugging initialization errors, as this is in main() and may not have context for ScaffoldMessenger
    print('Error initializing Firebase: $e'); // Changed from debugPrint to print for visibility in main
    // Run the app with a placeholder or error screen if Firebase fails to initialize
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error initializing Firebase: $e\nPlease check your firebase configuration.'),
        ),
      ),
    ));
    return; // Stop execution if Firebase initialization fails
  }
  runApp(const MyApp()); // Run the main application widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use MultiProvider to make multiple state providers available throughout the app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()), // Provider for product data
        ChangeNotifierProvider(create: (ctx) => CartProvider()), // Provider for cart state
        ChangeNotifierProvider(create: (ctx) => AuthProvider()), // Provider for authentication state
      ],
      child: MaterialApp(
        title: 'Flutter E-commerce App',
        // Define the application's theme
        theme: ThemeData(
          primarySwatch: Colors.teal, // Primary color theme
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
              .copyWith(secondary: Colors.amber, brightness: Brightness.light), // Secondary color and brightness
          fontFamily: 'Lato', // Default font family (ensure 'Lato' is declared in pubspec.yaml)
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontFamily: 'Lato', // Use the specified font family
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal, // Background color for elevated buttons
              foregroundColor: Colors.white, // Text color for elevated buttons
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners for buttons
              ),
            ),
          ),
          // Define text styles for different text elements
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black87),
            titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
        // Define named routes for navigation
        routes: {
          '/': (ctx) => const WelcomeScreen(), // Initial route
          '/login': (ctx) => const LoginScreen(),
          '/register': (ctx) => const RegisterScreen(),
          '/home': (ctx) => const HomeScreen(), // Assuming HomeScreen exists
          '/catalog': (ctx) => const CatalogScreen(), // Assuming CatalogScreen exists
          // Product Detail Screen route: uses static routeName and expects productId argument
          // Correctly referencing the static routeName property
          ProductDetailScreen.routeName: (ctx) {
            // Safely retrieve arguments, expecting a String (productId)
            final args = ModalRoute.of(ctx)?.settings.arguments;
            if (args is String && args.isNotEmpty) {
              // Pass productId to the ProductDetailScreen widget
              // Note: ProductDetailScreen itself doesn't need productId in constructor now.
              return const ProductDetailScreen();
            }
            // Return a fallback error screen if arguments are missing or invalid
            return const Scaffold(body: Center(child: Text('Error: ID de producto inválido.')));
          },
          '/cart': (ctx) => const CartScreen(),
          '/account': (ctx) => const CuentaScreen(),
          '/payment': (ctx) => const PagarCompraScreen(), // Assuming PagarCompraScreen exists
        },
        initialRoute: '/', // Set the application's starting route
      ),
    );
  }
}

// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart'; // Ensure Product model is imported

class ProductProvider with ChangeNotifier {
  // Dummy product data - in a real app, this would come from a database or API
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

  // Getter to return a copy of the product list
  List<Product> get items {
    return [..._items]; // Return a copy to ensure immutability
  }

  // Method to find a product by its ID
  Product? findById(String id) {
    try {
      // Use firstWhere to find the first matching product
      return _items.firstWhere((prod) => prod.id == id);
    } catch (e) {
      // Return null if the product is not found to prevent errors
      return null;
    }
  }

  // Placeholder method for adding a product
  void addProduct() {
    // TODO: Implement add product logic
    notifyListeners(); // Notify listeners if data changes
  }
}

// lib/models/product.dart
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

// lib/providers/cart_provider.dart
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
    final existingItem = _items[productId]!; // Get the existing cart item
    if (existingItem.quantity > 1) {
      // If quantity is greater than 1, decrement it
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          productId: value.productId,
          title: value.title,
          quantity: value.quantity - 1, // Decrement quantity
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

// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthProvider with ChangeNotifier {
  firebase_auth.User? _user; // Holds the currently authenticated user

  // Getter for the current user, returns null if not authenticated
  firebase_auth.User? get user => _user;

  // Constructor: Initializes listener for authentication state changes
  AuthProvider() {
    // authStateChanges() stream provides updates on user authentication status
    firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      _user = firebaseUser; // Update the _user object
      notifyListeners(); // Notify listeners (e.g., UI) about the change
    });
  }

  // Register a new user with email and password
  Future<void> register({required String email, required String password}) async {
    try {
      // Use Firebase Auth to create a new user
      final credential = await firebase_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user; // Set the newly created user as the current user
      notifyListeners(); // Notify listeners about user login
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Catch and rethrow FirebaseAuthExceptions for UI to handle
      throw Exception(e.message ?? 'Registration failed');
    }
  }

  // Log in an existing user with email and password
  Future<void> login({required String email, required String password}) async {
    try {
      // Use Firebase Auth to sign in an existing user
      final credential = await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user; // Set the logged-in user
      notifyListeners(); // Notify listeners about user login
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Catch and rethrow FirebaseAuthExceptions
      throw Exception(e.message ?? 'Login failed');
    }
  }

  // Log out the current user
  Future<void> logout() async {
    await firebase_auth.FirebaseAuth.instance.signOut(); // Sign out from Firebase
    _user = null; // Clear the current user object
    notifyListeners(); // Notify listeners about user logout
  }

  // Placeholder method for forgot password functionality
  Future<void> forgotPassword(String email) async {
    try {
      // Trigger Firebase's password reset email functionality
      await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent to $email'); // Log for debugging purposes
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Handle errors during the password reset process
      throw Exception(e.message ?? 'Failed to send password reset email.');
    }
  }

  // Placeholder method for Google Sign-In
  Future<void> signInWithGoogle() async {
    // TODO: Implement actual Google Sign-In logic here using Firebase Auth and Google Sign-In plugin
    debugPrint("Google Sign-In not implemented yet.");
  }

  // Placeholder method for Facebook Sign-In
  Future<void> signInWithFacebook() async {
    // TODO: Implement actual Facebook Sign-In logic here using Firebase Auth and Facebook Login plugin
    debugPrint("Facebook Sign-In not implemented yet.");
  }
}

// lib/widgets/cart_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  // Properties required to display a single item in the cart list
  final String id; // Unique ID for this cart entry
  final String productId; // ID of the associated product
  final String title; // Product title
  final int quantity; // Quantity of this product in the cart
  final double price; // Price per unit
  final String imageUrl; // URL for the product image

  const CartItem({
    super.key,
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    this.imageUrl = '', // Default to empty string if no image URL is provided
  });

  @override
  Widget build(BuildContext context) {
    // Access CartProvider without listening for changes, as actions (like delete)
    // trigger updates elsewhere, and this widget itself doesn't display dynamic cart data.
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(id), // Unique key for each dismissible item
      direction: DismissDirection.endToStart, // Enable swipe from right to left
      // Callback when the item is swiped and dismissed
      onDismissed: (_) {
        // Remove the item from the cart using its productId
        cartProvider.removeItem(productId);
      },
      // Confirmation dialog to prevent accidental deletion
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('¿Estás seguro?'),
            content: const Text('¿Quieres eliminar este artículo del carrito?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.of(ctx).pop(false), // Close dialog, cancel dismiss
              ),
              TextButton(
                child: const Text('Sí'),
                onPressed: () => Navigator.of(ctx).pop(true), // Close dialog, confirm dismiss
              ),
            ],
          ),
        );
      },
      // Background widget displayed during the swipe action (e.g., delete icon)
      background: Container(
        color: Colors.red.shade700,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      // The main content of the list item
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            // Leading: Product image using CircleAvatar
            leading: imageUrl.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                    // Handle potential errors when loading the network image
                    onBackgroundImageError: (exception, stackTrace) {
                      // Display a placeholder icon if the image fails to load
                      Icon(Icons.broken_image);
                    },
                  )
                : const CircleAvatar( // Default placeholder if no imageUrl
                    child: Icon(Icons.image_not_supported),
                  ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            // Subtitle shows the total price for this quantity of the item
            subtitle: Text('\$${(price * quantity).toStringAsFixed(2)}'),
            // Trailing shows quantity and unit price for clarity
            trailing: Text('$quantity x \$${price.toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }
}

// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/providers/product_provider.dart'; // Ensure ProductProvider is imported
import 'package:myapp/models/product.dart'; // Ensure Product model is imported

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail'; // Define the route name as a static constant

  // productId is now passed via arguments in MaterialApp routes, not constructor
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Retrieve productId from route arguments passed during navigation
    // Use ModalRoute.of(context)?.settings.arguments to get arguments
    final productId = ModalRoute.of(context)?.settings.arguments as String?;

    // Handle the case where productId is null or empty
    if (productId == null || productId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Error: ID del producto no proporcionado.')),
      );
    }

    // Find the product using its ID. Use listen: false as we only need to read the data once here.
    final loadedProduct = Provider.of<ProductProvider>(context, listen: false).findById(productId);
    // Access CartProvider with listen: true to react to cart changes (e.g., updating FAB state or showing snackbars).
    final cart = Provider.of<CartProvider>(context);

    // Handle the case where the product is not found (e.g., invalid ID)
    if (loadedProduct == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Producto no encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title), // Display product title dynamically in the AppBar
      ),
      body: SingleChildScrollView( // Make content scrollable if it exceeds screen height
        child: Column(
          children: <Widget>[
            // Product Image Display
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(loadedProduct.imageUrl), // Load image from URL
                  fit: BoxFit.cover, // Ensure image covers the container area
                  // errorBuilder is crucial for handling network image loading failures
                  errorBuilder: (context, error, stackTrace) {
                    // Display a fallback image from assets if NetworkImage fails
                    return Image.asset(
                      'assets/images/placeholder_product.png', // Ensure this placeholder image exists in assets/images/
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Product Price Display
            Text(
              '\$${loadedProduct.price.toStringAsFixed(2)}', // Format price to two decimal places
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Product Description Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true, // Allow text to wrap to the next line
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button to add the item to the cart
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add the current product to the cart using CartProvider
          cart.addItem(
            productId: loadedProduct.id,
            price: loadedProduct.price,
            title: loadedProduct.title,
            imageUrl: loadedProduct.imageUrl, // Pass necessary details for CartItem
          );
          // Show a confirmation Snackbar to the user
          ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide any existing snackbars before showing a new one
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('¡Producto añadido al carrito!'),
              duration: const Duration(seconds: 2),
              // Action to undo the addition
              action: SnackBarAction(
                label: 'Deshacer',
                onPressed: () {
                  // Remove one instance of the item if user undoes the action
                  cart.removeSingleItem(loadedProduct.id);
                },
              ),
            ),
          );
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Añadir al carrito'),
        backgroundColor: Theme.of(context).primaryColor, // Use theme's primary color for the FAB
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Position the FAB at the bottom center
    );
  }
}

// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';
// Ensure the correct import path for CartItem widget
import 'package:myapp/widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    // Access CartProvider to get cart items and total amount, listening for changes
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Compras'),
        centerTitle: true,
        actions: [
          // Payment button in the AppBar
          IconButton(
            icon: const Icon(Icons.payment),
            onPressed: () {
              // Only navigate to payment if the cart has items
              if (cart.itemCount > 0) {
                // Use pushReplacementNamed to navigate and replace the current CartScreen from the stack
                Navigator.of(context).pushReplacementNamed('/payment');
              } else {
                // Show a message if the cart is empty
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
          // Summary Card: Displays total amount and checkout button
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
                  const Spacer(), // Pushes the Chip and TextButton to the far right
                  // Chip widget to display the total amount. Uses Consumer for efficient rebuilds.
                  Chip(
                    label: Consumer<CartProvider>(
                      // Consumer rebuilds only this Text widget when totalAmount changes
                      builder: (ctx, cartProvider, _) => Text(
                        '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor, // Use theme's primary color
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    // Button is enabled only if the cart has items
                    onPressed: cart.itemCount > 0
                        ? () {
                            // Navigate to the payment screen, replacing the current route
                            Navigator.of(context).pushReplacementNamed('/payment');
                          }
                        : null, // Set onPressed to null to disable the button
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor, // Text color
                    ),
                    child: const Text('Ordenar ahora'),
                  ),
                ],
              ),
            ),
          ),
          // Display the list of cart items, or a message if the cart is empty
          if (cart.itemCount > 0)
            Expanded(
              // ListView.builder efficiently creates list items as they are needed
              child: ListView.builder(
                itemCount: cart.items.length, // Number of unique items in the cart
                itemBuilder: (ctx, index) {
                  // Retrieve the CartItem object from the map's values
                  final cartItem = cart.items.values.toList()[index];
                  return CartItem(
                    id: cartItem.id,
                    productId: cartItem.productId,
                    title: cartItem.title,
                    quantity: cartItem.quantity,
                    price: cartItem.price,
                    imageUrl: cartItem.imageUrl, // Pass the imageUrl to the CartItem widget
                  );
                },
              ),
            )
          else
            // Message displayed when the cart is empty
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

// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Global key for form validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false; // Loading state indicator

  @override
  void dispose() {
    // Dispose controllers when the widget is removed to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Validate the form using the global key
    if (!_formKey.currentState!.validate()) {
      return; // Exit if validation fails
    }

    // Check if passwords match before proceeding
    if (_passwordController.text != _confirmPasswordController.text) {
      // Use mounted check before calling setState or showing SnackBar
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return; // Exit if passwords do not match
    }

    // Ensure the widget is mounted before updating state or interacting with UI
    if (!mounted) return;
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Call the AuthProvider's register method with named parameters
      await Provider.of<AuthProvider>(context, listen: false).register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to login screen and show success message if registration is successful
      // and the widget is still mounted
      if (!mounted) return;
      // Use pushReplacementNamed to replace the current route, preventing back navigation to registration
      Navigator.of(context).pushReplacementNamed('/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Registro exitoso! Por favor, inicia sesión.')),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors with user-friendly messages
      String message = 'Ocurrió un error desconocido.';
      switch (e.code) {
        case 'weak-password':
          message = 'La contraseña proporcionada es demasiado débil.';
          break;
        case 'email-already-in-use':
          message = 'Ya existe una cuenta con ese correo electrónico.';
          break;
        case 'invalid-email':
          message = 'El correo electrónico no es válido.';
          break;
        default:
          // Fallback to the message provided by Firebase or the default error message
          message = e.message ?? 'Ocurrió un error desconocido.';
      }
      // Show error message if widget is still mounted
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      // Handle any other unexpected errors
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${error.toString()}')),);
    } finally {
      // Ensure the loading indicator is hidden if the widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Dummy methods for social logins - Implement actual logic using AuthProvider later
  Future<void> _signInWithGoogle() async {
    if (!mounted) return; // Guard against calling on disposed widget
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrarse con Google (no implementado)')),
    );
    // TODO: Implement Google Sign-In using AuthProvider.signInWithGoogle()
  }

  Future<void> _signInWithFacebook() async {
    if (!mounted) return; // Guard against calling on disposed widget
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrarse con Facebook (no implementado)')),
    );
    // TODO: Implement Facebook Sign-In using AuthProvider.signInWithFacebook()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50, // Light teal background color
      body: Center(
        child: SingleChildScrollView( // Allows scrolling for content that exceeds screen height
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Assign the form key for validation purposes
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
              children: <Widget>[
                // App logo/icon for visual appeal
                const Icon(Icons.person_add, size: 80.0, color: Colors.teal),
                const SizedBox(height: 20.0),
                // Screen title
                Text(
                  'Crear Cuenta',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 40.0),
                // Email input field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress, // Use email keyboard
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none, // No visible border line
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    // Email validation logic
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce tu correo electrónico';
                    }
                    // Basic email format check
                    if (!value.contains('@')) {
                      return 'Por favor, introduce un correo electrónico válido';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15.0),
                // Password input field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Hide password input
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    // Password validation logic
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15.0),
                // Confirm Password input field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    prefixIcon: const Icon(Icons.lock_reset, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    // Confirm password validation logic
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirma tu contraseña';
                    }
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30.0),
                // Register Button - shows loading indicator if _isLoading is true
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                    : ElevatedButton(
                        onPressed: _register, // Trigger registration function
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                const SizedBox(height: 30.0),
                // Social login buttons (Google, Facebook)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/icons/google.png', height: 30), // Ensure asset path is correct
                      onPressed: _signInWithGoogle,
                      tooltip: 'Registrarse con Google',
                    ),
                    const SizedBox(width: 20.0),
                    IconButton(
                      icon: Image.asset('assets/icons/facebook.png', height: 30), // Ensure asset path is correct
                      onPressed: _signInWithFacebook,
                      tooltip: 'Registrarse con Facebook',
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Link to Login screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('¿Ya tienes cuenta?'),
                    TextButton(
                      onPressed: () {
                        // Navigate to Login screen, replacing current route
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text(
                        'Inicia Sesión',
                        style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/screens/cuenta_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart';

class CuentaScreen extends StatelessWidget {
  const CuentaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access AuthProvider to get current user information
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user; // Get the current user object

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Cuenta'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display user details only if the user is logged in (user != null)
            if (user != null)
              Column(
                children: [
                  // User's profile picture: Use photoURL if available, otherwise a default icon
                  CircleAvatar(
                    radius: 50,
                    // Use user.photoURL if not null, otherwise null (which leads to default child)
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    // Show default icon if photoURL is null
                    child: user.photoURL == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                    // Handle potential errors when loading the network image
                    onBackgroundImageError: (exception, stackTrace) {
                      // Display a placeholder icon if the image fails to load
                      Icon(Icons.broken_image);
                    },
                  ),
                  const SizedBox(height: 20),
                  // Display user's display name (or a fallback)
                  Text(
                    user.displayName ?? 'Nombre no disponible',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  // Display user's email address (or a fallback)
                  Text(
                    user.email ?? 'Email no disponible',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                  // Logout Button
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    onPressed: () async {
                      // Call the logout method from AuthProvider
                      await authProvider.logout();
                      // Navigate back to the welcome screen and remove all routes from the stack
                      // This ensures the user cannot navigate back to authenticated areas after logout
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Use red for logout action clarity
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            else
              // Message displayed if the user is not logged in
              const Text('No has iniciado sesión.'),
          ],
        ),
      ),
    );
  }
}

// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:myapp/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // Global key for form validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Loading state indicator

  @override
  void dispose() {
    // Dispose controllers when the widget is removed to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Validate the form using the global key
    if (!_formKey.currentState!.validate()) {
      return; // Exit if validation fails
    }

    // Check if the widget is mounted before updating state
    if (!mounted) return;
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Attempt to log in using AuthProvider
      await Provider.of<AuthProvider>(context, listen: false).login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to home screen after successful login if widget is still mounted
      if (!mounted) return;
      // Use pushReplacementNamed to prevent returning to the login screen via back button
      Navigator.of(context).pushReplacementNamed('/home');
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      String message = 'Ocurrió un error desconocido.';
      switch (e.code) {
        case 'user-not-found':
          message = 'No se encontró un usuario con ese correo electrónico.';
          break;
        case 'wrong-password':
          message = 'La contraseña es incorrecta.';
          break;
        case 'invalid-email':
          message = 'El correo electrónico no es válido.';
          break;
        default:
          // Use the message from the exception if available
          message = e.message ?? 'Ocurrió un error desconocido.';
      }
      // Show error message if widget is still mounted
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      // Handle any other unexpected errors
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${error.toString()}')),);
    } finally {
      // Ensure loading indicator is hidden if the widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Dummy methods for social login - implement actual logic later
  Future<void> _signInWithGoogle() async {
    if (!mounted) return; // Guard against calling on disposed widget
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciar sesión con Google (no implementado)')),
    );
    // TODO: Implement Google Sign-In using AuthProvider.signInWithGoogle()
  }

  Future<void> _signInWithFacebook() async {
    if (!mounted) return; // Guard against calling on disposed widget
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciar sesión con Facebook (no implementado)')),
    );
    // TODO: Implement Facebook Sign-In using AuthProvider.signInWithFacebook()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50, // Light teal background color
      body: Center(
        child: SingleChildScrollView( // Allows scrolling for content that exceeds screen height
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Assign the form key for validation
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
              children: <Widget>[
                // App logo/icon
                const Icon(Icons.lock_open, size: 80.0, color: Colors.teal),
                const SizedBox(height: 20.0),
                // Screen title
                Text(
                  'Iniciar Sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade800,
                  ),
                ),
                const SizedBox(height: 40.0),
                // Email input field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce tu correo electrónico';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor, introduce un correo electrónico válido';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15.0),
                // Password input field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, introduce tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10.0),
                // Forgot Password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    // TODO: Implement forgot password logic
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función de Olvidé mi contraseña no implementada.')),
                      );
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.teal.shade700),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                // Login button - shows loading indicator if _isLoading is true
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                    : ElevatedButton(
                        onPressed: _login, // Call login function
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                const SizedBox(height: 30.0),
                // Social login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/icons/google.png', height: 30), // Ensure asset path is correct
                      onPressed: _signInWithGoogle,
                      tooltip: 'Iniciar sesión con Google',
                    ),
                    const SizedBox(width: 20.0),
                    IconButton(
                      icon: Image.asset('assets/icons/facebook.png', height: 30), // Ensure asset path is correct
                      onPressed: _signInWithFacebook,
                      tooltip: 'Iniciar sesión con Facebook',
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Link to Register screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('¿No tienes cuenta?'),
                    TextButton(
                      onPressed: () {
                        // Navigate to Register screen, replacing current route
                        Navigator.of(context).pushReplacementNamed('/register');
                      },
                      child: Text(
                        'Regístrate',
                        style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/screens/welcome_screen.dart
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand, // Ensure the stack fills the entire screen
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade300, Colors.teal.shade500], // Teal gradient colors
                begin: Alignment.topCenter, // Gradient starts from the top
                end: Alignment.bottomCenter, // Gradient ends at the bottom
              ),
            ),
          ),
          // Content Column, centered on the screen
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              children: <Widget>[
                // App Logo/Icon
                const Icon(
                  Icons.shopping_bag, // Example icon for a shopping app
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                // Welcome Title Text
                const Text(
                  '¡Bienvenido a Nuestra Tienda!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // Add shadow for better readability on the gradient background
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Subtitle Text
                const Text(
                  'Encuentra los mejores productos a precios increíbles.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70, // Slightly transparent white
                  ),
                ),
                const SizedBox(height: 50),
                // Login Button
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/login'), // Navigate to login
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // White background for contrast
                    foregroundColor: Colors.teal.shade600, // Teal text color
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Rounded button shape
                    ),
                    elevation: 5, // Add shadow for a "lifted" effect
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                // Register Button
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/register'), // Navigate to register
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2), // White border
                    foregroundColor: Colors.white, // White text color
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Crear Cuenta',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/widgets/navigation_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Access AuthProvider to get user information and handle logout
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user; // Get the current user

    return Drawer(
      child: Column(
        children: [
          // User Accounts Header: Displays user's profile info
          UserAccountsDrawerHeader(
            // Dynamically set account name and email, with fallbacks
            accountName: Text(user?.displayName ?? 'Usuario Anónimo'),
            accountEmail: Text(user?.email ?? 'No conectado'),
            // Display user's photo or a default icon if photoURL is null
            currentAccountPicture: CircleAvatar(
              // Use user.photoURL if not null, otherwise null (which leads to default child)
              backgroundImage: user?.photoURL != null ? NetworkImage(user.photoURL!) : null,
              // Show default icon if photoURL is null
              child: user?.photoURL == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
              // Handle potential errors when loading the network image
              onBackgroundImageError: (exception, stackTrace) {
                // Display a placeholder icon if the image fails to load
                Icon(Icons.broken_image);
              },
            ),
            // Apply theme's primary color to the header background
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          // Navigation List Tiles for different sections of the app
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Catálogo'),
            onTap: () {
              // Navigate to Catalog screen and close the drawer
              Navigator.of(context).pushReplacementNamed('/catalog');
              Navigator.of(context).pop(); // Close the drawer after navigation
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Carrito'),
            onTap: () {
              // Navigate to Cart screen and close the drawer
              Navigator.of(context).pushReplacementNamed('/cart');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi Cuenta'),
            onTap: () {
              if (user != null) {
                // Navigate to Account screen if user is logged in
                Navigator.of(context).pushReplacementNamed('/account');
              } else {
                // If not logged in, navigate to Login screen
                Navigator.of(context).pushReplacementNamed('/login');
                // Show a message informing the user they need to log in
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debes iniciar sesión para ver tu cuenta.')),
                );
              }
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
          // Placeholder for Orders navigation - TODO: Implement actual navigation
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Mis Pedidos'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegación a Pedidos no implementada.')),
              );
            },
          ),
          // Placeholder for Settings navigation - TODO: Implement actual navigation
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.of(context).pop(); // Close drawer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegación a Configuración no implementada.')),
              );
            },
          ),
          const Divider(), // Visual separator
          // Logout Tile: Displayed only if the user is logged in
          if (user != null)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red), // Red icon for logout action
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)), // Red text for logout
              onTap: () async {
                await authProvider.logout(); // Perform logout
                // Navigate back to the welcome screen and remove all routes from the stack
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),
          // Login/Register Tile: Displayed only if the user is NOT logged in
          if (user == null)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Iniciar Sesión'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/login'); // Navigate to login screen
                Navigator.of(context).pop(); // Close the drawer
              },
            ),
        ],
      ),
    );
  }
}
