import 'package:shopping_list/database/exceptions.dart';
import 'package:shopping_list/database/repository.dart';
import 'package:shopping_list/models/product.dart';

class ProductRepository extends Repository {
  ProductRepository({required database}) : super(database: database);

  @override
  String get tableName => 'products';

  @override
  List<Map<String, Object>> get columns => [
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
}
