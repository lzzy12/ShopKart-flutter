import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/rest/http_exception.dart';
import 'package:shop_app/providers/rest/products.dart';

class OrderHttpClient {
  static final _instance = OrderHttpClient._internal();
  static const baseUrl = "https://project-flutter-6cd88.firebaseio.com/orders";

  factory OrderHttpClient() {
    return _instance;
  }

  OrderHttpClient._internal();

  Future<List<Order>> getAll() async {
    final res = await http.get('$baseUrl.json');
    if (res.statusCode == 200) {
      final list = <Order>[];
      final _client = ProductsHttpClient();
      for (var entry in json.decode(res.body).entries) {
        final productIds = List<String>.from(entry.value['products']);
        final products = await _client.getAllById(productIds);
        final map = {
          'id': entry.key,
          'products': products,
          'dateTime':
              DateTime.fromMillisecondsSinceEpoch(entry.value['dateTime'])
        };
        list.add(Order.fromMap(map));
      }
      return list;
    } else {
      throw RestApiException(res.body, res.statusCode);
    }
  }

  Future<Order> placeOrder(Order o) async {
    final res = await http.post('$baseUrl.json', body: o.toJson());
    if (res.statusCode == 200) {
      o.id = json.decode(res.body)['name'];
      return o;
    } else {
      throw RestApiException(res.body, res.statusCode);
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final res = await http.delete('$baseUrl/$orderId.json');
    if (res.statusCode != 200) throw RestApiException(res.body, res.statusCode);
  }
}
