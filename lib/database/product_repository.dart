import 'package:shopping_list/database/repository.dart';
import 'package:shopping_list/models/product.dart';
import 'package:shopping_list/types.dart';

class ProductRepository extends Repository<Product> {
  ProductRepository(database) : super(database, Product.fromMap);

  @override
  String get tableName => 'products';

  @override
  List<Column> get columns => [
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
}
