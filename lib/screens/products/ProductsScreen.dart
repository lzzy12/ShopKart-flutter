import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/favorites/FavoritesScreen.dart';

import './ProductListElement.dart';
import '../../common/ShopKartDrawer.dart';
import '../cart/CartScreen.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ShopKart'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.route),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () =>
                  Navigator.of(context).pushNamed(FavoritesScreen.route),
            ),
          )
        ],
      ),
      drawer: ShopKartDrawer(),
      body: ChangeNotifierProvider(
        create: (_) => ProductsProvider(),
        child: ProductsGrid(),
      ),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductsProvider>(context).products;

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
