import 'package:json_annotation/json_annotation.dart';

part 'delivery.g.dart';

@JsonSerializable(includeIfNull: false)
class Delivery {
  final DeliveryTime deliveryTime;
  @JsonKey(defaultValue: "")
  final String comment;
  @JsonKey(defaultValue: "")
  final String address;
  @JsonKey(defaultValue: 0.0)
  final double cost;

  Delivery(
      {required this.deliveryTime,
      required this.comment,
      required this.address,
      required this.cost});

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);
}

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class DeliveryTime {
  DateTime startTime;
  DateTime endTime;

  DeliveryTime({required this.startTime, required this.endTime});

  factory DeliveryTime.fromJson(Map<String, dynamic> json) =>
      _$DeliveryTimeFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryTimeToJson(this);
}
