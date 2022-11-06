import 'package:flutter/material.dart';
import 'package:shopping_list/models/product.dart';

class ProductSelectList extends StatelessWidget {
  final List<Product> products;

  const ProductSelectList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    products.sort((a, b) => a.description.compareTo(b.description));

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: (products.length * 2) - 1,
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();

        final index = i ~/ 2;

        return ListTile(
          title: Text(
            products[index].description,
          ),
        );
      },
    );
  }
}
