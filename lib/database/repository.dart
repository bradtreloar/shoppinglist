import 'package:shopping_list/models/model.dart';
import 'package:sqflite/sqflite.dart';

abstract class Repository<M extends Model> {
  final Database database;

  Repository({required this.database});

  String get tableName;

  List<Map<String, Object>> get columns;

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

  String intValue(int? value) => value != null ? "$value" : 'null';

  String textValue(String? value) => value != null ? "'$value'" : 'null';
}
