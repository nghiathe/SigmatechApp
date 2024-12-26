import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart';

class LaptopDetailScreen extends StatefulWidget {
  @override
  _LaptopDetailScreenState createState() => _LaptopDetailScreenState();
}

class _LaptopDetailScreenState extends State<LaptopDetailScreen> {
  final LaptopService laptopService = LaptopService.instance;

  @override
  Widget build(BuildContext context) {
    final int laptopId = Get.arguments;
    final screenWidth = MediaQuery.of(context).size.width;

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
        final List<String> sliderImages = [
          'https://6ma.zapto.org' + laptop['image1'],
          'https://6ma.zapto.org' + laptop['image2'],
          'https://6ma.zapto.org' + laptop['image3'],
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(laptop['name'] ?? 'Chi tiết sản phẩm'),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Slider hình ảnh
                  Container(
                    height: 250,
                    child: PageView.builder(
                      itemCount: sliderImages.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          sliderImages[index],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 50),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tên sản phẩm và giá với nút chia sẻ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          laptop['name'] ?? 'Không rõ tên',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Chức năng chia sẻ
                        },
                        icon: const Icon(Icons.share, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(int.tryParse(laptop['price'] ?? '0'))} VNĐ',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (laptop['discountPrice'] != null)
                        Text(
                          '${NumberFormat.currency(locale: 'vi', symbol: '', decimalDigits: 0).format(int.tryParse(laptop['discountPrice'] ?? '0'))} VNĐ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Thông số kỹ thuật
                  const Text(
                    'Thông số kỹ thuật:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      _buildSpecRow('CPU', laptop['spec_cpu']),
                      _buildSpecRow('RAM', laptop['spec_ram']),
                      _buildSpecRow('SSD', laptop['spec_ssd']),
                      _buildSpecRow('GPU', laptop['spec_gpu']),
                      _buildSpecRow('Màn hình', laptop['spec_mon_size']),
                      _buildSpecRow('Độ phân giải', laptop['spec_mon_res']),
                      _buildSpecRow('Màu sắc', laptop['color']),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nút "Mua ngay" và "Thêm vào giỏ hàng"
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Chức năng Mua ngay
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF408591)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.flash_on, color: Color(0xFF408591)),
                          label: const Text(
                            'Mua ngay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF408591),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Chức năng Thêm vào giỏ
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF408591),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.shopping_cart, color: Colors.white),
                          label: const Text(
                            'Thêm vào giỏ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TableRow _buildSpecRow(String title, String? value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(value ?? 'Không rõ'),
        ),
      ],
    );
  }
}
