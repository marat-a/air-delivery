import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'detailScreen.dart';
import 'model/order.dart';

class Cards extends StatelessWidget {
  final Order order;

  const Cards({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime startTime = order.delivery.deliveryTime.startTime;
    final DateTime endTime = order.delivery.deliveryTime.endTime;
    final String address = order.delivery.address;
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          SizedBox(
            child: InkWell(
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Column(children: [
                        Text(DateFormat('dd MMM').format(startTime),
                            style: textTheme.bodyText1),
                        const VerticalDivider(
                          color: Colors.grey,
                          width: 5,
                        ),
                        Text(
                            "${DateFormat('Hm').format(startTime)} - ${DateFormat('Hm').format(endTime)}",
                            style: textTheme.bodyText1),
                      ]),
                      const SizedBox(width: 25.0),
                      Text(
                        address,
                        style: textTheme.bodyText1,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(order: order),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
