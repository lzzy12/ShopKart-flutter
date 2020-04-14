import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_details/ProductDetailsScreen.dart';

import '../../models/Data.dart';
import '../../providers/favorite.dart';

class ProductListElement extends StatelessWidget {
  final Product product;

  ProductListElement(this.product);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoritesProvider>(context);
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(ProductDetailsScreen.route, arguments: product),
      child: GridTile(
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
        footer: Container(
          color: Colors.black54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  provider.isFavorite(product.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: () => provider.toggleFavorite(product.id),
              ),
              Text(
                product.name,
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
