import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shop_app/models/Data.dart';

class ProductsHttpClient {
  static const ProductsHttpClient _instance = ProductsHttpClient._internal();
  static const baseUrl =
      "https://project-flutter-6cd88.firebaseio.com/products";

  factory ProductsHttpClient() {
    return _instance;
  }

  const ProductsHttpClient._internal();

  Future<http.Response> addProduct(Product p) async {
    try {
      return await http.post('$baseUrl.json', body: p.toJson());
    } catch (e) {
      throw e;
    }
  }

  Future<List<Product>> getAll() async {
    try {
      final res = await http.get('$baseUrl.json');
      final items = <Product>[];
      json.decode(res.body).forEach((key, value) {
        value['id'] = key;
        items.add(Product.fromMap(value));
      });
      return items;
    } catch (e) {
      throw e;
    }
  }

  Future editProduct(Product newProduct) async {
    try {
      return await http.patch('$baseUrl/${newProduct.id}',
          body: newProduct.toJson());
    } catch (e) {
      throw e;
    }
  }

  Future deleteProduct(String id) async {
    try {
      return http.delete('$baseUrl/$id.json');
    } catch (e) {
      throw e;
    }
  }

  Future<Product> getProduct(String id) async {
    final res = await http.get('$baseUrl/$id.json');
    final product = Product.fromMap(json.decode(res.body));
    product.id = id;
    return product;
  }
}