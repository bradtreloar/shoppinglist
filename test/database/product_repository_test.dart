import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/models/product.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import '../fakes.dart';
import 'package:shopping_list/database/product_repository.dart';

Future<Database> inMemoryDatabase() async {
  return await openDatabase(inMemoryDatabasePath, version: 1,
      onCreate: (database, version) async {
    await database.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        description TEXT,
        uom TEXT
      )
    ''');
  });
}

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
    final database = await inMemoryDatabase();
    final product1 = Product(description: randomDescription());
    final product2 =
        Product(description: randomDescription(), uom: randomUom());
    final productRepo = ProductRepository(database: database);

    final result0 = await database.query(ProductRepository.tableName);
    await productRepo.insert(product1);
    final result1 = await database.query(ProductRepository.tableName);
    await productRepo.insert(product2);
    final result2 = await database.query(ProductRepository.tableName);

    expect(result0, []);
    expect(result1, [
      {
        ...product1.toMap(),
        'id': 1,
      }
    ]);
    expect(result2, [
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
    final database = await inMemoryDatabase();
    final productAttributes = {
      'description': randomDescription(),
      'uom': randomUom(),
    };
    final productRepo = ProductRepository(database: database);

    final result0 = await productRepo.getAll();
    await database.insert('products', productAttributes);
    final result1 = await productRepo.getAll();

    expect(result0.toList(), []);
    expect(result1.toList(), [
      Product.fromMap({
        'id': 1,
        ...productAttributes,
      }),
    ]);
  });

  test('fetches product by ID', () async {
    final database = await inMemoryDatabase();
    final productAttributes = {
      'description': randomDescription(),
      'uom': randomUom(),
    };
    final productRepo = ProductRepository(database: database);

    await database.insert('products', productAttributes);
    final result1 = await productRepo.getById(1);
    await database.insert('products', productAttributes);
    final result2 = await productRepo.getById(2);

    expect(
        result1,
        Product.fromMap({
          'id': 1,
          ...productAttributes,
        }));
    expect(
        result2,
        Product.fromMap({
          'id': 2,
          ...productAttributes,
        }));
  });
}
