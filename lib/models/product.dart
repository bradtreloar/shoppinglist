class Product {
  final int? id;
  final String description;
  final String? uom;

  Product({this.id, required this.description, this.uom});

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
        ? 'Product{$description, UOM: $uom}'
        : 'Product{$description}';
  }
}
