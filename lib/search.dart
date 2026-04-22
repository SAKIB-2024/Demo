import 'package:flutter/material.dart';
import 'homepage.dart'; // For Product model (consider moving to a shared file)

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const Color primaryColor = Color(0xFF381932);
  static const Color backgroundColor = Color(0xFFF0EDE9);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Product> _searchResults = [];

  // Dummy full product list for searching
  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Full cover soft case',
      imageUrl: 'https://images.unsplash.com/photo-1601784551446-20c9e07cdb9b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 239.0,
      originalPrice: 349.0,
      freeDelivery: true,
      coinsSaved: 110.0,
      coinsSave: 1.0,
      location: 'Dhaka',
    ),
    Product(
      id: '2',
      name: 'Transparent Anti-Fingerprint case',
      imageUrl: 'https://images.unsplash.com/photo-1586953208448-b95a79798f07?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 189.0,
      originalPrice: 328.0,
      freeDelivery: true,
      coinsSaved: 139.0,
      coinsSave: 1.0,
      location: 'Dhaka',
    ),
    Product(
      id: '3',
      name: 'For Xiaomi Redmi K60 / K60 PRO / K60E / Poco F5 PRO ...',
      imageUrl: 'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 249.0,
      originalPrice: 375.0,
      freeDelivery: true,
      coinsSaved: 126.0,
      coinsSave: 4.4,
      location: 'Dhaka',
    ),
    Product(
      id: '4',
      name: 'For Xiaomi Poco F5 / Redmi Note 12 Turbo Premium Qu...',
      imageUrl: 'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 199.0,
      originalPrice: 319.0,
      freeDelivery: true,
      coinsSaved: 120.0,
      coinsSave: 4.8,
      location: 'Dhaka',
    ),
    Product(
      id: '5',
      name: 'For Xiaomi Poco F5 Xundd Bumper Case Reinforced C...',
      imageUrl: 'https://images.unsplash.com/photo-1541872703-74c5e44368f9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 229.0,
      originalPrice: 355.0,
      freeDelivery: true,
      coinsSaved: 126.0,
      coinsSave: 4.4,
      location: 'Dhaka',
    ),
    Product(
      id: '6',
      name: 'Portable Rechargeable Fan',
      imageUrl: 'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
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
      imageUrl: 'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      price: 350.0,
      originalPrice: 450.0,
      freeDelivery: true,
      coinsSaved: 100.0,
      coinsSave: 5.0,
      location: 'Dhaka',
    ),
  ];

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allProducts.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase()) ||
                 product.location.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search for items...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: _searchQuery.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Search for products',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
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
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final product = _searchResults[index];
                    return SearchProductCard(product: product);
                  },
                ),
    );
  }
}

// Simplified card for search results (reusing style from homepage)
class SearchProductCard extends StatelessWidget {
  final Product product;

  const SearchProductCard({super.key, required this.product});

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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
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
            Text(
              '৳${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.location_on, size: 12, color: Colors.grey.shade600),
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
    );
  }
}