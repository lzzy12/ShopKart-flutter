import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/favorite.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/favorites/FavoritesScreen.dart';
import 'package:shop_app/screens/order/OrderScreen.dart';
import 'package:shop_app/screens/product_details/ProductDetailsScreen.dart';
import 'package:shop_app/screens/products/ProductsScreen.dart';

import 'screens/cart/CartScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ShopKart',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
        ),
        routes: {
          '/': (_) => ProductsScreen(),
          OrderScreen.route: (_) => OrderScreen(),
          ProductDetailsScreen.route: (_) => ProductDetailsScreen(),
          CartScreen.route: (_) => CartScreen(),
          FavoritesScreen.route: (_) => FavoritesScreen()
        },
      ),
    );
  }
}
