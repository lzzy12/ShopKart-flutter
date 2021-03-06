import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/snackbar.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/product_details/ProductDetailsScreen.dart';

import '../../models/Data.dart';
import '../../providers/favorite.dart';

class ProductListElement extends StatelessWidget {
  final Product product;

  ProductListElement(this.product);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoritesProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed(ProductDetailsScreen.route, arguments: product.id),
      child: GridTile(
        child: FadeInImage(
          image: NetworkImage(product.imageUrl),
          fit: BoxFit.cover,
          placeholder: AssetImage('assets/images/image_loading.png'),
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
                onPressed: () {
                  cartProvider.addProduct(product);
                  MySnackBar('Product added to cart')
                    ..show(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
