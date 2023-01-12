
import 'package:mvc_pattern/mvc_pattern.dart';

import 'model/order.dart';
import 'orderRepository.dart';

class OrderController extends ControllerMVC {
  final Repository repo = Repository();

  // конструктор нашего контроллера
  OrderController();

  // первоначальное состояние - загрузка данных
  OrderResult currentState = OrderResultLoading();

  void init() async {
    try {
      final orderList = await repo.fetchOrders();
      setState(() => currentState = OrderResultSuccess(orderList));
    } catch (error) {
      setState(() => currentState = OrderResultFailure("Нет интернета"));
    }
  }

  void addOrder(Order order, void Function(OrderAdd) callback) async {
    try {
      final result = await repo.addOrder(order);
      callback(result);
    } catch (error) {
      callback(OrderAddFailure());
    }
  }




}