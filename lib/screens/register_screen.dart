
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias FirebaseAuth
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart'; // Assuming AuthProvider is in this path

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
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }

    if (!mounted) return; // Check if the widget is still mounted
    setState(() {
      _isLoading = true;
    });

    try {
      // Assuming AuthProvider.register now takes email and password only
      await Provider.of<AuthProvider>(context, listen: false).register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return; // Check if the widget is still mounted
      Navigator.of(context).pushReplacementNamed('/login');

      if (!mounted) return; // Check if the widget is still mounted
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
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (error) {
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    } finally {
      // Ensure setState is only called if the widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    // Check if the widget is still mounted before showing SnackBar or performing actions
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrarse con Google (pendiente de implementación)')),
    );
  }

  Future<void> _signInWithFacebook() async {
    // Check if the widget is still mounted before showing SnackBar or performing actions
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrarse con Facebook (pendiente de implementación)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
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
                  const Icon(
                    Icons.person_add,
                    size: 80.0,
                    color: Colors.teal,
                  ),
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
                  const SizedBox(height: 15.0),

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
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirma tu contraseña';
                      }
                      // Optionally, check if it matches the password field
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Assuming you have assets/icons/google.png and assets/icons/facebook.png
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
      ),
    );
  }
}
