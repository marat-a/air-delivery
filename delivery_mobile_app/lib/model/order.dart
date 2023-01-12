import 'package:json_annotation/json_annotation.dart';

import 'customer.dart';
import 'delivery.dart';

part 'order.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Order {
  @JsonKey(ignore: true)
  int? id;
  Customer customer;
  @JsonKey(defaultValue: "", ignore: true)
  String? dateCreated;
  @JsonKey(defaultValue: "", ignore: true)
  String? transferType;
  Delivery delivery;
  @JsonKey(defaultValue: "", ignore: true)
  String? status;
  @JsonKey(defaultValue: "")
  String orderComment;
  @JsonKey(defaultValue: "", ignore: true)
  String? payStatus;
  @JsonKey(defaultValue: "", ignore: true)
  String? receivingType;
  @JsonKey(defaultValue: 0.0)
  double sum;

  Order(
      { this.id,
      required this.customer,
       this.dateCreated,
       this.transferType,
      required this.delivery,
       this.status,
      required this.orderComment,
      this.payStatus,
       this.receivingType,
      required this.sum});

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);


}

class OrderList {
  final List<Order> orders = [];
  OrderList.fromJson(List<dynamic> jsonItems) {
    for (var jsonItem in jsonItems) {
      orders.add(Order.fromJson(jsonItem));
    }
  }
}


abstract class OrderAdd {}
class OrderAddSuccess extends OrderAdd {}
class OrderAddFailure extends OrderAdd {}

abstract class OrderResult {}

class OrderResultSuccess extends OrderResult {
  final OrderList orderList;
  OrderResultSuccess(this.orderList);
}

class OrderResultFailure extends OrderResult {
  final String error;
  OrderResultFailure(this.error);
}

class OrderResultLoading extends OrderResult {
  OrderResultLoading();
}
