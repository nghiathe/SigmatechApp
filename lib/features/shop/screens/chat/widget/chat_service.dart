import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sigmatech/features/shop/screens/store/LaptopDetailScreen-Implementation.dart';
import 'package:sigmatech/features/shop/screens/store/widget/LaptopService.dart'; // Import dịch vụ LaptopService

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final LaptopService laptopService = Get.put(LaptopService()); // Khởi tạo LaptopService

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      messages.add({'role': 'user', 'content': message});
      messageController.clear();
      handleBotResponse(message);
    }
  }

  void handleBotResponse(String userMessage) async {
    if (userMessage.toLowerCase().contains('mua laptop')) {
      // Gọi API lấy danh sách laptops
      final laptops = LaptopService.instance.laptops;

      if (laptops.isEmpty) {
        messages.add({
          'role': 'bot',
          'content': 'Hiện tại không có sản phẩm nào. Vui lòng thử lại sau.'
        });
      } else {
        // Tạo danh sách card hiển thị laptop
        messages.add({'role': 'bot', 'content': 'Dưới đây là một số laptop phù hợp cho bạn:'});
        for (var laptop in laptops.take(5)) {
          final name = laptop['name'] ?? 'Tên không xác định';
          final price = laptop['price'] != null ? '${laptop['price']} VND' : 'Liên hệ';
          final image = 'https://6ma.zapto.org' + laptop['image1'];
          messages.add({
            'role': 'bot',
            'type': 'product_card',
            'name': name,
            'price': price,
            'image': image,
            'id': laptop['id'],
          });
        }
      }
    } else {
      messages.add({'role': 'bot', 'content': 'Xin chào! Tôi có thể giúp gì cho bạn?'});
    }
  }

}
