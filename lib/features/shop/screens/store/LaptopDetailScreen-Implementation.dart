import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Để định dạng giá tiền
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';

class LaptopDetailScreen extends StatelessWidget {
  final LaptopService laptopService = LaptopService.instance;

  @override
  Widget build(BuildContext context) {
    final int laptopId = Get.arguments; // Nhận ID từ màn hình trước

    return FutureBuilder(
      future: laptopService.fetchLaptopDetail(laptopId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
            body: const Center(
              child: Text('Không thể tải thông tin sản phẩm.'),
            ),
          );
        }

        final laptop = snapshot.data as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            title: Text(laptop['name'] ?? 'Chi tiết sản phẩm'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị hình ảnh sản phẩm
                if (laptop['image1'] != null)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        'https://6ma.zapto.org' + laptop['image1'] ?? 'https://via.placeholder.com/150',
                        height: 500,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 50);
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Tên sản phẩm
                Text(
                  laptop['name'] ?? 'Không rõ tên',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Giá sản phẩm
                Text(
                  'Giá: ${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(int.tryParse(laptop['price'] ?? '0'))} VNĐ',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 10),

                // Thông số kỹ thuật
                const Text(
                  'Thông số kỹ thuật:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('CPU: ${laptop['spec_cpu'] ?? 'Không rõ'}'),
                Text('RAM: ${laptop['spec_ram'] ?? 'Không rõ'}'),
                Text('GPU: ${laptop['spec_gpu'] ?? 'Không rõ'}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
