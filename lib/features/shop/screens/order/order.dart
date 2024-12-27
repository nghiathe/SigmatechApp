import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../../navigation_menu.dart';
import '../../controllers/cart/cart_controller.dart';
import '../../controllers/userprofile/user_profile_controller.dart';
import '../../models/cart_item.dart';
import '../UserProfile/OrderList.dart';
import '../home/home.dart';

class OrderDetailScreen extends StatefulWidget {
  final List<dynamic> cartItems; // Nhận giỏ hàng từ trang trước

  OrderDetailScreen({required this.cartItems});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final deviceStorage = GetStorage();
  final controller = Get.put(UserProfileController());

  String _fullname = '';
  String _phone = '';
  String _address = '';
  String _note = '';
  String _paymentMethod = 'cod'; // Mặc định là thanh toán chuyển khoản
  String _gender = '1'; // 1: Nam, 2: Nữ

  double getTotalPrice() {
    double total = 0;
    for (var item in widget.cartItems) {
      total += (item.quantity * item.price); // Sử dụng item.quantity và item.price
    }
    return total;
  }
  Future<List<CartItem>> getCartItemsFromLocalStorage() async {
    String? cartItemsJson = await deviceStorage.read('cart');
    if (cartItemsJson != null) {
      List<dynamic> cartItemsList = json.decode(cartItemsJson);
      return cartItemsList.map((itemJson) => CartItem.fromJson(itemJson)).toList();
    }
    return [];
  }
  Future<void> placeOrder() async {
    if (_formKey.currentState!.validate()) {
      String token = deviceStorage.read('authToken');
      var url = Uri.parse('https://6ma.zapto.org/api/cart/order/place');
      var response = await http.post(url, body: json.encode({
        'fullname': _fullname,
        'phone': _phone,
        'address': _address,
        'note': _note,
        'payment_method': _paymentMethod,
        'gender': _gender,
        'totalPrice': getTotalPrice(),
        'items': widget.cartItems.map((item) => {
          'productType': item.productType,
          'productId': item.productId,
          'quantity': item.quantity,
          'price': item.price,
        }).toList(),
      }), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      var data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        List<CartItem> cartItems = await getCartItemsFromLocalStorage();
        List<CartItem> remainingItems = cartItems.where((item) {
          return !widget.cartItems.any((orderedItem) => orderedItem.productId == item.productId);
        }).toList();
        await deviceStorage.write('cart', json.encode(remainingItems.map((item) => item.toJson()).toList()));

        if (_paymentMethod == 'banking') {
          Get.offAll(QRScreen(qrUrl: data['qrUrl']));
        } else {
          Get.to(() => OrderListScreen(token: token));
          showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text('Đặt hàng thành công'),
                  content: Text(data['message'] ?? 'Đặt hàng thành công!'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(), // Quay lại
                      child: Text('OK'),
                    ),
                  ],
                ),
          );
        }
      } else {
        // Nếu có lỗi khi gửi yêu cầu
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Lỗi'),
            content: Text(data['message'] ?? 'Đã xảy ra lỗi khi đặt hàng.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller.fetchUserProfile(); // Gọi hàm tải dữ liệu người dùng
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Ẩn bàn phím khi người dùng chạm vào ngoài trường nhập liệu
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text('Thông tin đơn hàng')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Form nhập thông tin
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      if (controller.user == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      _fullname = controller.user?.name ?? '';
                      _phone = controller.user?.phone ?? '';
                      _address = controller.user?.address ?? '';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: _fullname,
                            decoration: InputDecoration(labelText: 'Họ tên'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập họ tên';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _fullname = value;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: _phone,
                            decoration: InputDecoration(labelText: 'Số điện thoại'),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập số điện thoại';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _phone = value;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: _address,
                            decoration: InputDecoration(labelText: 'Địa chỉ giao hàng'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Vui lòng nhập địa chỉ';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _address = value;
                            },
                          ),
                          SizedBox(height: 16),
                          // Chọn giới tính
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text("Anh"),
                                      leading: Radio<String>(
                                        value: '1',
                                        groupValue: _gender,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _gender = value!;
                                          });
                                        },
                                        activeColor: const Color(0xFF408591),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text("Chị"),
                                      leading: Radio<String>(
                                        value: '2',
                                        groupValue: _gender,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _gender = value!;
                                          });
                                        },
                                        activeColor: const Color(0xFF408591),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // Tiêu đề Chọn phương thức thanh toán
                              Text(
                                'Chọn phương thức thanh toán:',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text("Thanh toán khi nhận hàng"),
                                      leading: Radio<String>(
                                        value: 'cod',
                                        groupValue: _paymentMethod,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _paymentMethod = value!;
                                          });
                                        },
                                        activeColor: const Color(0xFF408591),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: Text("Thanh toán qua ngân hàng"),
                                      leading: Radio<String>(
                                        value: 'banking',
                                        groupValue: _paymentMethod,
                                        onChanged: (String? value) {
                                          setState(() {
                                            _paymentMethod = value!;
                                          });
                                        },
                                        activeColor: const Color(0xFF408591),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                initialValue: _note,
                                decoration: InputDecoration(labelText: 'Ghi chú'),
                                validator: (value) {
                                  return null;
                                },
                                onChanged: (value) {
                                  _note = value;
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              // Danh sách sản phẩm
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    var item = widget.cartItems[index]; // item là đối tượng CartItem
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.network(
                              '${item.imageUrl}', // Sử dụng item.imageUrl
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name, // Sử dụng item.name
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text('Số lượng: ${item.quantity}'), // Sử dụng item.quantity
                                  Text('Giá: ${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(item.price)}đ'), // Sử dụng item.price
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
            ],
          ),
        ),
        bottomSheet: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng tiền', style: TextStyle(fontSize: 16)),
                  Text(
                    NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(getTotalPrice()) + 'đ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF408591),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Hoàn tất đặt hàng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class QRScreen extends StatelessWidget {
  final String qrUrl;

  QRScreen({required this.qrUrl});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<CartController>().updateCartCountFromLocalStorage();
        Get.offAll(() => NavigationMenu()); // Quay về NavigationMenu hoặc trang nào có NavigationBar
        return false; // Ngăn không cho hành động mặc định (back stack)
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Mã QR thanh toán')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(qrUrl),
              SizedBox(height: 20),
              Text('Quét mã QR để thanh toán', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}



