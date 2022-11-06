import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/product_select_list.dart';

import 'fakes.dart';

void main() {
  group("ProductSelectList", () {
    testWidgets('displays products in alphabetical order',
        (WidgetTester tester) async {
      final products = fakeProducts(3);
      final sortedProducts = List.from(products);
      sortedProducts.sort((a, b) => a.description.compareTo(b.description));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ProductSelectList(products: products),
        ),
      ));

      final finder = find.byType(ListTile);
      expect(finder, findsNWidgets(products.length));

      for (var i = 0; i < products.length; i++) {
        var listTile = finder.at(i).evaluate().first.widget as ListTile;
        var title = listTile.title as Text;
        expect(title.data, sortedProducts[i].description);
      }
    });
  });
}
