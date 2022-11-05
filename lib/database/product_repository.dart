import 'package:shopping_list/database/exceptions.dart';
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

  Future<Iterable<Product>> getAll() async {
    final results = await database.query(tableName);
    return results.map((row) => Product.fromMap(row));
  }

  Future<Product?> getById(int id) async {
    final results = await database.query(tableName, where: 'id = $id');
    return results.isNotEmpty ? Product.fromMap(results.first) : null;
  }

  Future insert(Map<String, dynamic> attributes) async {
    await database.insert(tableName, attributes);
  }

  Future update(Product product) async {
    final results =
        await database.query(tableName, where: 'id = ${product.id}');
    if (results.isEmpty) {
      throw IdNotFoundException('Product', product.id);
    }

    await database.update(tableName, product.toMap(),
        where: 'id = ${product.id}');
  }

  Future delete(int id) async {
    final results = await database.query(tableName, where: 'id = $id');
    if (results.isEmpty) {
      throw IdNotFoundException('Product', id);
    }

    await database.delete(tableName, where: 'id = $id');
  }
}
