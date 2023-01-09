class Customer {
  final String name;
  final String phone;
  final String email;

  const Customer(
      {required this.name, required this.phone, required this.email});

  factory Customer.fromJson(Map<String, dynamic> customerJson) {
    return Customer(
        name: customerJson['name'] ?? "",
        phone: customerJson['phone'] ?? "",
        email: customerJson['email'] ?? "");
  }
}
