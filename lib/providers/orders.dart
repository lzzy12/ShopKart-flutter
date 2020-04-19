import 'package:flutter/foundation.dart';
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/rest/orders.dart';

class OrdersProvider with ChangeNotifier {
  List<Order> get items => [..._items];
  var _items = <Order>[];
  final _client = OrderHttpClient();

  Order findOrderById(String id) {
    return _items.firstWhere((e) {
      if (e.id == id) return true;
      return false;
    });
  }

  Future<void> fetch() async {
    _items = await _client.getAll();
    _items.forEach((e) {
      print(e.toMap());
    });
  }

  Future<void> addOrder(Order o) async {
    try {
      final order = await _client.placeOrder(o);
      _items.add(order);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void cancelOrder(String orderId) async {
    final i = _items.indexWhere((e) {
      return (e.id == orderId);
    });
    var order = _items[i];
    _items.removeAt(i);
    notifyListeners();
    try {
      await _client.cancelOrder(orderId);
    } catch (e) {
      _items.insert(i, order);
      throw e;
    }
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
