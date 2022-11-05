import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/database/exceptions.dart';
import 'package:shopping_list/models/product.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import '../fakes.dart';
import 'package:shopping_list/database/product_repository.dart';

Future<Database> inMemoryDatabase() async {
  return await openDatabase(inMemoryDatabasePath,
      version: 1, singleInstance: false, onCreate: (database, version) async {
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
  const tableName = 'products';

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('inserts new Product into database', () async {
    final database = await inMemoryDatabase();
    final productAttributes1 = fakeProductAttributes();
    final productAttributes2 = fakeProductAttributes();
    final productRepo = ProductRepository(database: database);

    final product1 = await productRepo.insert(productAttributes1);
    final result1 = await database.query(tableName);

    final product2 = await productRepo.insert(productAttributes2);
    final result2 = await database.query(tableName);

    final expectedProduct1 = {
      'id': 1,
      ...productAttributes1,
    };
    final expectedProduct2 = {
      'id': 2,
      ...productAttributes2,
    };

    expect(product1.toMap(), expectedProduct1);
    expect(product2.toMap(), expectedProduct2);
    expect(result1, [expectedProduct1]);
    expect(result2, [expectedProduct1, expectedProduct2]);
  });

  test('hydrates database with Products', () async {
    final database = await inMemoryDatabase();
    final products = [
      fakeProduct(id: 1),
      fakeProduct(id: 2),
    ];
    final productRepo = ProductRepository(database: database);

    await productRepo.hydrate(products);

    final result = await database.query(tableName);
    expect(result, products.map((product) => product.toMap()));
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

  test('returns null when product does not exist', () async {
    final database = await inMemoryDatabase();
    final productRepo = ProductRepository(database: database);

    final result = await productRepo.getById(1);

    expect(result, null);
  });

  test('updates product attributes', () async {
    final database = await inMemoryDatabase();
    const id = 1;
    final product = fakeProduct(id: id);
    final updatedProduct = fakeProduct(id: id);
    await database.insert('products', product.toMap());
    final productRepo = ProductRepository(database: database);

    await productRepo.update(updatedProduct);
    final result = await productRepo.getById(id);

    expect(result, updatedProduct);
  });

  test('throws exception when updating nonexistent product', () async {
    final database = await inMemoryDatabase();
    final product1 = fakeProduct();
    final productRepo = ProductRepository(database: database);

    try {
      await productRepo.update(product1);
      fail("IdNotFoundException not thrown");
    } catch (e) {
      expect(e, isInstanceOf<IdNotFoundException>());
    }
  });

  test('deletes product by ID', () async {
    final database = await inMemoryDatabase();
    final product = fakeProduct();
    await database.insert('products', product.toMap());
    final productRepo = ProductRepository(database: database);

    await productRepo.delete(product.id);

    final result = await database.query(tableName);
    expect(result, []);
  });

  test('throws exception when deleting non-existent product', () async {
    final database = await inMemoryDatabase();
    const id = 1;
    final productRepo = ProductRepository(database: database);

    try {
      await productRepo.delete(id);
      fail("IdNotFoundException not thrown");
    } catch (e) {
      expect(e, isInstanceOf<IdNotFoundException>());
    }
  });
}
