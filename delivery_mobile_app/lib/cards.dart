import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'detailScreenPage.dart';
import 'model/order.dart';

class Cards extends StatelessWidget {
  final Order order;

  const Cards({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime startTime = order.delivery.deliveryTime.startTime;
    final DateTime endTime = order.delivery.deliveryTime.endTime;
    final String address = order.delivery.address;

    String printBeforeIfTimeIsMidnight (DateTime startTime) {
      if (startTime.hour == 0  && startTime.minute == 0) {
        return "до";
      } else {
        return  "${DateFormat('Hm').format(startTime)} -";
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Column(children: [
                  Text(
                      DateFormat('dd MMM').format(startTime)
                  ),
                  Text(
                    "${printBeforeIfTimeIsMidnight(startTime)} ${DateFormat('Hm').format(endTime)}",
                  ),
                ]),
                const SizedBox(width: 25.0),
                Expanded(
                    child: Text(
                  address,
                ))
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreenPage(order: order),
            ),
          );
        },
      ),
    );
  }
}
