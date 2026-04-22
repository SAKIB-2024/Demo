import 'package:flutter/material.dart';
import 'homepage.dart'; // Assuming Product class is defined here, or move to a shared model file

class SavesPage extends StatelessWidget {
  static const Color primaryColor = Color(0xFF381932);
  static const Color backgroundColor = Color(0xFFF0EDE9);

  // Dummy saved products (could be a subset of the main product list)
  final List<Product> savedProducts = [
    Product(
      id: '1',
      name: 'Full cover soft case',
      imageUrl:
          'https://images.unsplash.com/photo-1601784551446-20c9e07cdb9b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 239.0,
      originalPrice: 349.0,
      freeDelivery: true,
      coinsSaved: 110.0,
      coinsSave: 1.0,
      location: 'Dhaka',
    ),
    Product(
      id: '3',
      name: 'For Xiaomi Redmi K60 / K60 PRO / K60E / Poco F5 PRO ...',
      imageUrl:
          'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 249.0,
      originalPrice: 375.0,
      freeDelivery: true,
      coinsSaved: 126.0,
      coinsSave: 4.4,
      location: 'Dhaka',
    ),
    Product(
      id: '6',
      name: 'Portable Rechargeable Fan',
      imageUrl:
          'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 45.0,
      originalPrice: 65.0,
      freeDelivery: false,
      coinsSaved: 20.0,
      coinsSave: 2.0,
      location: 'Chattogram',
    ),
    Product(
      id: '7',
      name: 'Mountain Bike - 21 Speed',
      imageUrl:
          'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 350.0,
      originalPrice: 450.0,
      freeDelivery: true,
      coinsSaved: 100.0,
      coinsSave: 5.0,
      location: 'Dhaka',
    ),
  ];

  SavesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Saved Items'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: savedProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No saved items yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the bookmark icon on any item to save it',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Explore Items'),
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
              itemCount: savedProducts.length,
              itemBuilder: (context, index) {
                final product = savedProducts[index];
                return SavedProductCard(product: product);
              },
            ),
    );
  }
}

// Card widget for saved items (similar to ProductGridCard but with an unsave option)
class SavedProductCard extends StatelessWidget {
  static const Color primaryColor = Color(0xFF381932);
  final Product product;

  const SavedProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 120,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, size: 30),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Product name
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Price row
                Row(
                  children: [
                    Text(
                      '৳${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '৳${product.originalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Discount badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${product.discountPercent}% OFF',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Free delivery
                if (product.freeDelivery)
                  Row(
                    children: [
                      Icon(Icons.local_shipping,
                          size: 12, color: Colors.green.shade700),
                      const SizedBox(width: 2),
                      Text(
                        'FREE',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 2),
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 12, color: Colors.grey.shade600),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        product.location,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Remove from saved button
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                // Show confirmation or just remove
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed from saved'),
                    duration: const Duration(seconds: 1),
                  ),
                );
                // In a real app, you'd remove the item from the list/state
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.bookmark,
                  color: primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}