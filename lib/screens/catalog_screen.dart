
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/screens/product_detail_screen.dart';
import 'package:myapp/widgets/navigation_drawer.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      drawer: const NavigationDrawer(),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: products[i].id,
            );
          },
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(
                products[i].title,
                textAlign: TextAlign.center,
              ),
            ),
            child: Image.network(
              products[i].imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
