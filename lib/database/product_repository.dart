import 'package:shopping_list/database/exceptions.dart';
import 'package:shopping_list/models/product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/src/exception.dart';

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
    try {
      await database.insert(tableName, product.toMap());
    } on SqfliteDatabaseException {
      if (product.id != null) {
        final id = product.id as int;
        final existingProduct = await getById(id);
        if (existingProduct != null) {
          throw DuplicateIdException('Product', id);
        }
      }
    }
  }

  Future<Iterable<Product>> getAll() async {
    final results = await database.query(tableName);
    return results.map((row) => Product.fromMap(row));
  }

  Future<Product?> getById(int id) async {
    final results = await database.query(tableName, where: 'id = $id');
    return results.isNotEmpty ? Product.fromMap(results.first) : null;
  }
}
