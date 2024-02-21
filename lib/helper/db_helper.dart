// ignore_for_file: avoid_classes_with_only_static_members

import 'package:path/path.dart';
import 'package:quinto_assignment2/models/cart.dart';
import 'package:quinto_assignment2/models/product.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _dbName = 'products.db';
  static const int _dbVersion = 8;
  static const String tableProducts = 'products';
  static const String tableCart = 'cart';

  // products columns
  static const String codeCol = 'product_code';
  static const String nameCol = 'product_name';
  static const String priceCol = 'product_price';
  static const String favCol = 'product_fav';

  // cart columns
  static const String idCol = 'cart_id';
  static const String codeCartCol = 'product_code';
  static const String quantityCartCol = 'product_quantity';

  static Future<Database> openDB() async {
    final path = join(await getDatabasesPath(), _dbName);
    const sqlProduct =
        "CREATE TABLE IF NOT EXISTS $tableProducts ($codeCol TEXT PRIMARY KEY, $nameCol TEXT, $priceCol DECIMAL(10,2), $favCol BOOLEAN)";

    const sqlCart = ''' 
      CREATE TABLE IF NOT EXISTS $tableCart (
        $idCol INTEGER PRIMARY KEY AUTOINCREMENT,
        $codeCartCol TEXT,
        $quantityCartCol INTEGER,
        FOREIGN KEY($codeCartCol) REFERENCES $tableProducts($codeCol) ON DELETE CASCADE
      )
    ''';

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, v) {
        db.execute(sqlProduct);
        db.execute(sqlCart);
      },
      onUpgrade: (db, oldVer, newVer) {
        if (newVer > oldVer) {
          db.execute('DROP TABLE IF EXISTS $tableProducts');
          db.execute('DROP TABLE IF EXISTS $tableCart');
          db.execute(sqlProduct);
          db.execute(sqlCart);
        }
      },
    );
  }

  static Future<int> insertProduct(Product p) async {
    final db = await openDB();

    return db.insert(
      tableProducts,
      p.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Product>> getProducts(bool favorite) async {
    final db = await openDB();
    final List<Map<String, dynamic>> products = favorite
        ? await db
            .query(tableProducts, where: "$favCol = ?", whereArgs: [favorite])
        : await db.query(tableProducts);

    return products.map((e) => Product.fromMap(e)).toList();
  }

  static Future<List<Cart>> getCart() async {
    final db = await openDB();
    const sql =
        "SELECT $tableCart.$idCol, $tableCart.$codeCartCol, $tableProducts.$nameCol, $tableCart.$quantityCartCol FROM $tableCart INNER JOIN $tableProducts ON $tableCart.$codeCartCol = $tableProducts.$codeCol";

    final List<Map<String, dynamic>> cartItems = await db.rawQuery(sql);

    return cartItems.map((e) => Cart.fromMap(e)).toList();
  }

  static Future<int> addToCart(Cart c) async {
    final db = await openDB();

    return db.insert(
      tableCart,
      c.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> updateCart(Cart c) async {
    final db = await openDB();

    return db.update(
      tableCart,
      c.toMap(),
      where: '$idCol = ?',
      whereArgs: [c.id],
    );
  }

  static Future<int> deleteCart(Cart c) async {
    final db = await openDB();

    return db.delete(tableCart, where: '$idCol = ?', whereArgs: [c.id]);
  }

  static Future<int> updateProduct(Product p) async {
    final db = await openDB();

    return await db.update(
      tableProducts,
      p.toMap(),
      where: '$codeCol = ?',
      whereArgs: [p.code],
    );
  }

  static Future<int> deleteProduct(String code) async {
    final db = await openDB();

    return await db.delete(
      tableProducts,
      where: '$codeCol = ?',
      whereArgs: [code],
    );
  }
}
