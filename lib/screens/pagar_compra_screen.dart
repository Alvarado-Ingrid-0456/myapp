
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';

class PagarCompraScreen extends StatefulWidget {
  const PagarCompraScreen({super.key});

  @override
  State<PagarCompraScreen> createState() => _PagarCompraScreenState();
}

class _PagarCompraScreenState extends State<PagarCompraScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      // Simulate a network request
      Future.delayed(const Duration(seconds: 2), () {
        Provider.of<CartProvider>(context, listen: false).clear();
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacementNamed('/order-success');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagar Compra')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre Completo', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Por favor ingresa tu nombre.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Dirección de Envío', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Por favor ingresa tu dirección.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Número de Tarjeta', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Por favor ingresa tu número de tarjeta.' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'MM/AA', border: OutlineInputBorder()),
                      keyboardType: TextInputType.datetime,
                      validator: (value) => value!.isEmpty ? 'Inválido' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'CVV', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Inválido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submitOrder,
                  child: const Text('Confirmar Pedido'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
