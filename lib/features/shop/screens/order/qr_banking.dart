import 'package:flutter/material.dart';// Thêm gói QR code scanner nếu cần

class QRCodeScreen extends StatelessWidget {
  final String qrUrl;
  final double amount;
  final String description;

  QRCodeScreen({
    required this.qrUrl,
    required this.amount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment QR Code'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Amount: $amount VND', style: TextStyle(fontSize: 18)),
            Text('Description: $description', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Image.network(qrUrl),  // Hiển thị mã QR từ URL
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Bạn có thể xử lý thanh toán hoặc quay lại trang trước
              },
              child: Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
