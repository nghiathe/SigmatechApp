import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../navigation_menu.dart';
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
        backgroundColor: Colors.blueAccent, // Thêm màu nền cho appBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
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
                leading: Icon(Icons.shopping_bag, color: Colors.blueAccent), // Thêm icon cho đơn hàng
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
                  // Thêm logic khi nhấn vào đơn hàng (nếu cần)
                },
              ),
            );
          },
        );
      }),
    );
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
}
