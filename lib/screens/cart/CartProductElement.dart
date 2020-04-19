import 'package:flutter/material.dart';

import '../../models/Data.dart';
import '../product_details/ProductDetailsScreen.dart';

class CartProductElement extends StatelessWidget {
  final Product product;

  CartProductElement(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailsScreen.route, arguments: product.id),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              product.imageUrl,
              height: 56,
              width: 56,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(product.name),
          trailing: Text('₹ ${product.price}'),
        ),
      ),
    );
  }
}
