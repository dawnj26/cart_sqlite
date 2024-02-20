import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quinto_assignment2/models/cart.dart';
import 'package:quinto_assignment2/models/product.dart';
import 'package:quinto_assignment2/screens/manage_product_screen.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.p,
  });

  final Product p;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(p.code),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Delete"),
              content: Text("Are you sure to delete ${p.name}?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<Products>(context, listen: false)
                        .deleteProduct(p);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) {
        // Provider.of<Products>(context, listen: false).deleteProduct(p);
      },
      background: Card(
        color: Colors.red,
        elevation: 0,
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ManageScreen(product: p),
              ),
            );
          },
          leading: IconButton(
            onPressed: () {
              Provider.of<Products>(context, listen: false).toggleFavorite(p);
            },
            icon: Icon(p.isFavorite ? Icons.favorite : Icons.favorite_outline),
          ),
          title: Text(p.name),
          trailing: IconButton(
            onPressed: () {
              Provider.of<CartList>(context, listen: false).insertCart(p);
            },
            icon: const Icon(Icons.shopping_cart_checkout_outlined),
          ),
        ),
      ),
    );
  }
}
