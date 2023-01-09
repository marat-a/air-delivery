import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'Cards.dart';
import 'order.dart';


Future<Order> fetchOrder(int id) async {
  final response = await http.get(Uri.parse("http://83.222.10.86:8080/order/$id"));
  if (response.statusCode == 200) {
    return Order.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load order');
  }
}
Future<List<Order>> fetchListOfOrders() async {
  final response = await http.get(Uri.parse("http://83.222.10.86:8080/order"));
  if (response.statusCode == 200) {
    return List<Order>.from(json.decode(response.body).map((v) => Order.fromJson(v)));
  } else {
    throw Exception('Failed to load order');
  }
}








void main() => runApp(const ListOfOrder());


class ListOfOrder extends StatefulWidget {
  const ListOfOrder({super.key});

  @override
  State<ListOfOrder> createState() => _ListOfOrderState();
}


class _ListOfOrderState extends State<ListOfOrder> {
  late Future<List<Order>> futureListOfOrder;

  @override
  void initState() {
    super.initState();
    futureListOfOrder = fetchListOfOrders();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirDelivery',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ЗаказШаровЕКБ.RU'),
        ),
        body: Center(child: Padding(
        padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<Order>>(
            future: futureListOfOrder,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final order = snapshot.data;
                return ListView(
                    children: List.generate(snapshot.data!.length, (index) => _card(order![index])));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    ));
  }
}

Cards _card(Order order) => Cards(
  order: order
);



