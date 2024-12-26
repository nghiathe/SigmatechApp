import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sigmatech/features/shop/screens/chat/widget/chat_service.dart';
import 'package:sigmatech/features/shop/screens/store/LaptopDetailScreen-Implementation.dart';


class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat với chúng tôi'),
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isUser = message['role'] == 'user';

                  // Kiểm tra loại tin nhắn
                  if (message['type'] == 'product_card') {
                    return ProductCard(
                      name: message['name'] ?? 'Không xác định',
                      price: message['price'] ?? 'Liên hệ',
                      imageUrl: message['image'] ??
                          'https://example.com/default-image.png',
                      onTap: () {
                        Get.to(() => LaptopDetailScreen(),
                            arguments: message['id']);
                      },
                    );
                  }

                  return Container(
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(message['content'] ?? ""),
                    ),
                  );
                },
              );
            }),
          ),

          // Input để gửi tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController.messageController,
                    decoration: const InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    chatController
                        .sendMessage(chatController.messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            // Hình ảnh sản phẩm
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Tên và giá sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

