import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/snackbar.dart';

import '../../models/Data.dart';
import '../../providers/cart.dart';
import '../../providers/products.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const route = "/product-details";

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product product;

  Future<Product> fetchProduct(String id) async {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    try {
      product = await productProvider.findProductById(id);
      setState(() {});
      return product;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final id = ModalRoute.of(context).settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final productProvider = Provider.of<ProductsProvider>(context);

    return FutureBuilder(
      future: fetchProduct(id),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Scaffold(
            appBar: AppBar(title: Text('Oops!')),
            body: Center(
              child: Text(
                  'An Error occured while fetching data. Check your internet connection or try again later!'),
            ),
          );
        if (!snapshot.hasData)
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        product = snapshot.data as Product;
        return Scaffold(
          appBar: AppBar(
            title: Text(product.name),
          ),
          body: RefreshIndicator(
            onRefresh: () => productProvider.findProductById(product.id),
            child: Container(
              margin: EdgeInsets.all(8),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    height: size.height / 3,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ListTile(
                    title: Text(
                      product.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text('₹ ${product.price}'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add_shopping_cart,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        cartProvider.addProduct(product);
                        MySnackBar('Product added to cart')..show(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
