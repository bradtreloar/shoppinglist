import 'package:shopping_list/models/product.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository {
  static const tableName = 'products';
  final Database database;

  ProductRepository({required this.database});

  Future createTable() async {
    await database.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY,
          description TEXT,
          uom TEXT
        )
      ''');
  }

  Future insert(Product product) async {
    await database.insert(tableName, product.toMap());
  }

  Future<Iterable<Product>> getAll() async {
    final results = await database.query(tableName);
    return results.map((row) => Product.fromMap(row));
  }
}
