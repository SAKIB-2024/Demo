import 'package:flutter/material.dart';
import 'homepage.dart'; // For Product model

class MyCollectionPage extends StatelessWidget {
  static const Color primaryColor = Color(0xFF381932);
  static const Color backgroundColor = Color(0xFFF0EDE9);

  // Dummy data – items the user has rented from others
  final List<Product> rentedItems = [
    Product(
      id: 'c1',
      name: 'Mountain Bike – Trek Marlin 5',
      imageUrl:
          'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 22.0,
      originalPrice: 30.0,
      freeDelivery: true,
      coinsSaved: 8.0,
      coinsSave: 1.5,
      location: 'Dhaka',
    ),
    Product(
      id: 'c2',
      name: 'Projector – Epson Home Cinema',
      imageUrl:
          'https://images.unsplash.com/photo-1587826080692-f0b9c729a4d1?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 55.0,
      originalPrice: 75.0,
      freeDelivery: false,
      coinsSaved: 20.0,
      coinsSave: 3.0,
      location: 'Dhaka',
    ),
    Product(
      id: 'c3',
      name: 'Camping Tent – 4 Person',
      imageUrl:
          'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 18.0,
      originalPrice: 25.0,
      freeDelivery: true,
      coinsSaved: 7.0,
      coinsSave: 1.0,
      location: 'Cox\'s Bazar',
    ),
  ];

  MyCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('My Collections'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: rentedItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No rented items yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore items and start renting!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: rentedItems.length,
              itemBuilder: (context, index) {
                final product = rentedItems[index];
                return ProductGridCard(product: product);
              },
            ),
    );
  }
}