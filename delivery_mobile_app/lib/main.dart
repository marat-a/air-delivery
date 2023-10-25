import 'package:flutter/material.dart' hide DatePickerTheme;

import 'orderListPage.dart';

void main() => runApp(const MaterialApp(
  debugShowCheckedModeBanner: false,
      title: 'AirDelivery',
      home: OrderListPage(),
    ));

