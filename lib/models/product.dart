class Product {
  final String description;
  final String? uom;

  Product({required this.description, this.uom});

  Map<String, dynamic> toMap() {
    return {
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
