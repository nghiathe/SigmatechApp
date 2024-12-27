import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigmatech/features/shop/controllers/userprofile/user_order_controller.dart';
import '../../../../navigation_menu.dart';
import '../../controllers/cart/cart_controller.dart';
import '../../controllers/order/order_controller.dart';


class OrderListScreen extends StatelessWidget {
  final OrderController controller = Get.put(OrderController());
  final String token;

  OrderListScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    controller.fetchOrders(token); // Fetch orders with token

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đơn hàng'),
        backgroundColor: const Color(0xFF408591),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.find<CartController>().updateCartCountFromLocalStorage();
            Get.offAll(() => NavigationMenu());
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return Center(child: Text('Không có đơn hàng nào.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
        }

        return ListView.builder(
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            final order = controller.orders[index];

            return Card(
              elevation: 5, // Thêm độ nổi cho card
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Góc bo tròn cho card
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12), // Padding cho listTile
                leading: Icon(Icons.shopping_bag, color: const Color(0xFF408591),), // Thêm icon cho đơn hàng
                title: Text(order.customerName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: Text('Tổng giá: ${order.totalPrice.toStringAsFixed(0)} đ', style: TextStyle(color: Colors.grey[700])),
                trailing: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status), // Thêm màu sắc cho trạng thái
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(order.status), // Trạng thái đơn hàng
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () {
                  _showOrderDetailsDialog(context, token, order.id);
                },
              ),
            );
          },
        );
      }),
    );
  }

  void _showOrderDetailsDialog(BuildContext context, String token, int orderId) async {
    try {
      final orderDetails = await UserOrderController.fetchOrderDetails(token, orderId);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Chi tiết đơn hàng #${orderDetails['id']}'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tên khách hàng:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${orderDetails['customer_name']}'),
                  SizedBox(height: 8),
                  Text('Số điện thoại:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${orderDetails['phone_number']}'),
                  SizedBox(height: 8),
                  Text('Địa chỉ giao hàng:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${orderDetails['shipping_address']}'),
                  SizedBox(height: 8),
                  Text('Phương thức thanh toán:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${_getPaymentMethod(orderDetails['payment_method'])}'),
                  SizedBox(height: 8),
                  Text('Ghi chú:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${orderDetails['note'] ?? 'Không có'}'),
                  SizedBox(height: 16),
                  Text('Tổng giá:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${orderDetails['total_price']} đ'),
                  SizedBox(height: 16),
                  Text('Trạng thái:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${_getStatusText(orderDetails['status'])}'),
                  SizedBox(height: 16),
                  Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...orderDetails['order_details'].map<Widget>((item) {
                    return ListTile(
                      leading: Image.network(
                        'https://6ma.zapto.org${item['image']}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['name']),
                      subtitle: Text('Số lượng: ${item['quantity']} - Giá: ${item['price']} đ'),
                    );
                  }).toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Đóng'),
              ),
            ],
          );
        },
      );

    } catch (e) {
      print('Error fetching order details: $e');
      // Hiển thị lỗi nếu có vấn đề khi gọi API
    }
  }

// Hàm lấy màu cho trạng thái đơn hàng
  Color _getStatusColor(String status) {
    switch (status) {
      case '0':
        return Colors.grey; // Chờ xác nhận
      case '1':
        return Colors.blue; // Đang vận chuyển
      case '2':
        return Colors.orange; // Đã thanh toán, chờ vận chuyển
      case '3':
        return Colors.green; // Hoàn thành
      case '4':
        return Colors.red; // Đã hủy
      default:
        return Colors.black; // Mặc định khi không xác định
    }
  }

// Hàm lấy tên trạng thái đơn hàng
  String _getStatusText(String status) {
    switch (status) {
      case '0':
        return 'Chờ xác nhận';
      case '1':
        return 'Đang vận chuyển';
      case '2':
        return 'Đã thanh toán, chờ vận chuyển';
      case '3':
        return 'Hoàn thành';
      case '4':
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

// Hàm lấy phương thức thanh toán
  String _getPaymentMethod(String method) {
    switch (method) {
      case 'banking':
        return 'Chuyển khoản ngân hàng';
      case 'cash_on_delivery':
        return 'Thanh toán khi nhận hàng';
      default:
        return 'Không xác định';
    }
  }

}
