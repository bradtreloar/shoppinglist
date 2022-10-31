import 'package:flutter_test/flutter_test.dart';
import '../fakes.dart';
import 'package:shopping_list/models/shopping_list_item.dart';

void main() {
  test('ShoppingListItem converts to Map', () {
    final productId = randomId();
    final quantity = randomQuantity(1, 1000);

    final shoppingListItem =
        ShoppingListItem(productId: productId, quantity: quantity);

    expect(shoppingListItem.toMap(), {
      'productId': productId,
      'quantity': quantity,
    });
  });

  test('ShoppingListItem has string representation', () {
    final productId = randomId();
    final quantity = randomQuantity(1, 1000);

    final shoppingListItem =
        ShoppingListItem(productId: productId, quantity: quantity);

    expect(shoppingListItem.toString(),
        'ShoppingListItem{productId: $productId, quantity: $quantity}');
  });
}
