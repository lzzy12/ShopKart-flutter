import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/favorite.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/order/OrderScreen.dart';
import 'package:shop_app/screens/product_details/ProductDetailsScreen.dart';
import 'package:shop_app/screens/products/ProductsScreen.dart';
import 'package:shop_app/screens/user_products/AddProductBottomSheet.dart';
import 'package:shop_app/screens/user_products/UserProductsScreen.dart';

import 'screens/cart/CartScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ProductsProvider()),
        ChangeNotifierProvider.value(value: OrdersProvider()),
        ChangeNotifierProvider.value(
          value: FavoritesProvider(),
        ),
        ChangeNotifierProvider.value(value: CartProvider())
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
          UserProductsScreen.route: (_) => UserProductsScreen(),
          EditProductFormScreen.route: (_) => EditProductFormScreen(),
        },
      ),
    );
  }
}
