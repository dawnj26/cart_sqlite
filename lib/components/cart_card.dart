import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quinto_assignment2/models/cart.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    super.key,
    required this.c,
  });

  final Cart c;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(c.id!),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Delete"),
              content: Text("Are you sure to delete ${c.productName}?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CartList>(context, listen: false).deleteItem(c);
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
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => ManageScreen(product: c),
            //   ),
            // );
          },
          title: Text(
            c.productName!,
            style: const TextStyle(fontSize: 18),
          ),
          trailing: Text(
            "${c.quantity}",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
