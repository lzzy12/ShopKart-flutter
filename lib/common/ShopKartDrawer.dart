import 'package:flutter/material.dart';
import 'package:shop_app/screens/order/OrderScreen.dart';

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
          SizedBox(
            height: 16,
          ),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.credit_card),
            onTap: () =>
                Navigator.pushReplacementNamed(context, OrderScreen.route),
          )
        ],
      ),
    );
  }
}
