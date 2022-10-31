class Product {
  final String description;
  final int quantity;
  final String? uom;

  Product({required this.description, required this.quantity, this.uom});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
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
