import 'package:shopping_list/models/model.dart';
import 'fakes.dart';

class TestModel extends Model {
  final String textColumn;
  final String? textColumnNullable;

  TestModel({required id, required this.textColumn, this.textColumnNullable})
      : super(id: id);

  TestModel.fromMap(Map<String, dynamic> map)
      : textColumn = map['textColumn'],
        textColumnNullable = map['textColumnNullable'],
        super(id: map['id']);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'textColumn': textColumn,
      'textColumnNullable': textColumnNullable,
    };
  }
}

TestModel fakeTestModel({int? id}) => TestModel.fromMap({
      'id': id ?? randomId(),
      ...fakeTestModelAttributes(),
    });

Map<String, dynamic> fakeTestModelAttributes() => {
      'textColumn': randomTextColumnValue(),
      'textColumnNullable': randomTextColumnValue(),
    };
