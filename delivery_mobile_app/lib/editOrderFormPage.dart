import 'package:delivery_mobile_app/model/customer.dart';
import 'package:delivery_mobile_app/model/delivery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'model/order.dart';
import 'orderController.dart';

class EditOrderFormPage extends StatefulWidget {
  final Order orderForUpdate;

  const EditOrderFormPage({super.key, required this.orderForUpdate});

  @override
  EditOrderFormPageState createState() => EditOrderFormPageState();
}

class EditOrderFormPageState extends State<EditOrderFormPage> {
  late Order order;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController orderCommentController;
  late TextEditingController commentController;
  late TextEditingController addressController;
  late TextEditingController costController;
  late TextEditingController sumController;
  late DateTime selectedStartTime;
  late DateTime selectedEndTime;
  late String transferType;

  OrderController? _controller;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    order = widget.orderForUpdate;
    nameController = TextEditingController(text: order.customer.name);
    phoneController = TextEditingController(text: order.customer.phone);
    emailController = TextEditingController(text: order.customer.email);
    orderCommentController = TextEditingController(text: order.orderComment);
    commentController = TextEditingController(text: order.delivery.comment);
    addressController = TextEditingController(text: order.delivery.address);
    costController =
        TextEditingController(text: order.delivery.cost.toString());
    sumController = TextEditingController(text: order.sum.toString());
    selectedStartTime = order.delivery.deliveryTime.startTime;
    selectedEndTime = order.delivery.deliveryTime.endTime;
    transferType = order.transferType;
    _controller = OrderController();
  }

  EditOrderFormPageState();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Редактировать заказ"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final orderUpdated = Order(
                  id: order.id,
                  customer: Customer(
                      name: nameController.text,
                      phone: phoneController.text,
                      email: emailController.text),
                  transferType: transferType.toString(),
                  delivery: Delivery(
                      deliveryTime: DeliveryTime(
                          startTime: selectedStartTime,
                          endTime: selectedEndTime),
                      comment: commentController.text,
                      address: addressController.text,
                      cost: double.parse(costController.text)),
                  orderComment: orderCommentController.text,
                  sum: double.parse(sumController.text),
                );

                _controller!.editOrder(orderUpdated, (status) {
                  if (status is OrderUpdateSuccess) {
                    Navigator.pop(context, orderUpdated);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Ошибка при изменении заказа")));
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
                  groupValue: transferType,
                  onChanged: (String? value) {
                    setState(() {
                      transferType = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: const Text('Самовывоз'),
                  value: "PICKUP",
                  groupValue: transferType,
                  onChanged: (String? value) {
                    setState(() {
                      transferType = value!;
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
                        selectedStartTime = date;
                      }, onConfirm: (date) {
                        setState(() {
                          selectedStartTime = date;
                        });
                      }, currentTime: selectedStartTime, locale: LocaleType.ru);
                    },
                    child: Text(
                      DateFormat('EE, dd MMMM      HH:mm', 'ru_RU')
                          .format(selectedStartTime),
                      style:
                          TextStyle(color: Colors.blue.shade700, fontSize: 18),
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
                        selectedEndTime = date;
                      }, onConfirm: (date) {
                        setState(() {
                          selectedEndTime = date;
                        });
                      }, currentTime: selectedEndTime, locale: LocaleType.ru);
                    },
                    child: Text(
                      DateFormat.Hm('ru_RU').format(selectedEndTime),
                      style:
                          TextStyle(color: Colors.blue.shade700, fontSize: 18),
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
