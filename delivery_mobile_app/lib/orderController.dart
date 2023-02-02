
import 'package:mvc_pattern/mvc_pattern.dart';

import 'model/order.dart';
import 'orderRepository.dart';

class OrderController extends ControllerMVC {
  final Repository repo = Repository();
  late Order orderForUpdate;

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

  void editOrder(Order order, void Function(OrderUpdate) callback) async {
    try {
      final result = await repo.updateOrder(order);
      callback(result);
    } catch (error) {
      callback(OrderUpdateFailure());
    }
  }




}