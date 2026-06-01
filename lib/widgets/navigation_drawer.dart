
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Alias FirebaseAuth
import 'package:provider/provider.dart';
import 'package:myapp/providers/auth_provider.dart'; // Assuming AuthProvider is in this path

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firebase_auth.User? currentUser = firebase_auth.FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Material(
        color: Colors.teal.shade600,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                currentUser?.displayName ?? 'Usuario Desconocido',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(
                currentUser?.email ?? 'no-reply@example.com',
                style: const TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: currentUser?.photoURL != null
                      ? Image.network(
                          currentUser!.photoURL!,
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                          // Correctly use errorBuilder
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            return const Icon(Icons.person, size: 40, color: Colors.teal);
                          },
                        )
                      : const Icon(Icons.person, size: 40, color: Colors.teal),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.teal.shade800,
                image: DecorationImage(
                  image: const AssetImage('assets/images/drawer_header_bg.png'), // Placeholder background image
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.teal.shade800.withOpacity(0.5), BlendMode.darken),
                  // Use errorBuilder correctly for DecorationImage if needed, though typically not required for local assets.
                  // errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => const SizedBox.shrink(),
                ),
              ),
            ),

            buildMenuItem(
              context: context,
              text: 'Inicio',
              icon: Icons.home,
              onClicked: () => selectedItem(context, 0),
            ),
            buildMenuItem(
              context: context,
              text: 'Catálogo',
              icon: Icons.shopping_bag,
              onClicked: () => selectedItem(context, 1),
            ),
            buildMenuItem(
              context: context,
              text: 'Mi Carrito',
              icon: Icons.shopping_cart,
              onClicked: () => selectedItem(context, 2),
            ),
            buildMenuItem(
              context: context,
              text: 'Mis Pedidos',
              icon: Icons.list_alt,
              onClicked: () => selectedItem(context, 3),
            ),
            buildMenuItem(
              context: context,
              text: 'Mi Cuenta',
              icon: Icons.person,
              onClicked: () => selectedItem(context, 4),
            ),
            const Divider(color: Colors.white70),
            buildMenuItem(
              context: context,
              text: 'Configuración',
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 5),
            ),
            const Spacer(),
            buildMenuItem(
              context: context,
              text: 'Cerrar Sesión',
              icon: Icons.logout,
              onClicked: () async {
                await authProvider.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onClicked,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/catalog');
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed('/cart');
        break;
      case 3:
        // TODO: Implement navigation to Orders screen
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navegación a Mis Pedidos pendiente.')));
        break;
      case 4:
        Navigator.of(context).pushReplacementNamed('/account');
        break;
      case 5:
        // TODO: Implement navigation to Settings screen
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navegación a Configuración pendiente.')));
        break;
    }
  }
}
