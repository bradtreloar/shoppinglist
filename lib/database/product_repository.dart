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
          'nullable': true,
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
    final id = await database.insert(tableName, attributes);
    return await getById(id);
  }

  Future hydrate(List<Product> products) async {
    await database.rawInsert("""
        INSERT INTO $tableName(id, description, uom)
        VALUES ${products.map((product) => """(
          ${intValue(product.id)},
          ${textValue(product.description)},
          ${textValue(product.uom)}
        )""").join(',')}""");
  }

  Future update(Product product) async {
    final rowsAffected = await database.update(tableName, product.toMap(),
        where: 'id = ${product.id}');
    if (rowsAffected == 0) {
      throw IdNotFoundException('Product', product.id);
    }
  }

  Future delete(int id) async {
    final rowsAffected = await database.delete(tableName, where: 'id = $id');
    if (rowsAffected == 0) {
      throw IdNotFoundException('Product', id);
    }
  }
}
