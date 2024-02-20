import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quinto_assignment2/components/cart_card.dart';
import 'package:quinto_assignment2/models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<CartList>(
          builder: (_, c, child) {
            return FutureBuilder(
              future: c.cart,
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
                    return CartCard(
                      c: snapshot.data![i],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
