import 'package:flutter/material.dart';


class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Green Nike sports shoe',
      'details': 'Color Green  Size EU 34',
      'price': 134.0,
      'image': 'assets/shoe.png', // Thay bằng đường dẫn ảnh của bạn
      'quantity': 1,
    },
    {
      'name': 'Blue T-shirt for all ages',
      'details': 'ZARA',
      'price': 35.0,
      'image': 'assets/tshirt.png',
      'quantity': 1,
    },
    {
      'name': 'Nike Track suit red',
      'details': 'Nike',
      'price': 500.0,
      'image': 'assets/tracksuit.png',
      'quantity': 1,
    },
    {
      'name': 'Nike Air Max Red & Black',
      'details': 'Nike',
      'price': 600.0,
      'image': 'assets/airmax.png',
      'quantity': 1,
    },
    {
      'name': 'Iphone 14 pro 512gb',
      'details': 'Apple',
      'price': 1998.0,
      'image': 'assets/iphone.png',
      'quantity': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold(
        0, (sum, item) => sum + item['price'] * item['quantity']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Product image
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(item['image']), // Thay bằng ảnh
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Product details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['details'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quantity and price
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_outline),
                                onPressed: () {},
                              ),
                              Text('${item['quantity']}'),
                              IconButton(
                                icon: Icon(Icons.add_circle_outline),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          Text(
                            '\$${item['price']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Checkout button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Checkout \$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
