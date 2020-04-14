import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ProductListElement.dart';
import '../../providers/favorite.dart';
import '../../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool favoriteOnly;

  ProductsGrid(this.favoriteOnly);

  @override
  Widget build(BuildContext context) {
    final products = favoriteOnly
        ? Provider.of<FavoritesProvider>(context).items
        : Provider.of<ProductsProvider>(context).products;
    return Builder(
      builder: (context) => GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            Scaffold.of(context).openDrawer();
          }
        },
        child: Container(
          margin: EdgeInsets.all(8),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20),
            itemCount: products.length,
            itemBuilder: (context, i) {
              return ProductListElement(products[i]);
            },
          ),
        ),
      ),
    );
  }
}
