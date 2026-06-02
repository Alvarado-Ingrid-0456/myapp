
import 'package:flutter/material.dart';
import 'package:myapp/widgets/navigation_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      drawer: const NavigationDrawer(),
      body: const Center(
        child: Text('¡Bienvenido a la página de inicio!'),
      ),
    );
  }
}
