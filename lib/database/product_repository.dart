import 'package:shopping_list/database/exceptions.dart';
import 'package:shopping_list/models/product.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository {
  static const tableName = 'products';
  final Database database;
  static const columns = [
    {
      'name': 'description',
      'type': 'TEXT',
    },
    {
      'name': 'uom',
      'type': 'TEXT',
      'primaryKey': true,
    },
  ];

  ProductRepository({required this.database});

  Future createTable() async {
    await database.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY,
          ${columns.map((column) => '''
            ${column['name']}
            ${column['type']}
            ${column['nullable'] == true ? "NULL" : "NOT NULL"}
          ''').join(',')}
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

  Future hydrate(List<Product> products) async {
    final values = products.map((product) =>
        "(${intValue(product.id)}, ${textValue(product.description)}, ${textValue(product.uom)})");
    await database.rawInsert(
        'INSERT INTO $tableName(id, description, uom) VALUES${values.join(",")}');
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

  String intValue(int? value) => value != null ? "$value" : 'null';

  String textValue(String? value) => value != null ? "'$value'" : 'null';
}
