
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias FirebaseAuth
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart'; // Assuming AuthProvider is in this path

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

  // TODO: Implement login logic
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Guard context usage with mounted check
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Use AuthProvider to handle login
      await Provider.of<AuthProvider>(context, listen: false).login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // If login is successful, navigate to the home screen or catalog
      // Assuming you have a named route '/catalog'
      if (!mounted) return; // Check mounted again before navigation
      Navigator.of(context).pushReplacementNamed('/catalog');

      if (!mounted) return; // Check mounted before showing SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso!')),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth exceptions
      String message = 'Ocurrió un error desconocido.';
      if (e.code == 'user-not-found') {
        message = 'No se encontró un usuario con ese correo.';
      } else if (e.code == 'wrong-password') {
        message = 'Contraseña incorrecta.';
      } else if (e.code == 'invalid-email') {
        message = 'El correo electrónico no es válido.';
      }
       if (!mounted) return; // Check mounted before showing SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (error) {
      // Handle generic errors
       if (!mounted) return; // Check mounted before showing SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      // Check mounted before calling setState
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // TODO: Implement forgot password logic
  void _forgotPassword() {
    // Implement forgot password functionality here
    // This would typically involve showing a dialog or navigating to a password reset screen.
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Olvidaste tu contraseña?'),
        content: const Text('Introduce tu correo electrónico para enviarte un enlace de restablecimiento.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Enviar'),
            onPressed: () {
              // Here you would implement the actual password reset logic using Firebase Auth
              // For now, just close the dialog
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Se ha enviado un correo de restablecimiento (simulado).')),
              );
            },
          ),
        ],
      ),
    );
  }

  // TODO: Implement Google Sign-In
  Future<void> _signInWithGoogle() async {
    // Implement Google Sign-In functionality here
    // This requires setting up Google Sign-In in your Firebase project and app.
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciar sesión con Google (pendiente de implementación)')),
    );
    // Example (requires google_sign_in package and Firebase setup):
    /*
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User cancelled the sign-in
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Navigate after successful sign-in
      Navigator.of(context).pushReplacementNamed('/catalog');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Google: $e')),
      );
    }
    */
  }

  // TODO: Implement Facebook Sign-In
  Future<void> _signInWithFacebook() async {
    // Implement Facebook Sign-In functionality here
    // This requires setting up Facebook Login in your Firebase project and app.
     if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Iniciar sesión con Facebook (pendiente de implementación)')),
    );
    // Facebook sign-in implementation is more complex and involves the Facebook SDK.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50, // Light teal background
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // App Logo or Title
                  const Icon(
                    Icons.shopping_bag,
                    size: 80.0,
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Bienvenido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  // Email Field
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
                      fillColor: Colors.white.withOpacity(0.8), // Use withOpacity correctly
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

                  // Password Field
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
                      fillColor: Colors.white.withOpacity(0.8), // Use withOpacity correctly
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
                  const SizedBox(height: 20.0),

                  // Forgot Password Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.teal.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),

                  // Login Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, // Primary color
                            foregroundColor: Colors.white, // Text color
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

                  // Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Google Sign-In Button
                      IconButton(
                        icon: Image.asset('assets/icons/google.png', height: 30), // Placeholder icon
                        onPressed: _signInWithGoogle,
                        tooltip: 'Iniciar sesión con Google',
                      ),
                      const SizedBox(width: 20.0),
                      // Facebook Sign-In Button
                      IconButton(
                        icon: Image.asset('assets/icons/facebook.png', height: 30), // Placeholder icon
                        onPressed: _signInWithFacebook,
                        tooltip: 'Iniciar sesión con Facebook',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // Sign Up Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('¿No tienes cuenta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/register'); // Navigate to Register Screen
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
      ),
    );
  }
}
