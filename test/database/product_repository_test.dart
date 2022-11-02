import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:shopping_list/models/product.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import '../fakes.dart';
import 'package:shopping_list/database/product_repository.dart';

@GenerateNiceMocks([])
Future main() async {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('creates Product table in database', () async {
    final database = await openDatabase(inMemoryDatabasePath, version: 1);
    final productRepo = ProductRepository(database: database);

    await productRepo.createTable();

    final result = await database.query('''
      pragma_table_info('products')
    ''');
    expect(result.map((col) => col['name']), ['id', 'description', 'uom']);
  });

  test('inserts Product into database', () async {
    final database = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (database, version) async {
      await database.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY,
          description TEXT,
          uom TEXT
        )
      ''');
    });
    final product1 = Product(description: randomDescription());
    final product2 =
        Product(description: randomDescription(), uom: randomUom());
    final productRepo = ProductRepository(database: database);

    await productRepo.insert(product1);
    await productRepo.insert(product2);

    expect(await database.query(ProductRepository.tableName), [
      {
        ...product1.toMap(),
        'id': 1,
      },
      {
        ...product2.toMap(),
        'id': 2,
      }
    ]);
  });

  test('fetches products from database', () async {
    final database = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (database, version) async {
      await database.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY,
          description TEXT,
          uom TEXT
        )
      ''');
    });
    final productAttributes = {
      'description': randomDescription(),
      'uom': randomUom(),
    };
    await database.insert('products', productAttributes);
    final productRepo = ProductRepository(database: database);

    final result = await productRepo.getAll();

    expect(result.toList(), [
      Product.fromMap({
        'id': 1,
        ...productAttributes,
      }),
    ]);
  });
}
