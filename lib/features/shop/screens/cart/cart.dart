import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/cart/cart_controller.dart';
import '../../models/cart_item.dart';


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> _cartItems;
  final deviceStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    // Lấy token từ GetStorage
    String token = deviceStorage.read('authToken');
    _cartItems = CartController.getCartItems(token);
  }

  void updateQuantity(CartItem item, int newQuantity) async {
    try {
      String token = deviceStorage.read('authToken'); // Lấy token từ bộ nhớ
      await CartController.updateCartItemQuantity(
          token, item.productType, item.productId, newQuantity);

      setState(() {
        item.quantity = newQuantity; // Cập nhật số lượng trong UI
      });
    } catch (e) {
      print('Lỗi khi cập nhật số lượng: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giỏ Hàng')),
      body: FutureBuilder<List<CartItem>>(
        future: _cartItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Đã có lỗi xảy ra'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Giỏ hàng của bạn đang trống.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              CartItem item = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh sản phẩm
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          'https://6ma.zapto.org${item.image}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12),
                      // Chi tiết sản phẩm
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            // Giá và số lượng theo hàng ngang
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Số lượng và nút tăng giảm
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        if (item.quantity > 1) {
                                          updateQuantity(item, item.quantity - 1);
                                        }
                                      },
                                    ),
                                    Text(item.quantity.toString(), style: TextStyle(fontSize: 16)),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        updateQuantity(item, item.quantity + 1);
                                      },
                                    ),
                                  ],
                                ),
                                // Giá sản phẩm
                                Text(
                                  '${item.dealPrice} VND',
                                  style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Nút xóa sản phẩm
                            ElevatedButton(
                              onPressed: () {
                                // Thực hiện xóa sản phẩm
                                setState(() {
                                  snapshot.data!.removeAt(index);
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Đặt màu nền
                              ),
                              child: Text('Xóa sản phẩm'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}