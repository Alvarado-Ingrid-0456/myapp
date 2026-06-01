
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:myapp/providers/cart_provider.dart'; // Import CartProvider
import 'package:myapp/providers/product_provider.dart'; // Import ProductProvider (if needed elsewhere in this file)
import 'package:myapp/screens/pagar_compra_screen.dart'; // Import PagarCompraScreen

// --- RadioGroup Implementation ---
// Represents a single item in the radio group
class RadioGroupItem<T> {
  final T value;
  final String label;
  final Widget? trailing; // Optional widget at the end of the item

  RadioGroupItem({required this.value, required this.label, this.trailing});
}

// Custom RadioGroup widget
class RadioGroup<T> extends StatefulWidget {
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final List<RadioGroupItem<T>> items;
  final Axis direction;
  final TextStyle textStyle;
  final TextStyle activeTextStyle;
  final Color activeColor;
  final Color inactiveColor;

  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.items,
    this.direction = Axis.horizontal,
    this.textStyle = const TextStyle(),
    this.activeTextStyle = const TextStyle(),
    this.activeColor = Colors.teal,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<RadioGroup<T>> createState() => _RadioGroupState<T>();
}

class _RadioGroupState<T> extends State<RadioGroup<T>> {
  @override
  Widget build(BuildContext context) {
    // Use widget.direction to access the direction property
    Widget groupWidget = widget.direction == Axis.horizontal
        ? Row(children: _buildRadioItems())
        : Column(children: _buildRadioItems());

    return groupWidget;
  }

  List<Widget> _buildRadioItems() {
    return widget.items.map((item) {
      final bool isSelected = widget.groupValue == item.value;
      final TextStyle effectiveTextStyle = isSelected ? widget.activeTextStyle : widget.textStyle;
      final Color effectiveColor = isSelected ? widget.activeColor : widget.inactiveColor;

      return InkWell(
        onTap: () => widget.onChanged(item.value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Use min size for row/column children
            children: [
              // Radio Button
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: effectiveColor,
              ),
              const SizedBox(width: 10),
              // Label
              Text(item.label, style: effectiveTextStyle),
              // Trailing widget if provided
              if (item.trailing != null) ...[
                const Spacer(), // Push trailing to the right
                item.trailing!,
              ],
            ],
          ),
        ),
      );
    }).toList();
  }
}
// --- End of RadioGroup Implementation ---

class PagarCompraScreen extends StatefulWidget {
  const PagarCompraScreen({super.key});

  @override
  State<PagarCompraScreen> createState() => _PagarCompraScreenState();
}

class _PagarCompraScreenState extends State<PagarCompraScreen> {
  String _selectedPaymentMethod = 'credit_card'; // Default payment method

  @override
  Widget build(BuildContext context) {
    // Access CartProvider using Provider.of
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar Compra'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen del Pedido',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            // Display cart items summary
            Expanded( // Use Expanded to allow scrolling if content exceeds screen height
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) {
                  final cartItem = cart.items.values.toList()[index];
                  return ListTile(
                    title: Text('${cartItem.title} (${cartItem.quantity}x)'),
                    trailing: Text('\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const Divider(),
            // Total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Payment Method Selection
            Text(
              'Método de Pago',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),

            // Payment Method Radio Group
            RadioGroup<String>(
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              items: [
                // Radio button for Credit Card
                RadioGroupItem<String>(
                  value: 'credit_card',
                  label: 'Tarjeta de Crédito',
                  trailing: Icon(Icons.credit_card, color: Theme.of(context).primaryColor),
                ),
                // Radio button for PayPal
                RadioGroupItem<String>(
                  value: 'paypal',
                  label: 'PayPal',
                  trailing: Icon(Icons.paypal_outlined, color: Theme.of(context).primaryColor),
                ),
                // Radio button for Bank Transfer
                RadioGroupItem<String>(
                  value: 'bank_transfer',
                  label: 'Transferencia Bancaria',
                  trailing: Icon(Icons.account_balance, color: Theme.of(context).primaryColor),
                ),
              ],
              direction: Axis.vertical, // Set direction to vertical
              textStyle: const TextStyle(fontSize: 16),
              activeTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
              activeColor: Theme.of(context).primaryColor,
            ),

            const Spacer(), // Pushes the button to the bottom

            // Confirm Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: const Text(
                  'Confirmar Pago',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  // Action to confirm payment based on selected method
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pago confirmado con $_selectedPaymentMethod.'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  cart.clearCart(); // Clear cart after successful payment
                  Navigator.of(context).pop(); // Go back to previous screen or home
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
