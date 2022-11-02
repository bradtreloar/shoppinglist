class Product {
  final int? id;
  final String description;
  final String? uom;

  Product({this.id, required this.description, this.uom});

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'], description: map['description'], uom: map['uom']);
  }

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
        ? 'Product{$id: $description, UOM: $uom}'
        : 'Product{$id: $description}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          description == other.description &&
          uom == other.uom;

  @override
  int get hashCode => id.hashCode ^ description.hashCode ^ uom.hashCode;
}
