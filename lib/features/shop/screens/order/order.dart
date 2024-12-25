import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../controllers/userprofile/user_profile_controller.dart';
import '../UserProfile/OrderList.dart';
import '../home/home.dart';

class OrderDetailScreen extends StatefulWidget {
  final List<dynamic> cartItems;

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

  // Hàm tính tổng tiền từ giỏ hàng
  double getTotalPrice() {
    double total = 0;
    for (var item in widget.cartItems) {
      total += (item['quantity'] * double.tryParse(item['price']) ?? 0);
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    controller.fetchUserProfile(); // Gọi hàm tải dữ liệu người dùng
  }

  // Hàm gửi yêu cầu API và xử lý kết quả
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
          'productType': item['product_type'],
          'productId': item['product_id'],
          'quantity': item['quantity'],
          'price': item['price'],
        }).toList(),
      }), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        if (_paymentMethod == 'banking') {
          // Điều hướng đến trang QR, khi nhấn "Trở về" sẽ về HomeScreen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => QRScreen(qrUrl: data['qrUrl']),
            ),
                (route) => false, // Xóa toàn bộ stack để tránh quay về OrderDetailScreen
          ).then((_) {
            // Khi người dùng nhấn nút "Back", quay về HomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrderListScreen(token: token)),
          );
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Đặt hàng thành công'),
              content: Text(data['message'] ?? 'Đặt hàng thành công!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
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
  Widget build(BuildContext context) {
    return Scaffold(
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
                  // Cập nhật giá trị từ userProfileController nếu có
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
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
                  var item = widget.cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.network(
                            'https://6ma.zapto.org/${item['image']}', // Đảm bảo URL chính xác
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
                                  item['name'],
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text('Số lượng: ${item['quantity']}'),
                                Text('Giá: ${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(int.tryParse(item['price']) ?? 0)}đ'),
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
            // Tổng tiền
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng tiền', style: TextStyle(fontSize: 16)),
                  Text(
                    NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(getTotalPrice()) + 'đ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Nút đặt hàng
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: placeOrder,
                child: Text('Đặt hàng'),
              ),
            ),
          ],
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        return false; // Ngăn không quay lại màn hình trước
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
