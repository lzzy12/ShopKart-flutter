import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/Data.dart';

class OrdersElement extends StatelessWidget {
  final Order order;

  OrdersElement(this.order);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('₹ ${order.amount.toStringAsFixed(2)}'),
      subtitle: Text(
        '${DateFormat('dd/MM/yyyy HH:mm').format(order.dateTime)}',
        style: TextStyle(color: Colors.grey),
      ),
      children: <Widget>[
        ...order.products.map((e) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  e.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${e.price}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
          );
        }).toList()
      ],
    );
  }
}
