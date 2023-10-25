import 'package:delivery_mobile_app/model/customer.dart';
import 'package:delivery_mobile_app/model/delivery.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'model/order.dart';
import 'orderController.dart';

class NewOrderFormPage extends StatefulWidget {
  const NewOrderFormPage({super.key});

  @override
  NewOrderFormPageState createState() => NewOrderFormPageState();
}

class NewOrderFormPageState extends StateMVC {
  DateTime _selectedStartTime = DateTime.now();
  DateTime _selectedEndTime = DateTime.now();
  OrderController? _controller;
  String _transferType = "DELIVERY";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  NewOrderFormPageState() : super(OrderController()) {
    _controller = controller as OrderController;
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController transferTypeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController orderCommentController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController sumController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавить заказ"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final order = Order(
                  customer: Customer(
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text),
                  transferType: _transferType.toString(),
                  delivery: Delivery(
                      deliveryTime: DeliveryTime(
                          startTime: _selectedStartTime,
                          endTime: _selectedEndTime),
                      comment: commentController.text,
                      address: addressController.text,
                      cost: double.parse(costController.text)),
                  orderComment: orderCommentController.text,
                  sum: double.parse(sumController.text),
                );
                _controller!.addOrder(order, (status) {
                  if (status is OrderAddSuccess) {
                    Navigator.pop(context, status);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Ошибка при добавлении заказа")));
                  }
                });
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
        child: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.face),
                    hintText: "Имя"),
                controller: nameController,
              ),
            ),
            const VerticalDivider(
              color: Colors.black,
              thickness: 1,
            ),
            Expanded(
              child: TextFormField(
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                  hintText: "Телефон",
                ),
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  const pattern =
                      r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
                  final regExp = RegExp(pattern);

                  if (!regExp.hasMatch(value)) {
                    return "Неправильный формат телефона";
                  }
                  return null;
                },
              ),
            )
          ]),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Вид доставки:',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: const Text('Доставка'),
                  value: "DELIVERY",
                  groupValue: _transferType,
                  onChanged: (String? value) {
                    setState(() {
                      _transferType = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: const Text('Самовывоз'),
                  value: "PICKUP",
                  groupValue: _transferType,
                  onChanged: (String? value) {
                    setState(() {
                      _transferType = value!;
                    });
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: null,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.alternate_email_outlined),
              hintText: "email",
            ),
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              if (value.length < 3) {
                return "Используйте не менее 3 символов";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Row(children: [
            Column(
              children: [
                TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onChanged: (date) {
                        _selectedStartTime = date;
                      }, onConfirm: (date) {
                        setState(() {
                          _selectedStartTime = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.ru);
                    },
                    child: Text(
                      DateFormat('EE, dd MMMM      HH:mm', 'ru_RU')
                          .format(_selectedStartTime),
                      style:  TextStyle(color: Colors.blue.shade700, fontSize: 18),
                    ))
              ],
            ),
            const VerticalDivider(
              color: Colors.black,
              thickness: 1,
            ),
            Column(
              children: [
                TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true, onChanged: (date) {
                        _selectedEndTime = date;
                      }, onConfirm: (date) {
                        setState(() {
                          _selectedEndTime = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.ru);
                    },
                    child: Text(
                      DateFormat.Hm('ru_RU').format(_selectedEndTime),
                      style:  TextStyle(color: Colors.blue.shade700, fontSize: 18),
                    ))
              ],
            ),
          ]),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.comment),
                hintText: "Комментарий для доставки"),
            // указываем TextEditingController
            controller: commentController,
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
                hintText: "Адрес доставки"),
            controller: addressController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              if (value.length < 3) {
                return "Используйте не менее 3 символов";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
                hintText: "Стоимость доставки"),
            controller: costController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              var regExp = RegExp(r'^[0-9]+(\.[0-9]*)?$');
              if (regExp.matchAsPrefix(value) == null) {
                return "Используйте только цифры и точку";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.insert_comment_outlined),
                hintText: "Комментарий к заказу"),
            controller: orderCommentController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              if (value.length < 3) {
                return "Используйте не менее 3 символов";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monetization_on_rounded),
                hintText: "Сумма заказа"),
            controller: sumController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              var regExp = RegExp(r'^[0-9]+(\.[0-9]*)?$');
              if (regExp.matchAsPrefix(value) == null) {
                return "Используйте только цифры и точку";
              }
              return null;
            },
          ),
        ],
      ),
    ));
  }


}
