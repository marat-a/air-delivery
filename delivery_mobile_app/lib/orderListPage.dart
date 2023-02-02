import 'package:flutter/material.dart';

import 'cards.dart';
import 'model/order.dart';
import 'newOrderForm.dart';
import 'orderRepository.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  late Future<List<Order>> futureListOfOrder;
  Repository repo = Repository();
  Cards _card(Order order) => Cards(order: order);

  @override
  void initState() {
    super.initState();
    futureListOfOrder = repo.fetchListOfOrders();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AirDelivery',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
              bodyText1: TextStyle(fontSize: 18.0, color: Colors.black),
              bodyText2: TextStyle(fontSize: 16.0, color: Colors.black),

              button: TextStyle(fontSize: 16.0),
          ),

        ),
        home: Scaffold(
          appBar:
              AppBar(title: const Text('ЗаказШаровЕКБ.RU'), actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.cloud_download),
                tooltip: 'Спарсить заказы',
                onPressed: () {
                  setState(() {
                    futureListOfOrder = repo.parseOrderFromFile();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Парсинг начался')));
                }),
            IconButton(
              icon: const Icon(Icons.update),
              tooltip: 'Обновить заказы',
              onPressed: () {
                setState(() {
                  futureListOfOrder = repo.fetchListOfOrders();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Обновление началось')));
              },
            )
          ]),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<List<Order>>(
                future: futureListOfOrder,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final order = snapshot.data;
                    return ListView(
                        children: List.generate(snapshot.data!.length,
                            (index) => _card(order![index])));
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewOrderFormPage()))
                  .then((value) {
                if (value is OrderAddSuccess) {
                  setState(() {
                    futureListOfOrder = repo.fetchListOfOrders();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("заказ успешно добавлен")));
                }
              });
            },
          ),
        ));
  }
}
