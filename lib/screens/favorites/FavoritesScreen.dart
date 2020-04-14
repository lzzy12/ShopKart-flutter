import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_details/ProductDetailsScreen.dart';

import '../../providers/favorite.dart';

class FavoritesScreen extends StatelessWidget {
  static const route = "/favorites";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoritesProvider>(context);
    final favorites = provider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Wish List'),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (ctx, i) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () => Navigator.of(context).pushNamed(
                        ProductDetailsScreen.route,
                        arguments: favorites[i]),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        favorites[i].imageUrl,
                        height: 56,
                        width: 56,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: Text(favorites[i].name),
                    trailing: Text('₹ ${favorites[i].price}'),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
