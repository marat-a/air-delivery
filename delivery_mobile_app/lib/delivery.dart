class Delivery {
  final DeliveryTime deliveryTime;
  final String comment;
  final String address;
  final double cost;

  Delivery(
      {required this.deliveryTime,
        required this.comment,
        required this.address,
        required this.cost});

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
        deliveryTime: DeliveryTime.fromJson(json['deliveryTime']),
        comment: json['comment'] ?? "",
        address: json['address'] ?? "",
        cost: json['cost'] ?? "");
  }
}

class DeliveryTime {
  DateTime startTime;
  DateTime endTime;

  DeliveryTime({required this.startTime, required this.endTime});

  factory DeliveryTime.fromJson(Map<String, dynamic> json) {
    return DeliveryTime(
        startTime: DateTime.parse(json['startTime']), endTime: DateTime.parse(json['endTime']));
  }
}