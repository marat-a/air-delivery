import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'order.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.order});

  final Order order;

  IconData _getTransferIcon(String transferType) {
    if (transferType == "DELIVERY") {
      return Icons.delivery_dining;
    }
    if (transferType == "PICKUP") {
      return Icons.home_filled;
    } else {
      return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final startTime =
        DateFormat('Hm').format(order.delivery.deliveryTime.startTime);
    final endTime =
        DateFormat('Hm').format(order.delivery.deliveryTime.endTime);
    final phone = order.customer.phone;
    return SelectionArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('ЗаказШаровЕКБ.RU'),
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(
                        children: [
                          const SizedBox(width: 25.0),
                          Icon(
                            _getTransferIcon(order.transferType),
                            size: 30,
                          ),
                          const SizedBox(width: 25.0),
                          const Divider(
                            height: 5,
                          ),
                          Text(
                            "$startTime - $endTime",
                            style: textTheme.headlineSmall!,
                          )
                        ],
                      ),
                      const Divider(
                        height: 5,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final call = Uri.parse("tel:$phone");
                          if (await canLaunchUrl(call)) {
                            launchUrl(call);
                          } else {
                            throw 'Could not launch $call';
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.phone,
                            ),
                            const SizedBox(width: 25.0),
                            Text(phone,
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Ink(
                              decoration: const ShapeDecoration(
                                color: Colors.red,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.location_on),
                                color: Colors.white,
                                splashColor: Colors.black,
                                tooltip: 'Открыть в навигаторе',
                                onPressed: () async {
                                  final address = Uri.parse(
                                      "yandexnavi://map_search?text=${order.delivery.address}");
                                  if (await canLaunchUrl(address)) {
                                    launchUrl(address);
                                  } else {
                                    throw 'Could not launch $address';
                                  }
                                },
                              )),
                          const SizedBox(width: 25.0),
                          Text(order.delivery.address,
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const Divider(
                        height: 5,
                      ),
                      Text(
                        "Сумма: ${order.sum}",
                        style: textTheme.headlineSmall!,
                      ),
                      Text(
                        "Комментарий: ${order.orderComment}",
                        style: textTheme.headlineSmall!,
                      ),
                    ])))));
  }
}
