import 'package:flutter/material.dart';
import 'homepage.dart'; // For Product model

class MyListPage extends StatelessWidget {
  static const Color primaryColor = Color(0xFF381932);
  static const Color backgroundColor = Color(0xFFF0EDE9);

  // Dummy data – items the user is offering
  final List<Product> myItems = [
    Product(
      id: 'm1',
      name: 'DSLR Camera Canon EOS 80D',
      imageUrl:
          'https://images.unsplash.com/photo-1512790182412-b19e6d62bc39?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 850.0,
      originalPrice: 1200.0,
      freeDelivery: true,
      coinsSaved: 350.0,
      coinsSave: 5.0,
      location: 'Dhaka',
    ),
    Product(
      id: 'm2',
      name: 'Gaming Chair – Ergonomic',
      imageUrl:
          'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 125.0,
      originalPrice: 180.0,
      freeDelivery: false,
      coinsSaved: 55.0,
      coinsSave: 2.0,
      location: 'Chattogram',
    ),
    Product(
      id: 'm3',
      name: 'Electric Kettle – 1.8L',
      imageUrl:
          'https://images.unsplash.com/photo-1594213114663-d94db9b90325?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 22.0,
      originalPrice: 35.0,
      freeDelivery: true,
      coinsSaved: 13.0,
      coinsSave: 1.0,
      location: 'Sylhet',
    ),
  ];

  MyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('My Listings'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Could navigate to UploadPage
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add new listing')),
              );
            },
          ),
        ],
      ),
      body: myItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No listings yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add an item',
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
              itemCount: myItems.length,
              itemBuilder: (context, index) {
                final product = myItems[index];
                return ProductGridCard(product: product);
              },
            ),
    );
  }
}