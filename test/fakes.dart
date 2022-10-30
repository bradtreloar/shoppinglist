import 'dart:math';
import 'package:faker/faker.dart';

String randomDescription() => faker.lorem.word();

String randomUom() => faker.lorem.word();

int randomQuantity(int min, int max) => min + Random().nextInt(max);
