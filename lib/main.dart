
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/catalog_screen.dart';
import 'package:myapp/screens/product_detail_screen.dart';
import 'package:myapp/screens/cart_screen.dart';
import 'package:myapp/screens/login_screen.dart'; // Import LoginScreen
import 'package:myapp/screens/register_screen.dart'; // Import RegisterScreen
import 'package:myapp/screens/welcome_screen.dart'; // Import WelcomeScreen
import 'package:myapp/screens/cuenta_screen.dart'; // Import CuentaScreen
import 'package:myapp/screens/pagar_compra_screen.dart'; // Import PagarCompraScreen
import 'package:firebase_core/firebase_core.dart'; // For Firebase initialization
import 'firebase_options.dart'; // Make sure this file exists and is generated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Handle Firebase initialization errors
    print('Error initializing Firebase: $e');
    // Optionally, run the app with a placeholder or error screen
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Error initializing Firebase: $e'),
        ),
      ),
    ));
    return; // Stop execution if Firebase fails to initialize
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider to provide multiple providers to the widget tree
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductProvider()), // Product data provider
        ChangeNotifierProvider(create: (ctx) => CartProvider()), // Cart data provider
        // Add AuthProvider here if it's used globally
        // ChangeNotifierProvider(create: (ctx) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter E-commerce App',
        theme: ThemeData(
          primarySwatch: Colors.teal, // Primary color swatch
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
              .copyWith(secondary: Colors.amber, brightness: Brightness.light), // Accent color and brightness
          fontFamily: 'Lato', // Example custom font family
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontFamily: 'Lato',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal, // Button background color
              foregroundColor: Colors.white, // Button text color
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black87), // Default text style
            titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            headlineSmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
          ),
        ),
        // Define routes for navigation
        routes: {
          '/': (ctx) => const WelcomeScreen(), // Initial route
          '/login': (ctx) => const LoginScreen(),
          '/register': (ctx) => const RegisterScreen(),
          '/home': (ctx) => const HomeScreen(), // Example: Navigate to HomeScreen after login
          '/catalog': (ctx) => const CatalogScreen(),
          // Correctly define route for ProductDetailScreen using its static routeName
          // If ProductDetailScreen has `static const routeName = '/product-detail';`
          ProductDetailScreen.routeName: (ctx) {
             return const ProductDetailScreen();
          },
          '/cart': (ctx) => const CartScreen(),
          '/account': (ctx) => const CuentaScreen(), // Corrected route name for CuentaScreen
          '/payment': (ctx) => const PagarCompraScreen(), // Route for payment screen
          // '/compra_exitosa': (ctx) => const CompraExitosaScreen(), // Example route for purchase success
        },
        // Initial route can be set here or handled by returning WelcomeScreen '/'
        initialRoute: '/',
      ),
    );
  }
}
