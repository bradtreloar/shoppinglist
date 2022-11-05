import 'package:shopping_list/models/model.dart';

class Product extends Model {
  final String description;
  final String? uom;

  Product({required id, required this.description, this.uom}) : super(id: id);

  Product.fromMap(Map<String, dynamic> map)
      : description = map['description'],
        uom = map['uom'],
        super(id: map['id']);

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
