import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/snackbar.dart';
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/user_products/EditProductFormScreen.dart';

import '../product_details/ProductDetailsScreen.dart';

class UserProductElement extends StatelessWidget {
  final Product product;

  UserProductElement(this.product);

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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.of(context)
                    .pushNamed(EditProductFormScreen.route, arguments: product)
                    .then((data) {
                  if (data != null) MySnackBar('Saved')..show(context);
                }),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) =>
                        AlertDialog(
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Yes'),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                                  ),
                                  FlatButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  )
                                ],
                                title: Text(
                                    'Are you sure to delete this product?'),
                              ),
                          barrierDismissible: false)
                      .then((data) {
                    if (data) {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              content: CircularProgressIndicator(),
                            );
                          });
                      Provider.of<ProductsProvider>(context, listen: false)
                          .deleteProduct(product.id)
                          .catchError((e) {
                        MySnackBar('API fucked up').show(context);
                      }).then((_) {
                        Navigator.of(context).pop();
                      });
                    }
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
