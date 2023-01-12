// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      delivery: Delivery.fromJson(json['delivery'] as Map<String, dynamic>),
      orderComment: json['orderComment'] as String? ?? '',
      sum: (json['sum'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'customer': instance.customer.toJson(),
      'delivery': instance.delivery.toJson(),
      'orderComment': instance.orderComment,
      'sum': instance.sum,
    };
