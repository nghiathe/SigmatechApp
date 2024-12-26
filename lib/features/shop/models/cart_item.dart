class CartItem {
  final int id;
  final int userId;
  final String productType;
  final int productId;
  final String name;
  int quantity;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String dealPrice;
  final String price;
  final String image;

  CartItem({
    required this.id,
    required this.userId,
    required this.productType,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.dealPrice,
    required this.price,
    required this.image,
  });

  // Hàm khởi tạo từ JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      userId: json['user_id'],
      productType: json['product_type'],
      productId: json['product_id'],
      name: json['name'],
      quantity: json['quantity'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      dealPrice: json['dealprice'],
      price: json['price'],
      image: json['image'],
    );
  }
}
