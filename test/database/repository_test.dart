import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/database/exceptions.dart';
import 'package:shopping_list/database/repository.dart';
import 'package:shopping_list/types.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import '../fakes.dart';
import '../utils.dart';

class TestModelRepository extends Repository<TestModel> {
  TestModelRepository(database) : super(database, TestModel.fromMap);

  @override
  String get tableName => 'test_model_table';

  @override
  List<Column> get columns => [
        {
          'name': 'textColumn',
          'type': 'TEXT',
        },
        {
          'name': 'textColumnNullable',
          'type': 'TEXT',
          'nullable': true,
        },
      ];
}

Future<Database> inMemoryDatabase() async {
  return await openDatabase(inMemoryDatabasePath,
      version: 1, singleInstance: false, onCreate: (database, version) async {
    await database.execute('''
      CREATE TABLE test_model_table (
        id INTEGER PRIMARY KEY,
        textColumn TEXT NOT NULL,
        textColumnNullable TEXT NULL
      )
    ''');
  });
}

Future main() async {
  const tableName = 'test_model_table';

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('creates table in database', () async {
    final database = await openDatabase(inMemoryDatabasePath, version: 1);
    final repo = TestModelRepository(database);

    await repo.createTable();

    final result = await database.query('''
      pragma_table_info('$tableName')
    ''');
    expect(result.map((col) => col['name']),
        ['id', 'textColumn', 'textColumnNullable']);
  });

  test('inserts new entity into database', () async {
    final database = await inMemoryDatabase();
    final modelAttributes1 = fakeTestModelAttributes();
    final modelAttributes2 = fakeTestModelAttributes();
    final repo = TestModelRepository(database);

    final model1 = await repo.insert(modelAttributes1);
    final result1 = await database.query(tableName);

    final model2 = await repo.insert(modelAttributes2);
    final result2 = await database.query(tableName);

    final expectedmodel1 = {
      'id': 1,
      ...modelAttributes1,
    };
    final expectedmodel2 = {
      'id': 2,
      ...modelAttributes2,
    };

    expect(model1.toMap(), expectedmodel1);
    expect(model2.toMap(), expectedmodel2);
    expect(result1, [expectedmodel1]);
    expect(result2, [expectedmodel1, expectedmodel2]);
  });

  test('hydrates table', () async {
    final database = await inMemoryDatabase();
    final entities = [
      fakeTestModel(id: 1),
      fakeTestModel(id: 2),
    ];
    final repo = TestModelRepository(database);

    await repo.hydrate(entities);

    final result = await database.query(tableName);
    expect(result, entities.map((model) => model.toMap()));
  });

  test('gets all entities from $tableName table', () async {
    final database = await inMemoryDatabase();
    final attributes = fakeTestModelAttributes();
    final repo = TestModelRepository(database);

    final result0 = await repo.getAll();
    await database.insert('test_model_table', attributes);
    final result1 = await repo.getAll();

    expect(result0.toList(), []);
    expect(result1.toList(), [
      TestModel.fromMap({
        'id': 1,
        ...attributes,
      }),
    ]);
  });

  test('fetches entities from database', () async {
    final database = await inMemoryDatabase();
    final attributes = {
      'textColumn': randomTextColumnValue(),
      'textColumnNullable': randomTextColumnValue(),
    };
    final repo = TestModelRepository(database);

    final result0 = await repo.getAll();
    await database.insert('test_model_table', attributes);
    final result1 = await repo.getAll();

    expect(result0.toList(), []);
    expect(result1.toList(), [
      TestModel.fromMap({
        'id': 1,
        ...attributes,
      }),
    ]);
  });

  test('fetches entity by ID', () async {
    final database = await inMemoryDatabase();
    final attributes = {
      'textColumn': randomTextColumnValue(),
      'textColumnNullable': randomUom(),
    };
    final repo = TestModelRepository(database);

    await database.insert('test_model_table', attributes);
    final result1 = await repo.getById(1);
    await database.insert('test_model_table', attributes);
    final result2 = await repo.getById(2);

    expect(
        result1,
        TestModel.fromMap({
          'id': 1,
          ...attributes,
        }));
    expect(
        result2,
        TestModel.fromMap({
          'id': 2,
          ...attributes,
        }));
  });

  test('returns null when entity does not exist', () async {
    final database = await inMemoryDatabase();
    final repo = TestModelRepository(database);

    final result = await repo.getById(1);

    expect(result, null);
  });

  test('updates entity attributes', () async {
    final database = await inMemoryDatabase();
    const id = 1;
    final entity = fakeTestModel(id: id);
    final updatedTestModel = fakeTestModel(id: id);
    await database.insert('test_model_table', entity.toMap());
    final repo = TestModelRepository(database);

    await repo.update(updatedTestModel);
    final result = await repo.getById(id);

    expect(result, updatedTestModel);
  });

  test('throws exception when updating nonexistent entity', () async {
    final database = await inMemoryDatabase();
    final entity1 = fakeTestModel();
    final repo = TestModelRepository(database);

    try {
      await repo.update(entity1);
      fail("IdNotFoundException not thrown");
    } catch (e) {
      expect(e, isInstanceOf<IdNotFoundException>());
    }
  });

  test('deletes entity by ID', () async {
    final database = await inMemoryDatabase();
    final entity = fakeTestModel();
    await database.insert('test_model_table', entity.toMap());
    final repo = TestModelRepository(database);

    await repo.delete(entity.id);

    final result = await database.query(tableName);
    expect(result, []);
  });

  test('throws exception when deleting non-existent entity', () async {
    final database = await inMemoryDatabase();
    const id = 1;
    final repo = TestModelRepository(database);

    try {
      await repo.delete(id);
      fail("IdNotFoundException not thrown");
    } catch (e) {
      expect(e, isInstanceOf<IdNotFoundException>());
    }
  });
}
