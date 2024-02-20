import 'package:flutter/material.dart';
import 'package:quinto_assignment2/helper/db_helper.dart';

class Product {
  final String code;
  final String name;
  final double price;
  late bool isFavorite;

  Product({
    required this.code,
    required this.name,
    required this.price,
    this.isFavorite = false,
  });

  Product.fromMap(Map<String, dynamic> map)
      : code = map[DBHelper.codeCol].toString(),
        name = map[DBHelper.nameCol].toString(),
        price = double.parse(map[DBHelper.priceCol].toString()),
        isFavorite = map[DBHelper.favCol] == 1;

  Map<String, dynamic> toMap() {
    return {
      DBHelper.codeCol: code,
      DBHelper.nameCol: name,
      DBHelper.priceCol: price,
      DBHelper.favCol: isFavorite ? 1 : 0,
    };
  }
}

class Products extends ChangeNotifier {
  bool _fav = false;

  Future<List<Product>> get products async {
    return await DBHelper.getProducts(_fav);
  }

  void insertProduct(Product p) {
    DBHelper.insertProduct(p);
    notifyListeners();
  }

  void updateProduct(Product p) {
    DBHelper.updateProduct(p);
    notifyListeners();
  }

  void toggleFavorite(Product p) {
    p.isFavorite = !p.isFavorite;
    DBHelper.updateProduct(p);
    notifyListeners();
  }

  void favList(bool isFav) {
    _fav = isFav;
    notifyListeners();
  }

  void deleteProduct(Product p) {
    DBHelper.deleteProduct(p.code);
    notifyListeners();
  }
}
