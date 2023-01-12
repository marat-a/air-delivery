// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
      deliveryTime:
          DeliveryTime.fromJson(json['deliveryTime'] as Map<String, dynamic>),
      comment: json['comment'] as String? ?? '',
      address: json['address'] as String? ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
      'deliveryTime': instance.deliveryTime,
      'comment': instance.comment,
      'address': instance.address,
      'cost': instance.cost,
    };

DeliveryTime _$DeliveryTimeFromJson(Map<String, dynamic> json) => DeliveryTime(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$DeliveryTimeToJson(DeliveryTime instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
    };
