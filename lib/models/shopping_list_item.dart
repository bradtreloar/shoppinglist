class ShoppingListItem {
  final int productId;
  final int quantity;

  ShoppingListItem({required this.productId, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'ShoppingListItem{productId: $productId, quantity: $quantity}';
  }
}
