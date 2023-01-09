import 'customer.dart';
import 'delivery.dart';

class Order {
  int id;
  Customer customer;
  String dateCreated;
  String transferType;
  Delivery delivery;
  String status;
  String orderComment;
  String payStatus;
  String receivingType;
  double sum;

  Order(
      {required this.id,
      required this.customer,
      required this.dateCreated,
      required this.transferType,
      required this.delivery,
      required this.status,
      required this.orderComment,
      required this.payStatus,
      required this.receivingType,
      required this.sum});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        customer: Customer.fromJson(json['customer']),
        dateCreated: json['dateCreated'] ?? "",
        transferType: json['transferType'] ?? "",
        delivery: Delivery.fromJson(json['delivery']),
        status: json['status'] ?? "",
        orderComment: json['orderComment'] ?? "",
        payStatus: json['payStatus'] ?? "",
        receivingType: json['receivingType'] ?? "",
        sum: json['sum'] ?? "");
  }
}
