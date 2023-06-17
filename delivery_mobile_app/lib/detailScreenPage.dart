import 'package:delivery_mobile_app/editOrderFormPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/order.dart';

class DetailScreenPage extends StatefulWidget {
  final Order order;

  const DetailScreenPage({super.key, required this.order});

  @override
  DetailScreenPageState createState() => DetailScreenPageState();
}

class DetailScreenPageState extends State<DetailScreenPage> {
  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  DetailScreenPageState();

  @override
  Widget build(BuildContext context) {
    IconData getTransferIcon(String? transferType) {
      if (transferType == "DELIVERY") {
        return Icons.local_shipping_outlined;
      }
      if (transferType == "PICKUP") {
        return Icons.storefront_outlined;
      } else {
        return Icons.question_mark_outlined;
      }
    }

    final startTime =
        DateFormat('Hm').format(_order.delivery.deliveryTime.startTime);
    final endTime =
        DateFormat('Hm').format(_order.delivery.deliveryTime.endTime);
    final phone = _order.customer.phone;

    return WillPopScope(
        onWillPop:  () async {
          Navigator.pop(context, _order);
          return true;
        },
        child: SelectionArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('ЗаказШаровЕКБ.RU'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.mode_edit_outlined),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditOrderFormPage(
                                  orderForUpdate: _order,
                                ))).then((value) {
                      if (value is Order) {
                        setState(() {
                          _order = value;

                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Ошибка при изменении заказа")));
                      }
                    });
                  },
                )
              ],
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Icon(
                            getTransferIcon(_order.transferType),
                            size: 40,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 15.0),
                          Text(
                            "$startTime - $endTime",
                          )
                        ],
                      ),
                      const Divider(
                        thickness: 5,
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_android_outlined,
                            color: Colors.blue,
                            size: 40,
                          ),
                          const SizedBox(width: 15.0),
                          Expanded(
                              child: Text(
                            phone,
                          )),
                          const SizedBox(width: 10.0),
                          ElevatedButton(
                            onPressed: () async {
                              final call = Uri.parse("tel:$phone");
                              if (await canLaunchUrl(call)) {
                                launchUrl(call);
                              } else {
                                throw 'Could not launch $call';
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const CircleBorder(),
                              ),
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              String phoneNumber = phone.substring(1);
                              String message = "Здравствуйте. Это доставка шаров. ";
                              final call = Uri.parse(
                                  "https://wa.me/$phoneNumber?text=$message");
                              if (await canLaunchUrl(call)) {
                                launchUrl(call,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                throw 'Could not launch $call';
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const CircleBorder(),
                              ),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 5,
                        color: Colors.white,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 40,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 15.0),
                          Expanded(
                              child: Text(
                            _order.delivery.address,
                          )),
                          ElevatedButton(
                            onPressed: () async {
                              final address = Uri.parse(
                                  "yandexnavi://map_search?text=${_order.delivery.address}");
                              if (await canLaunchUrl(address)) {
                                launchUrl(address);
                              } else {
                                throw 'Could not launch $address';
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const CircleBorder(),
                              ),
                            ),
                            child: const Icon(
                              Icons.navigation,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 5,
                        color: Colors.white,
                      ),
                      Row(children: [
                        const Icon(
                          Icons.monetization_on_outlined,
                          size: 40,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: Text(
                            "${_order.sum} руб.",
                          ),
                        )
                      ]),
                      const Divider(
                        thickness: 5,
                        color: Colors.white,
                      ),
                      Row(children: [
                        const Icon(
                          Icons.comment_outlined,
                          size: 40,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: Text(
                            _order.orderComment,
                          ),
                        )
                      ]),
                    ]))))));
  }
}
