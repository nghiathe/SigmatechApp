class Order {
  final int id;
  final int userId;
  final String customerName;
  final String gender;
  final String phoneNumber;
  final String shippingAddress;
  final String paymentMethod;
  final String? note;
  final double totalPrice;
  final String status;
  final String createdAt;
  final String updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.gender,
    required this.phoneNumber,
    required this.shippingAddress,
    required this.paymentMethod,
    this.note,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      customerName: json['customer_name'],
      gender: json['gender'],
      phoneNumber: json['phone_number'],
      shippingAddress: json['shipping_address'],
      paymentMethod: json['payment_method'],
      note: json['note'],
      totalPrice: json['total_price'].toDouble(),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
