import 'package:flutter_test/flutter_test.dart';
import '../fakes.dart';
import 'package:shopping_list/models/product.dart';

void main() {
  test('Product has required description', () {
    final description = randomDescription();

    final product = Product(description: description);

    expect(product.description, description);
  });

  test('Product has optional unit of measure', () {
    final description = randomDescription();
    final uom = randomUom();

    final product1 = Product(description: description, uom: uom);
    final product2 = Product(description: description);

    expect(product1.uom, uom);
    expect(product2.uom, null);
  });

  test('Product converts to Map', () {
    final description = randomDescription();
    final uom = randomUom();

    final product1 = Product(description: description, uom: uom);
    final product2 = Product(description: description);

    final result1 = product1.toMap();
    final result2 = product2.toMap();

    expect(result1, {
      'description': description,
      'uom': uom,
    });
    expect(result2, {
      'description': description,
      'uom': null,
    });
  });

  test('Product has string representation', () {
    final description = randomDescription();
    final uom = randomUom();

    final product1 = Product(description: description, uom: uom);
    final product2 = Product(description: description);

    expect(product1.toString(), 'Product{$description, UOM: $uom}');
    expect(product2.toString(), 'Product{$description}');
  });
}
