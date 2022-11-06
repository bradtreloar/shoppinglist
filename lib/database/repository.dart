import 'package:shopping_list/database/exceptions.dart';
import 'package:shopping_list/models/model.dart';
import 'package:sqflite/sqflite.dart';

abstract class Repository<ModelType extends Model> {
  final Database database;
  ModelType Function(Map<String, Object?>) modelFromMap;

  Repository(this.database, this.modelFromMap);

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

  Future<Iterable<ModelType>> getAll() async {
    final results = await database.query(tableName);
    return results.map((row) => modelFromMap(row));
  }

  Future<ModelType?> getById(int id) async {
    final results = await database.query(tableName, where: 'id = $id');
    return results.isNotEmpty ? modelFromMap(results.first) : null;
  }

  Future<ModelType> insert(Map<String, dynamic> attributes) async {
    final id = await database.insert(tableName, attributes);
    return await getById(id) as ModelType;
  }

  Future hydrate(List<ModelType> models) async {
    await database.rawInsert("""
        INSERT INTO $tableName (id, ${columns.map((column) => column['name']).join(', ')})
        VALUES ${models.map(valuesFromModel).join(',')}
    """);
  }

  Future update(ModelType product) async {
    final rowsAffected = await database.update(tableName, product.toMap(),
        where: 'id = ${product.id}');
    if (rowsAffected == 0) {
      throw IdNotFoundException(ModelType.toString(), product.id);
    }
  }

  Future delete(int id) async {
    final rowsAffected = await database.delete(tableName, where: 'id = $id');
    if (rowsAffected == 0) {
      throw IdNotFoundException(ModelType.toString(), id);
    }
  }

  String valuesFromModel(ModelType model) {
    final map = model.toMap();
    return "(${map['id']}, ${columns.map((column) {
      final value = map[column['name']];
      if (column['type'] == 'TEXT') {
        return textValue(value);
      }
    }).join(', ')})";
  }

  String intValue(int? value) => value != null ? "$value" : 'null';

  String textValue(String? value) => value != null ? "'$value'" : 'null';
}
