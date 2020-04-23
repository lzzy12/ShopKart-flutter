import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import './ProductsGrid.dart';
import '../../common/ShopKartDrawer.dart';
import '../../providers/products.dart';
import '../cart/CartScreen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var favoriteOnly = false;
  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      try {
        Provider.of<ProductsProvider>(context, listen: false).fetch().then((_) {
          isInit = false;
        });
      } catch (e) {
        showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Oops something went wrong'),
                  content: Text(
                      'There was an error fetching products! Please try again later!'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    )
                  ],
                ));
        Navigator.of(context).pop();
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ShopKart'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(CartScreen.route),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Consumer<CartProvider>(
                      builder: (ctx, provider, __) =>
                          Container(
                            padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                            child: Text(provider.items.length.toString()),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red,
                            ),
                          ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon:
                Icon(favoriteOnly ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    favoriteOnly = !favoriteOnly;
                  });
                },
              ),
            )
          ],
        ),
        drawer: ShopKartDrawer(),
        body: RefreshIndicator(
          child: ProductsGrid(favoriteOnly),
          onRefresh: () =>
              Provider.of<ProductsProvider>(context, listen: false).fetch(),
        ));
  }
}
