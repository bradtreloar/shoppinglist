import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/database/repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class TestRepository extends Repository {
  TestRepository({required database}) : super(database: database);

  @override
  String get tableName => 'test_table';

  @override
  List<Map<String, Object>> get columns => [
        {
          'name': 'text_column',
          'type': 'TEXT',
        },
        {
          'name': 'text_column_nullable',
          'type': 'TEXT',
          'nullable': true,
        },
      ];
}

Future<Database> inMemoryDatabase() async {
  return await openDatabase(inMemoryDatabasePath,
      version: 1, singleInstance: false, onCreate: (database, version) async {
    await database.execute('''
      CREATE TABLE test_table (
        id INTEGER PRIMARY KEY,
        text_column TEXT NOT NULL,
        text_column_nullable TEXT NULL
      )
    ''');
  });
}

Future main() async {
  const tableName = 'test_table';

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('creates table in database', () async {
    final database = await openDatabase(inMemoryDatabasePath, version: 1);
    final repo = TestRepository(database: database);

    await repo.createTable();

    final result = await database.query('''
      pragma_table_info('$tableName')
    ''');
    expect(result.map((col) => col['name']),
        ['id', 'text_column', 'text_column_nullable']);
  });
}
