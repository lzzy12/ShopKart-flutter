import 'package:flutter/foundation.dart';
import 'package:shop_app/models/Data.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> get items => [..._items];
  final _items = <Order>[];

  Order findOrderById(String id) {
    return _items.firstWhere((e) {
      if (e.id == id) return true;
      return false;
    });
  }

  void addOrder(Order o) {
    _items.add(o);
    notifyListeners();
  }

  void cancelOrder(String orderId) {
    _items.removeWhere((e) {
      return (e.id == orderId);
    });
    notifyListeners();
  }

  double getTotalAmount(String orderId) {
    final order = findOrderById(orderId);
    if (order != null) {
      double r = 0;
      for (var p in order.products) {
        r += p.price;
      }
      return r;
    }
    return 0.0;
  }

}
