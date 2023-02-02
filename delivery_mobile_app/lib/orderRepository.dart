import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model/order.dart';

const String SERVER = "http://83.222.10.86:8080";
// const String SERVER = "http://localhost:8080";
class Repository {
  Future<Order> fetchOrder(int id) async {
    final response =
        await http.get(Uri.parse("$SERVER/order/$id"));
    if (response.statusCode == 200) {
      return Order.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load order');
    }
  }

  Future<List<Order>> parseOrderFromFile() async {
    final response =
    await http.post(Uri.parse("$SERVER/order/parse"), headers: {"Accept": "application/json",
      "Access-Control_Allow_Origin": "*"});
    if (response.statusCode == 200) {
      return List<Order>.from(
          json.decode(response.body).map((v) => Order.fromJson(v)));
    } else {
      throw Exception('Failed to load order');
    }
  }

  Future<List<Order>> fetchListOfOrders() async {
    final response =
        await http.get(Uri.parse("$SERVER/order"), headers: {"Accept": "application/json",
          "Access-Control_Allow_Origin": "*"});
    if (response.statusCode == 200) {
      return List<Order>.from(
          json.decode(response.body).map((v) => Order.fromJson(v)));
    } else {
      throw Exception('Failed to load order');
    }
  }


  Future<OrderList> fetchOrders() async {
    final url = Uri.parse("$SERVER/order");
    final response = await http.get(url, headers: {"Accept": "application/json",
        "Access-Control_Allow_Origin": "*"});
    if (response.statusCode == 200) {
      return OrderList.fromJson(json.decode(response.body));
    } else {
      throw Exception("failed request");
    }
  }

  Future<OrderAdd> addOrder(Order order) async {
    final url = Uri.parse("$SERVER/order");
    final response = await http.post(
        url,
        headers: {"Content-Type": "application/json", "Access-Control_Allow_Origin": "*"},
        body: jsonEncode(order.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return OrderAddSuccess();
    } else {
      return OrderAddFailure();
    }
  }
  Future<OrderUpdate> updateOrder(Order order) async {
    final url = Uri.parse("$SERVER/order");
    final response = await http.put(
        url,
        headers: {"Content-Type": "application/json", "Access-Control_Allow_Origin": "*"},
        body: jsonEncode(order.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return OrderUpdateSuccess();
    } else {
      return OrderUpdateFailure();
    }
  }
}
