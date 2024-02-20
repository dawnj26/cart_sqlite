import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Components
import 'package:quinto_assignment2/components/category_menu.dart';
import 'package:quinto_assignment2/components/product_card.dart';
import 'package:quinto_assignment2/models/product.dart';
import 'package:quinto_assignment2/screens/cart_screen.dart';
import 'package:quinto_assignment2/screens/manage_product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return const ManageScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
          CategoryMenu(
            categories: [
              MenuItemButton(
                child: const Text('All'),
                onPressed: () {
                  Provider.of<Products>(context, listen: false).favList(false);
                },
              ),
              MenuItemButton(
                child: const Text('Favorites only'),
                onPressed: () {
                  Provider.of<Products>(context, listen: false).favList(true);
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<Products>(
          builder: (_, p, child) {
            return FutureBuilder(
              future: p.products,
              builder: (_, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }

                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No products found"),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, i) {
                    return ProductCard(
                      p: snapshot.data![i],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return const CartScreen();
              },
            ),
          );
        },
        child: const Icon(Icons.shopping_cart_rounded),
      ),
    );
  }
}
