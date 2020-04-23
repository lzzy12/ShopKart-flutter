import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/favorite.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth/AuthScreen.dart';
import 'package:shop_app/screens/order/OrderScreen.dart';
import 'package:shop_app/screens/product_details/ProductDetailsScreen.dart';
import 'package:shop_app/screens/products/ProductsScreen.dart';
import 'package:shop_app/screens/user_products/EditProductFormScreen.dart';
import 'package:shop_app/screens/user_products/UserProductsScreen.dart';

import 'screens/cart/CartScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (ctx) => ProductsProvider(),
          update: (ctx, auth, state) => ProductsProvider(
              userId: auth.userId,
              authToken: auth.token,
              items: state.products),
        ),
        ChangeNotifierProxyProvider<Auth, OrdersProvider>(
          create: (ctx) => OrdersProvider(),
          update: (ctx, auth, child) =>
              OrdersProvider(authToken: auth.token, userId: auth.userId),
        ),
        ChangeNotifierProvider.value(
          value: FavoritesProvider(),
        ),
        ChangeNotifierProvider.value(value: CartProvider()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ShopKart',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.blue,
          ),
          home: ProductsScreen(),
          routes: {
            AuthScreen.route: (_) => AuthScreen(),
            OrderScreen.route: (_) =>
            auth.loggedIn
                ? OrderScreen()
                : AuthScreen(),
            ProductDetailsScreen.route: (_) => ProductDetailsScreen(),
            CartScreen.route: (_) =>
            auth.loggedIn
                ? CartScreen()
                : AuthScreen(),
            UserProductsScreen.route: (_) =>
            auth.loggedIn
                ? UserProductsScreen()
                : AuthScreen(),
            EditProductFormScreen.route: (_) =>
            auth.loggedIn
                ? EditProductFormScreen()
                : AuthScreen(),
          },
        ),
      ),
    );
  }
}
