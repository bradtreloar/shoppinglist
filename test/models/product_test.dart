import 'package:flutter_test/flutter_test.dart';
import '../fakes.dart';
import 'package:shopping_list/models/product.dart';

void main() {
  test('Product has required description and quantity', () {
    final description = randomDescription();
    final quantity = randomQuantity(1, 10);

    final product = Product(description: description, quantity: quantity);

    expect(product.description, description);
    expect(product.quantity, quantity);
  });

  test('Product has optional unit of measure', () {
    final description = randomDescription();
    final quantity = randomQuantity(1, 10);
    final uom = randomUom();

    final product1 =
        Product(description: description, quantity: quantity, uom: uom);
    final product2 = Product(description: description, quantity: quantity);

    expect(product1.uom, uom);
    expect(product2.uom, null);
  });

  test('Product converts to Map', () {
    final description = randomDescription();
    final quantity = randomQuantity(1, 10);
    final uom = randomUom();

    final product1 =
        Product(description: description, quantity: quantity, uom: uom);
    final product2 = Product(description: description, quantity: quantity);

    final result1 = product1.toMap();
    final result2 = product2.toMap();

    expect(result1, {
      'description': description,
      'quantity': quantity,
      'uom': uom,
    });
    expect(result2, {
      'description': description,
      'quantity': quantity,
      'uom': null,
    });
  });
}
