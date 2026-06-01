import 'package:flutter/material.dart';

class EditarCuentaScreen extends StatefulWidget {
  const EditarCuentaScreen({super.key}); // Use super.key

  @override
  State<EditarCuentaScreen> createState() => _EditarCuentaScreenState();
}

class _EditarCuentaScreenState extends State<EditarCuentaScreen> {
  final _formKey = GlobalKey<FormState>();
  // Dummy data - in a real app, this would come from user profile
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with dummy data
    _nameController = TextEditingController(text: "John Doe");
    _emailController = TextEditingController(text: "john.doe@example.com");
    _phoneController = TextEditingController(text: "+1 234 567 890");
    _addressController =
        TextEditingController(text: "123 Main St, Anytown, USA");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Process data
      // In a real app, you would update the user's profile here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!')),
      );
      // Navigate back or to another screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Cuenta'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            // Use ListView for scrollable content
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu correo electrónico';
                  } else if (!value.contains('@')) {
                    return 'Por favor, ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                keyboardType: TextInputType.phone,
                // Removed unused local variable 'phone' warnings by using the controller directly
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu número de teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Address Field
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                maxLines: 3, // Allow multiple lines for address
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu dirección';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Save Button
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                ),
                child: const Text('Guardar Cambios',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
