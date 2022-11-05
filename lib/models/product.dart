import 'package:shopping_list/models/model.dart';

class Product extends Model {
  final String description;
  final String? uom;

  Product({required id, required this.description, this.uom}) : super(id: id);

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'], description: map['description'], uom: map['uom']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'uom': uom,
    };
  }

  @override
  String toString() {
    return uom != null
        ? '$runtimeType{$id: $description, UOM: $uom}'
        : '$runtimeType{$id: $description}';
  }
}
