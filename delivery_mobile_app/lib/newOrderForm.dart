import 'package:delivery_mobile_app/model/customer.dart';
import 'package:delivery_mobile_app/model/delivery.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'model/order.dart';
import 'orderController.dart';

class NewOrderFormPage extends StatefulWidget {
  const NewOrderFormPage({super.key});

  @override
  NewOrderFormPageState createState() => NewOrderFormPageState();
}

class NewOrderFormPageState extends StateMVC {
  DateTime selectedDate = DateTime.now();
  OrderController? _controller;

  NewOrderFormPageState() : super(OrderController()) {
    _controller = controller as OrderController;
  }

  final TextEditingController nameController =
      TextEditingController(text: "Виталик");
  final TextEditingController phoneController =
      TextEditingController(text: "89122341594");
  final TextEditingController emailController =
      TextEditingController(text: "email@ya.ru");
  final TextEditingController orderCommentController =
      TextEditingController(text: "Комментарий к заказу");
  final TextEditingController commentController =
      TextEditingController(text: "Комментарий для курьера");
  final TextEditingController addressController =
      TextEditingController(text: "40-летия Комсомола 18Д");
  final TextEditingController costController =
      TextEditingController(text: "2580.22");
  final TextEditingController sumController =
      TextEditingController(text: "250");

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
                  delivery: Delivery(
                      deliveryTime: DeliveryTime(
                          startTime: selectedDate, endTime: selectedDate),
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
        padding: const EdgeInsets.all(15),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.face),
                hintText: "Name"),
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Заголовок пустой";
              }
              if (value.length < 3) {
                return "Заголовок должен быть не короче 3 символов";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Phone",
            ),
            controller: phoneController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Содержание пустое";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            maxLines: null,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "email",
            ),
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Содержание пустое";
              }
              return null;
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "${selectedDate.toLocal()}".split(' ')[0],
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context), // Refer step 3
                child: const Text(
                  'Select date',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.face),
                hintText: "comment"),
            // указываем TextEditingController
            controller: commentController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Заголовок пустой";
              }
              if (value.length < 3) {
                return "Заголовок должен быть не короче 3 символов";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.face),
                hintText: "address"),
            controller: addressController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Заголовок пустой";
              }
              if (value.length < 3) {
                return "Заголовок должен быть не короче 3 символов";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.face),
                hintText: "cost"),
            controller: costController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Заголовок пустой";
              }
              if (value.length < 3) {
                return "Заголовок должен быть не короче 3 символов";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.face),
                hintText: "orderComment"),
            controller: orderCommentController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Заголовок пустой";
              }
              if (value.length < 3) {
                return "Заголовок должен быть не короче 3 символов";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.face),
                hintText: "sum"),
            controller: sumController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Заголовок пустой";
              }
              if (value.length < 3) {
                return "Заголовок должен быть не короче 3 символов";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
