import 'dart:math';
import 'package:faker/faker.dart';
import 'package:shopping_list/models/product.dart';

int randomId() => 1 + Random().nextInt(20000);

String randomDescription() => faker.lorem.word();

String randomUom() => faker.lorem.word();

int randomQuantity(int min, int max) => min + Random().nextInt(max);

Product fakeProduct({int? id}) => Product.fromMap({
      'id': id ?? randomId(),
      ...fakeProductAttributes(),
    });

Map<String, dynamic> fakeProductAttributes() => {
      'description': randomDescription(),
      'uom': randomUom(),
    };
