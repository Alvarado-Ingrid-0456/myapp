
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/providers/product_provider.dart';

import 'package:myapp/screens/welcome_screen.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/register_screen.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/catalog_screen.dart';
import 'package:myapp/screens/product_detail_screen.dart';
import 'package:myapp/screens/cart_screen.dart';
import 'package:myapp/screens/cuenta_screen.dart';
import 'package:myapp/screens/pagar_compra_screen.dart';
import 'package:myapp/screens/order_success_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Mi Tienda Flutter',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/catalog': (context) => const CatalogScreen(),
          ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          '/account': (context) => const CuentaScreen(),
          '/payment': (context) => const PagarCompraScreen(),
          '/order-success':(context) => const OrderSuccessScreen(),
        },
      ),
    );
  }
}
