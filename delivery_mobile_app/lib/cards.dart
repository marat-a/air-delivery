import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'detailScreenPage.dart';
import 'model/order.dart';

class Cards extends StatefulWidget {
  final Order order;

  const Cards({Key? key, required this.order}) : super(key: key);

  @override
  CardsState createState() => CardsState();
}

class CardsState extends State<Cards> {
  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  CardsState();

  @override
  Widget build(BuildContext context) {
    final DateTime startTime = _order.delivery.deliveryTime.startTime;
    final DateTime endTime = _order.delivery.deliveryTime.endTime;
    final String address = _order.delivery.address;

    String printBeforeIfTimeIsMidnight(DateTime startTime) {
      if (startTime.hour == 0 && startTime.minute == 0) {
        return "до";
      } else {
        return "${DateFormat('Hm').format(startTime)} -";
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
                  Text(DateFormat('dd MMM').format(startTime)),
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
              builder: (context) => DetailScreenPage(order: _order),
            ),
          ).then((value) {
            if (value is Order) {
              setState(() {
                _order = value;
              });
            }
          });
        },
      ),
    );
  }
}
