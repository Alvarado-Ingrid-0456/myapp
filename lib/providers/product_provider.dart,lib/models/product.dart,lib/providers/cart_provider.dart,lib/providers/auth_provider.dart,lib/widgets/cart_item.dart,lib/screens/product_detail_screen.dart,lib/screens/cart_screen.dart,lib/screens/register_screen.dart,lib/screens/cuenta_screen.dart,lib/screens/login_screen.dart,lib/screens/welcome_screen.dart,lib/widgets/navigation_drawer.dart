
// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart'; // Ensure Product model is imported

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

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    this.imageUrl = '',
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
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
    String imageUrl = '',
  }) {
    if (_items.containsKey(productId)) {
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
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toIso8601String() + '_' + productId,
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

// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthProvider with ChangeNotifier {
  firebase_auth.User? _user;

  firebase_auth.User? get user => _user;

  AuthProvider() {
    firebase_auth.FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      _user = firebaseUser;
      notifyListeners();
    });
  }

  Future<void> register({required String email, required String password}) async {
    try {
      final credential = await firebase_auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user;
      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final credential = await firebase_auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user;
      notifyListeners();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<void> logout() async {
    await firebase_auth.FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    try {
      await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent to $email');
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to send password reset email.');
    }
  }

  Future<void> signInWithGoogle() async {
    debugPrint("Google Sign-In not implemented yet.");
  }

  Future<void> signInWithFacebook() async {
    debugPrint("Facebook Sign-In not implemented yet.");
  }
}

// lib/widgets/cart_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  const CartItem({
    super.key,
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        cartProvider.removeItem(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('¿Estás seguro?'),
            content: const Text('¿Quieres eliminar este artículo del carrito?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: const Text('Sí'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
      },
      background: Container(
        color: Colors.red.shade700,
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
            leading: imageUrl.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                    onBackgroundImageError: (exception, stackTrace) {
                      Icon(Icons.broken_image);
                    },
                  )
                : const CircleAvatar(
                    child: Icon(Icons.image_not_supported),
                  ),
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('\$${(price * quantity).toStringAsFixed(2)}'),
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
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String?;

    if (productId == null || productId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Error: ID del producto no proporcionado.')),
      );
    }

    final loadedProduct = Provider.of<ProductProvider>(context, listen: false).findById(productId);
    final cart = Provider.of<CartProvider>(context);

    if (loadedProduct == null) {
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
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(loadedProduct.imageUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/placeholder_product.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${loadedProduct.price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          cart.addItem(
            productId: loadedProduct.id,
            price: loadedProduct.price,
            title: loadedProduct.title,
            imageUrl: loadedProduct.imageUrl,
          );
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
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
                Navigator.of(context).pushReplacementNamed('/payment');
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
                  const Text('Total:', style: TextStyle(fontSize: 20)),
                  const Spacer(),
                  Chip(
                    label: Consumer<CartProvider>(
                      builder: (ctx, cartProvider, _) => Text(
                        '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: cart.itemCount > 0
                        ? () {
                            Navigator.of(context).pushReplacementNamed('/payment');
                          }
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Ordenar ahora'),
                  ),
                ],
              ),
            ),
          ),
          if (cart.itemCount > 0)
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) {
                  final cartItem = cart.items.values.toList()[index];
                  return CartItem(
                    id: cartItem.id,
                    productId: cartItem.productId,
                    title: cartItem.title,
                    quantity: cartItem.quantity,
                    price: cartItem.price,
                    imageUrl: cartItem.imageUrl,
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
      await Provider.of<AuthProvider>(context, listen: false).register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Registro exitoso! Por favor, inicia sesión.')),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
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
          message = e.message ?? 'Ocurrió un error desconocido.';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${error.toString()}')),);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrarse con Google (no implementado)')),
    );
    // TODO: Implement Google Sign-In
  }

  Future<void> _signInWithFacebook() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrarse con Facebook (no implementado)')),
    );
    // TODO: Implement Facebook Sign-In
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(Icons.person_add, size: 80.0, color: Colors.teal),
                const SizedBox(height: 20.0),
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
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.teal),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Por favor, introduce tu correo electrónico';
                    if (!value.contains('@')) return 'Por favor, introduce un correo electrónico válido';
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Por favor, introduce tu contraseña';
                    if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Contraseña',
                    prefixIcon: const Icon(Icons.lock_reset, color: Colors.teal),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Por favor, confirma tu contraseña';
                    if (value != _passwordController.text) return 'Las contraseñas no coinciden';
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30.0),
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: const Text('Registrarse', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/icons/google.png', height: 30),
                      onPressed: _signInWithGoogle,
                      tooltip: 'Registrarse con Google',
                    ),
                    const SizedBox(width: 20.0),
                    IconButton(
                      icon: Image.asset('assets/icons/facebook.png', height: 30),
                      onPressed: _signInWithFacebook,
                      tooltip: 'Registrarse con Facebook',
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('¿Ya tienes cuenta?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text('Inicia Sesión', style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.bold)),
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
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Cuenta'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (user != null)
              Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                    onBackgroundImageError: (exception, stackTrace) {
                      Icon(Icons.broken_image);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.displayName ?? 'Nombre no disponible',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.email ?? 'Email no disponible',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    onPressed: () async {
                      await authProvider.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
            else
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false).login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } on firebase_auth.FirebaseAuthException catch (e) {
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
          message = e.message ?? 'Ocurrió un error desconocido.';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${error.toString()}')),);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciar sesión con Google (no implementado)')),
    );
    // TODO: Implement Google Sign-In
  }

  Future<void> _signInWithFacebook() async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciar sesión con Facebook (no implementado)')),
    );
    // TODO: Implement Facebook Sign-In
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Icon(Icons.lock_open, size: 80.0, color: Colors.teal),
                const SizedBox(height: 20.0),
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
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.teal),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Por favor, introduce tu correo electrónico';
                    if (!value.contains('@')) return 'Por favor, introduce un correo electrónico válido';
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.teal),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Por favor, introduce tu contraseña';
                    if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Función de Olvidé mi contraseña no implementada.')),
                      );
                    },
                    child: Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Colors.teal.shade700)),
                  ),
                ),
                const SizedBox(height: 30.0),
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        ),
                        child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Image.asset('assets/icons/google.png', height: 30),
                      onPressed: _signInWithGoogle,
                      tooltip: 'Iniciar sesión con Google',
                    ),
                    const SizedBox(width: 20.0),
                    IconButton(
                      icon: Image.asset('assets/icons/facebook.png', height: 30),
                      onPressed: _signInWithFacebook,
                      tooltip: 'Iniciar sesión con Facebook',
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('¿No tienes cuenta?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/register');
                      },
                      child: Text('Regístrate', style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.bold)),
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
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade300, Colors.teal.shade500],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.shopping_bag, size: 100, color: Colors.white),
                const SizedBox(height: 30),
                const Text(
                  '¡Bienvenido a Nuestra Tienda!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 10.0, color: Colors.black54, offset: Offset(2, 2)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Encuentra los mejores productos a precios increíbles.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal.shade600,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/register'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text('Crear Cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'Usuario Anónimo'),
            accountEmail: Text(user?.email ?? 'No conectado'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.photoURL != null ? NetworkImage(user.photoURL!) : null,
              child: user?.photoURL == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
              onBackgroundImageError: (exception, stackTrace) {
                Icon(Icons.broken_image);
              },
            ),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Catálogo'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/catalog');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Carrito'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/cart');
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi Cuenta'),
            onTap: () {
              if (user != null) {
                Navigator.of(context).pushReplacementNamed('/account');
              } else {
                Navigator.of(context).pushReplacementNamed('/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debes iniciar sesión para ver tu cuenta.')),
                );
              }
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Mis Pedidos'),
            onTap: () {
              // TODO: Implement navigation to Orders screen
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegación a Pedidos no implementada.')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              // TODO: Implement navigation to Settings screen
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navegación a Configuración no implementada.')),
              );
            },
          ),
          const Divider(),
          if (user != null)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await authProvider.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),
          if (user == null)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Iniciar Sesión'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/login');
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
