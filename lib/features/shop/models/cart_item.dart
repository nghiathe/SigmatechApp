class CartItem {
  final int productId;
  final String productType;
  int quantity;
  final String name;
  final int price; // Đảm bảo kiểu là int
  final String imageUrl;

  CartItem({
    required this.productId,
    required this.productType,
    required this.quantity,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product_id'] as int,
      productType: json['product_type'] as String,
      quantity: json['quantity'] as int,
      name: json['name'] as String,
      price: json['price'] as int,  // Chắc chắn giá trị là kiểu int
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_type': productType,
      'quantity': quantity,
      'name': name,
      'price': price,
      'image_url': imageUrl,
    };
  }
}
