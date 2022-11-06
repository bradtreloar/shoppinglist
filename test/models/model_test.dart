import 'package:flutter_test/flutter_test.dart';
import '../fakes.dart';
import '../utils.dart';

void main() {
  test('model converts to Map', () {
    final id = randomId();
    final textColumn = randomTextColumnValue();
    final textColumnNullable = randomTextColumnValue();

    final model1 = TestModel(
        id: id, textColumn: textColumn, textColumnNullable: textColumnNullable);
    final model2 = TestModel(id: id, textColumn: textColumn);

    expect(model1.toMap(), {
      'id': id,
      'textColumn': textColumn,
      'textColumnNullable': textColumnNullable,
    });
    expect(model2.toMap(), {
      'id': id,
      'textColumn': textColumn,
      'textColumnNullable': null,
    });
  });

  test('TestModel has string representation', () {
    final id = randomId();
    final textColumn = randomDescription();
    final textColumnNullable = randomUom();

    final model = TestModel(
        id: id, textColumn: textColumn, textColumnNullable: textColumnNullable);

    expect(model.toString(), 'TestModel{$id}');
  });

  test('creates TestModel from map', () {
    final map = {
      'id': randomId(),
      'textColumn': randomDescription(),
      'textColumnNullable': randomUom(),
    };

    final model = TestModel.fromMap(map);

    expect(model.id, map['id']);
    expect(model.textColumn, map['textColumn']);
    expect(model.textColumnNullable, map['textColumnNullable']);
  });

  test('detects is equal or not equal with another TestModel', () {
    final model1 = fakeTestModel();
    final model2 = TestModel.fromMap(model1.toMap());

    expect(model1, model2);
  });
}
