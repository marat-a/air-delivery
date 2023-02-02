// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as int?,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      transferType: json['transferType'] as String? ?? '',
      delivery: Delivery.fromJson(json['delivery'] as Map<String, dynamic>),
      orderComment: json['orderComment'] as String? ?? '',
      sum: (json['sum'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$OrderToJson(Order instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['customer'] = instance.customer.toJson();
  val['transferType'] = instance.transferType;
  val['delivery'] = instance.delivery.toJson();
  val['orderComment'] = instance.orderComment;
  val['sum'] = instance.sum;
  return val;
}
