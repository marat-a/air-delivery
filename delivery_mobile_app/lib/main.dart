import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

Future<Order> fetchOrder() async {
  final response = await http.get(Uri.parse("http://localhost:8080/order/4"));
  if (response.statusCode == 200) {
    return Order.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load order');
  }
}

class Customer {
  final String name;
  final String phone;
  final String email;

  const Customer(
      {required this.name, required this.phone, required this.email});

  factory Customer.fromJson(Map<String, dynamic> customerJson) {
    return Customer(
        name: customerJson['name'] ?? "",
        phone: customerJson['phone'] ?? "",
        email: customerJson['email'] ?? "");
  }
}

class Delivery {
  final DeliveryTime deliveryTime;
  final String comment;
  final String address;
  final double cost;

  Delivery(
      {required this.deliveryTime,
      required this.comment,
      required this.address,
      required this.cost});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
        deliveryTime: DeliveryTime.fromJson(json['deliveryTime']),
        comment: json['comment'] ?? "",
        address: json['address'] ?? "",
        cost: json['cost'] ?? "");
  }
}

class DeliveryTime {
  DateTime startTime;
  DateTime endTime;

  DeliveryTime({required this.startTime, required this.endTime});

  factory DeliveryTime.fromJson(Map<String, dynamic> json) {
    return DeliveryTime(
        startTime: DateTime.parse(json['startTime']), endTime: DateTime.parse(json['endTime']));
  }
}

class Order {
  int id;
  Customer customer;

  // final List<OrderProduct> orderProducts;
  // final String dateCreated;
  String transferType;
  Delivery delivery;

  // final String status;
  String orderComment;

  // final String payStatus;
  // final String receivingType;
  double sum;

  Order(
      {required this.id,
      required this.customer,
      // required this.orderProducts,
      // required this.dateCreated,
      required this.transferType,
      required this.delivery,
      // required this.status,
      required this.orderComment,
      // required this.payStatus,
      // required this.receivingType,
      required this.sum});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        customer: Customer.fromJson(json['customer']),
        transferType: json['transferType'] ?? "",
        delivery: Delivery.fromJson(json['delivery']),
        orderComment: json['orderComment'] ?? "",
        sum: json['sum'] ?? "");
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Order> futureOrder;

  @override
  void initState() {
    super.initState();
    futureOrder = fetchOrder();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AirDelivery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ЗаказШаровЕКБ.RU'),
        ),
        body: Center(
          child: FutureBuilder<Order>(
            future: futureOrder,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final order = snapshot.data;
                final startTime = DateFormat('hh:mm').format(order!.delivery.deliveryTime.startTime);
                final endTime = DateFormat('hh:mm').format(order.delivery.deliveryTime.endTime);
                final phone = order.customer.phone;
                return Column(children: [
                  Text("Вид: ${order.transferType}"),
                  Row (children: [Text("Время: $startTime - $endTime"),
                    Text("Адрес: ${order.delivery.address}")],),
                  ElevatedButton(
                    onPressed: () async {
                      final call = Uri.parse(phone);
                      if (await canLaunchUrl(call)) {
                        launchUrl(call);
                      } else {
                        throw 'Could not launch $call';
                      }
                    },
                    child: Text(phone),
                  ),
                  Text("Комментарий: ${order.orderComment}"),
                ]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
