import 'package:flutter/material.dart';
import 'package:quinto_assignment2/helper/db_helper.dart';
import 'package:quinto_assignment2/models/product.dart';

class Cart {
  String? id;
  final String productCode;
  final String? productName;
  late int quantity;

  Cart({
    this.id,
    required this.productCode,
    this.productName,
    required this.quantity,
  });

  Cart.fromMap(Map<String, dynamic> map)
      : id = map[DBHelper.idCol].toString(),
        productCode = map[DBHelper.codeCartCol].toString(),
        productName = map[DBHelper.nameCol].toString(),
        quantity = int.parse(map[DBHelper.quantityCartCol].toString());

  Map<String, dynamic> toMap() {
    return {
      DBHelper.codeCartCol: productCode,
      DBHelper.quantityCartCol: quantity,
    };
  }
}

class CartList extends ChangeNotifier {
  Future<List<Cart>> get cart async => await DBHelper.getCart();

  Future<void> insertCart(Product p) async {
    final cartList = await DBHelper.getCart();
    // final cartCode = cartList.map((c) => c.productCode).toList();

    final c = Cart(
      productCode: p.code,
      quantity: 1,
    );

    final index = cartList.indexWhere((c) => c.productCode == p.code);

    if (index != -1) {
      incrementQuantity(cartList[index]);
      return;
    }

    DBHelper.addToCart(c);
  }

  void incrementQuantity(Cart c) {
    c.quantity++;
    DBHelper.updateCart(c);
  }

  void deleteItem(Cart c) {
    DBHelper.deleteCart(c);
    notifyListeners();
  }
}
