import 'package:flutter_test/flutter_test.dart';
import '../fakes.dart';
import 'package:shopping_list/models/product.dart';

void main() {
  test('Product converts to Map', () {
    final id = randomId();
    final description = randomDescription();
    final uom = randomUom();

    final product1 = Product(id: id, description: description, uom: uom);
    final product2 = Product(id: id, description: description);
    final product3 = Product(description: description);

    expect(product1.toMap(), {
      'id': id,
      'description': description,
      'uom': uom,
    });
    expect(product2.toMap(), {
      'id': id,
      'description': description,
      'uom': null,
    });
    expect(product3.toMap(), {
      'id': null,
      'description': description,
      'uom': null,
    });
  });

  test('Product has string representation', () {
    final id = randomId();
    final description = randomDescription();
    final uom = randomUom();

    final product1 = Product(id: id, description: description, uom: uom);
    final product2 = Product(id: id, description: description);
    final product3 = Product(description: description);

    expect(product1.toString(), 'Product{$description, UOM: $uom}');
    expect(product2.toString(), 'Product{$description}');
    expect(product3.toString(), 'Product{$description}');
  });

  test('creates Product from map', () {
    final map = {
      'id': randomId(),
      'description': randomDescription(),
      'uom': randomUom(),
    };

    final product = Product.fromMap(map);

    expect(product.id, map['id']);
    expect(product.description, map['description']);
    expect(product.uom, map['uom']);
  });
}
