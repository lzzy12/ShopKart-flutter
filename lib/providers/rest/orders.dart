import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/rest/SECRETS.dart';
import 'package:shop_app/providers/rest/http_exception.dart';
import 'package:shop_app/providers/rest/products.dart';

class OrderHttpClient {
  static final _instance = OrderHttpClient._internal();
  String userId, authToken;
  static const baseUrl = "https://$FIREBASE_PROJECT_ID.firebaseio.com/orders";

  factory OrderHttpClient(String userId, String authToken) {
    _instance.userId = userId;
    _instance.authToken = authToken;
    return _instance;
  }

  OrderHttpClient._internal();

  Future<List<Order>> getAll() async {
    final uri = baseUrl + '/$userId.json?auth=$authToken';
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final list = <Order>[];
      final response = json.decode(res.body);
      if (response == null) return list;
      final _productsClient = ProductsHttpClient();
      final client = http.Client();
      for (var entry in response.entries) {
        final productIds = List<String>.from(entry.value['products']);
        final products =
            await _productsClient.getAllById(productIds, client: client);
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
    final uri = baseUrl + '/$userId/${o.id}.json?auth=$authToken';
    final res = await http.put(uri, body: o.toJson());
    if (res.statusCode == 200) {
      o.id = json.decode(res.body)['name'];
      return o;
    } else {
      throw RestApiException(res.body, res.statusCode);
    }
  }

  Future<void> cancelOrder(String orderId) async {
    final uri = baseUrl + '/$userId/$orderId.json?auth=$authToken';
    final res = await http.delete(uri);
    if (res.statusCode != 200) throw RestApiException(res.body, res.statusCode);
  }
}
