import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../controllers/cart/cart_controller.dart';
import '../../models/cart_item.dart';


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> _cartItems;
  final deviceStorage = GetStorage();
  List<CartItem> selectedItems = [];
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    String token = deviceStorage.read('authToken');
    _cartItems = CartController.getCartItems(token);
  }

  void updateQuantity(CartItem item, int newQuantity) async {
    try {
      String token = deviceStorage.read('authToken');
      await CartController.updateCartItemQuantity(token, item.productType, item.productId, newQuantity);
      setState(() {
        item.quantity = newQuantity;
      });
    } catch (e) {
      print('Lỗi khi cập nhật số lượng: $e');
    }
  }

  void removeFromCart(String productType, int productId) async {
    try {
      String token = deviceStorage.read('authToken');
      await CartController.removeFromCart(token, productType, productId);

      setState(() {
        _cartItems = CartController.getCartItems(token);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sản phẩm đã được xóa khỏi giỏ hàng')));
    } catch (e) {
      print('Lỗi khi xóa sản phẩm khỏi giỏ hàng: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể xóa sản phẩm khỏi giỏ hàng')));
    }
  }

  void toggleSelectItem(CartItem item, bool? value, List<CartItem> cartItems) {
    setState(() {
      if (value ?? false) {
        selectedItems.add(item); // Thêm sản phẩm vào danh sách đã chọn
      } else {
        selectedItems.remove(item); // Bỏ sản phẩm ra khỏi danh sách đã chọn
      }

      // Cập nhật trạng thái "Chọn tất cả"
      isAllSelected = cartItems.length == selectedItems.length; // Nếu tất cả sản phẩm đã chọn, đánh dấu "Chọn tất cả"
    });
  }

  // Hàm toggle cho chọn tất cả
  void toggleSelectAll(bool? value, List<CartItem> cartItems) {
    setState(() {
      isAllSelected = value ?? false;
      if (isAllSelected) {
        selectedItems = List.from(cartItems); // Chọn tất cả sản phẩm
      } else {
        selectedItems.clear(); // Bỏ chọn tất cả sản phẩm
      }
    });
  }

  // Tính tổng tiền cho các sản phẩm được chọn
  int calculateTotal() {
    return selectedItems.fold(0, (total, item) {
      return total + (int.tryParse(item.dealPrice) ?? 0) * item.quantity;
    });
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

          List<CartItem> cartItems = snapshot.data!;

          return Column(
            children: [
              // Hiển thị danh sách sản phẩm
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(5.0),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    CartItem item = cartItems[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox bên trái ảnh sản phẩm
                            Checkbox(
                              value: selectedItems.contains(item),
                              onChanged: (value) {
                                toggleSelectItem(item, value, cartItems);
                              },
                            ),
                            // Ảnh sản phẩm
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    'https://6ma.zapto.org${item.image}',
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                SizedBox(height: 8), // Khoảng cách giữa ảnh và chữ "Xóa"
                                GestureDetector(
                                  onTap: () {
                                    removeFromCart(item.productType, item.productId);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete, color: Colors.red, size: 18),
                                      SizedBox(width: 4), // Khoảng cách giữa icon và chữ
                                      Text(
                                        'Xóa',
                                        style: TextStyle(color: Colors.red, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                ],

                              )

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
                                        '${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(int.tryParse(item.dealPrice) ?? 0)}đ',
                                        style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Dòng ngăn cách giữa phần sản phẩm và phần thanh toán
              Divider(thickness: 1),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Căn cách đều hai đầu
                      children: [
                        Text(
                          'Tổng tiền:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          '${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(calculateTotal())}đ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),


                    // Dòng chứa nút thanh toán nằm ở dưới cùng và căn phải
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0), // Khoảng cách giữa tổng tiền và nút thanh toán
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn phải cho nút thanh toán
                        children: [
                          Checkbox(
                            value: isAllSelected,
                            onChanged: (value) {
                              toggleSelectAll(value, cartItems);
                            },
                          ),
                          Text('Chọn tất cả'),
                          SizedBox(width: 85),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 50), // Nút thanh toán có kích thước phù hợp
                            ),
                            onPressed: () {
                              // Xử lý thanh toán ở đây
                              Get.snackbar('Thanh toán', 'Thanh toán thành công!');
                            },
                            child: Text('Thanh toán'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )


            ],
          );
        },
      ),
    );
  }
}