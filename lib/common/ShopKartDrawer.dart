import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/order/OrderScreen.dart';
import 'package:shop_app/screens/user_products/UserProductsScreen.dart';

class ShopKartDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text(
                'ShopKart',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          ListTile(
            title: Text('Shop'),
            leading: Icon(Icons.shop),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          Divider(
            thickness: 1,
          ),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.credit_card),
            onTap: () =>
                Navigator.pushReplacementNamed(context, OrderScreen.route),
          ),
          Divider(
            thickness: 1.0,
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Your Products'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.route),
          ),
          Divider(
            thickness: 1.0,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
