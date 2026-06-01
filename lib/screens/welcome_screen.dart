import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Background Image or Gradient
          Image.asset(
            'assets/images/welcome_background.jpg', // Placeholder for a background image
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              // Fallback background
              color: Colors.teal.shade400,
            ),
          ),
          // Overlay gradient for better text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal.withOpacity(0.8), // Use withOpacity correctly
                  Colors.teal.withOpacity(0.5), // Use withOpacity correctly
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Content Column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2), // Pushes content up
              // App Logo
              const Icon(
                Icons.shopping_basket,
                size: 100.0,
                color: Colors.white,
              ),
              const SizedBox(height: 20.0),
              // App Title
              Text(
                '¡Bienvenido a Nuestra App!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                      .withOpacity(0.9), // Use withOpacity correctly
                ),
              ),
              const SizedBox(height: 15.0),
              // App Tagline
              Text(
                'Tu destino de compras online.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
                      .withOpacity(0.8), // Use withOpacity correctly
                ),
              ),
              const Spacer(flex: 3), // Pushes buttons to the bottom
              // Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                      '/login'); // Navigate to Login Screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background
                  foregroundColor: Colors.teal, // Teal text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),
              // Sign Up Button
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                      '/register'); // Navigate to Register Screen
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Colors.white, width: 2), // White border
                  foregroundColor: Colors.white, // White text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Crear Cuenta',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40.0), // Bottom padding
            ],
          ),
        ],
      ),
    );
  }
}
