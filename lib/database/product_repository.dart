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

  Future insert(Product product) async {
    try {
      await database.insert(tableName, product.toMap());
    } on Exception {
      if (product.id != null) {
        final id = product.id as int;
        final existingProduct = await getById(id);
        if (existingProduct != null) {
          throw DuplicateIdException('Product', id);
        }
      }
    }
  }

  Future update(Product product) async {
    if (product.id == null) {
      throw const NullIdException('Product');
    }

    final results =
        await database.query(tableName, where: 'id = ${product.id}');
    if (results.isEmpty) {
      throw IdNotFoundException('Product', product.id as int);
    }

    await database.update(tableName, product.toMap(),
        where: 'id = ${product.id}');
  }
}
