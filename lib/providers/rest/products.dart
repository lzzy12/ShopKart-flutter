import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/rest/SECRETS.dart';
import 'package:shop_app/providers/rest/http_exception.dart';

class ProductsHttpClient {
  static final ProductsHttpClient _instance = ProductsHttpClient._internal();
  String token;
  String userId;
  static const baseUrl = "$FIREBASE_PROJECT_ID.firebaseio.com";

  factory ProductsHttpClient({String token, String userId}) {
    _instance.token = token;
    _instance.userId = userId;
    return _instance;
  }

  ProductsHttpClient._internal();

  Future<void> addProduct(Product p) async {
    if (p.userId == null) throw RestApiException("Invalid userId", 401);
    final query = {'auth': token};
    print('token: $token');
    final uri = Uri.https(baseUrl, '/products/${p.id}.json', query);
    final res = await http.put(uri, body: p.toJson());
    if (res.statusCode != 200) {
      throw RestApiException(res.body, res.statusCode);
    }
  }

  Future<List<Product>> getAll({bool filterByUid = false}) async {
    String uri = 'https://$baseUrl/products.json';
    if (filterByUid) uri += '?orderBy="userId"&equalTo="$userId"';
    final res = await http.get(uri);
    final items = <Product>[];
    if (res.body == "null") return items;
    print(res.body);
    json.decode(res.body).forEach((key, value) {
      items.add(Product.fromMap(value));
    });
    return items;
  }

  Future<List<Product>> getAllById(List<String> ids,
      {http.Client client}) async {
    final mClient = client != null ? client : http.Client();
    final list = <Product>[];
    for (var id in ids) {
      final uri = Uri.https(baseUrl, '/products/$id.json');
      final res = await mClient.get(uri);
      if (res.statusCode == 200) {
        try {
          final product = Product.fromMap(json.decode(res.body));
          product.id = id;
          list.add(product);
        } catch (e) {
          print(e.toString());
        }
      } else {
        throw RestApiException(res.body, res.statusCode);
      }
    }
    return list;
  }

  Future<void> editProduct(Product newProduct) async {
    final query = {
      'auth': token,
    };
    final uri = Uri.https(baseUrl, '/products/${newProduct.id}.json', query);
    print(uri.toString());
    final res = await http.patch(uri, body: newProduct.toJson());
    if (res.statusCode != 200) {
      throw RestApiException(res.body, res.statusCode);
    }
  }

  Future<void> deleteProduct(String id) async {
    final query = {
      'auth': token,
    };
    final url = Uri.https(baseUrl, '/products/$id.json', query);
    final res = await http.delete(url);
    if (res.statusCode != 200) {
      throw RestApiException(res.body, res.statusCode);
    }
  }

  Future<Product> getProduct(String id) async {
    final url = Uri.https(baseUrl, '/products/$id.json');
    final res = await http.get(url);
    if (res.statusCode != 200) throw RestApiException(res.body, res.statusCode);
    return Product.fromMap(json.decode(res.body));
  }
}
