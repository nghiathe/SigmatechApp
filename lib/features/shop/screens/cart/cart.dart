import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../controllers/cart/cart_controller.dart';
import '../../models/cart_item.dart';
import '../order/order.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<CartItem>> _cartItems;
  final deviceStorage = GetStorage();
  List<CartItem> cartItems = []; // Danh sách sản phẩm trong giỏ hàng
  List<CartItem> selectedItems = []; // Danh sách sản phẩm được chọn
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    _cartItems = loadCartItemsFromStorage();  // Thực hiện việc tải dữ liệu vào _cartItems
  }

  Future<List<CartItem>> loadCartItemsFromStorage() async {
    try {
      final dynamic cartData = deviceStorage.read('cart');
      print('Dữ liệu từ local storage: $cartData');  // Kiểm tra lại giá trị từ local storage
      if (cartData != null && cartData is String) {
        final List<dynamic> decodedData = json.decode(cartData);
        cartItems = decodedData.map<CartItem>((item) {
          return CartItem.fromJson({
            'product_id': item['product_id'],
            'product_type': item['product_type'],
            'quantity': item['quantity'],
            'name': item['name'],
            'price': item['price'],
            'image_url': item['image_url'],
          });
        }).toList();
        return cartItems;
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu giỏ hàng từ storage: $e');
    }
    return [];
  }

  void updateQuantity(CartItem item, int newQuantity) {
    setState(() {
      item.quantity = newQuantity;
      saveCartItemsToStorage();  // Lưu lại sau khi cập nhật số lượng
    });
  }

  void saveCartItemsToStorage() {
    final cartJson = json.encode(cartItems.map((item) => item.toJson()).toList());
    deviceStorage.write('cart', cartJson); // Đảm bảo bạn lưu 'cart', không phải 'cartItems'
  }

  void removeFromCart(String productType, int productId) {
    setState(() {
      cartItems.removeWhere((item) => item.productType == productType && item.productId == productId);
      saveCartItemsToStorage();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sản phẩm đã được xóa khỏi giỏ hàng')),
    );
  }

  void toggleSelectItem(CartItem item, bool? value) {
    setState(() {
      if (value ?? false) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
      }
      isAllSelected = cartItems.length == selectedItems.length;
    });
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      isAllSelected = value ?? false;
      if (isAllSelected) {
        selectedItems = List.from(cartItems); // Chọn tất cả
      } else {
        selectedItems.clear(); // Bỏ chọn tất cả
      }
    });
  }

  int calculateTotal() {
    return selectedItems.fold(0, (total, item) {
      return total + (item.price * item.quantity);  // Chỉ tính tổng tiền của các sản phẩm đã chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Cập nhật số lượng sản phẩm trong giỏ hàng
            Get.find<CartController>().updateCartCountFromLocalStorage();

            // Quay lại màn hình trước
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<CartItem>>(
        future: _cartItems, // Đảm bảo bạn đang sử dụng _cartItems để tải và hiển thị
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('Giỏ hàng của bạn đang trống.'));
          } else {
            // Dữ liệu giỏ hàng có sẵn, hiển thị danh sách
            final cartItems = snapshot.data!;
            return Column(
              children: [
                // Danh sách sản phẩm trong giỏ hàng
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
                              Column(
                                children: [
                                  Checkbox(
                                    value: selectedItems.contains(item),
                                    onChanged: (value) {
                                      toggleSelectItem(item, value);
                                    },
                                      activeColor: const Color(0xFF408591),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      removeFromCart(item.productType, item.productId);
                                    },
                                  ),
                                ],
                              ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    '${item.imageUrl}',
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
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
                                        Text(
                                          '${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(item.price)}đ',
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
                // Footer
                buildFooter(context),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Checkbox(
                value: isAllSelected,
                onChanged: (value) {
                  toggleSelectAll(value);
                },
                  activeColor: const Color(0xFF408591)
              ),
              Text('Chọn tất cả'),
              // Cập nhật phần nút "Đặt hàng"
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  backgroundColor: const Color(0xFF408591)
                ),
                onPressed: () {
                  // Chuyển sang trang OrderDetailScreen và truyền giỏ hàng
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(cartItems: selectedItems),  // Gửi danh sách selectedItems
                    ),
                  );
                },
                child: Text('Đặt hàng'),
              )

            ],
          ),
        ],
      ),
    );
  }
}
