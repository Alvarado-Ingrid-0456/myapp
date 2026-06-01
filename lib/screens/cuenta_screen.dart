import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // This import is unused and will be removed
// import 'package:myapp/providers/auth_provider.dart'; // This import is unused and will be removed

class CuentaScreen extends StatelessWidget {
  const CuentaScreen({super.key}); // Use super.key

  @override
  Widget build(BuildContext context) {
    // Fetch user data if available
    // final userData = Provider.of<AuthProvider>(context).user; // Example

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Cuenta'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            // User Avatar/Icon
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal, // Placeholder color
              child: Icon(Icons.person, size: 60, color: Colors.white),
              // If you have user data with a photo URL:
              // backgroundImage: NetworkImage(userData?.photoUrl ?? ''),
            ),
            const SizedBox(height: 15),
            // User Name (if available)
            Text(
              'Nombre de Usuario', // Placeholder: Replace with actual user name
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            // User Email (if available)
            Text(
              'usuario@ejemplo.com', // Placeholder: Replace with actual user email
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            // Account Details Section
            Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_circle_outlined),
                    title: const Text('Información de Cuenta'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.of(context).pushNamed('/editar_cuenta');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: const Text('Mis Compras'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to orders/purchase history screen
                      // Navigator.of(context).pushNamed('/mis_compras');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navegando a Mis Compras...')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.payment_outlined),
                    title: const Text('Métodos de Pago'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to payment methods screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navegando a Métodos de Pago...')),
                      );
                    },
                  ),
                  // Add more ListTiles for other account-related sections
                ],
              ),
            ),
            const Spacer(), // Pushes the logout button to the bottom
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                onPressed: () {
                  // TODO: Implement logout logic
                  // Example using a hypothetical AuthProvider:
                  // Provider.of<AuthProvider>(context, listen: false).logout();
                  // Navigator.of(context).pushReplacementNamed('/login');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cerrando sesión...')),
                  );
                  // For now, navigate back to login as a placeholder
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent, // Red color for logout
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
