import 'dart:async'; // <-- Added for Timer
import 'package:flutter/material.dart';
import 'profile.dart';
import 'cart.dart';
import 'saves.dart';
import 'chat.dart';
import 'upload.dart';
import 'search.dart';

// Model for a marketplace product
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double originalPrice;
  final bool freeDelivery;
  final double coinsSaved;
  final double coinsSave;
  final String location;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    this.freeDelivery = false,
    this.coinsSaved = 0.0,
    this.coinsSave = 0.0,
    required this.location,
  });

  int get discountPercent =>
      ((originalPrice - price) / originalPrice * 100).round();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryColor = Color(0xFF381932);
  static const Color backgroundColor = Color(0xFFF0EDE9);

  // Sample product data
  final List<Product> products = [
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
      id: '2',
      name: 'Transparent Anti-Fingerprint case',
      imageUrl:
          'https://images.unsplash.com/photo-1586953208448-b95a79798f07?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
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
      id: '4',
      name: 'For Xiaomi Poco F5 / Redmi Note 12 Turbo Premium Qu...',
      imageUrl:
          'https://images.unsplash.com/photo-1611186871348-b1ce696e52c9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
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
      imageUrl:
          'https://images.unsplash.com/photo-1541872703-74c5e44368f9?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
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

  final List<String> filters = [
    'Best Match',
    'Filter',
    'Voucher Max',
    'Mall',
    'Free Delivery',
    'Buy More Save',
  ];

  int _selectedFilterIndex = 0;
  int _selectedNavIndex = 0;
  String _selectedExploreMode = 'Rent';

  // Carousel properties
  late PageController _carouselController;
  late Timer _carouselTimer;
  int _currentCarouselPage = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Electronics',
      'image':
          'https://images.unsplash.com/photo-1498049794561-7780e7231661?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Furniture',
      'image':
          'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Vehicles',
      'image':
          'https://images.unsplash.com/photo-1580273916550-e323be2ae537?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Accessories',
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Other',
      'image':
          'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = PageController();
    _startCarouselTimer();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_carouselController.hasClients) {
        final nextPage = (_currentCarouselPage + 1) % _categories.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SavesPage()));
      return;
    }
    if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatListPage()));
      return;
    }
    if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileWrapper()));
      return;
    }
    setState(() {
      _selectedNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Rental Market'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips row
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilterIndex = selected ? index : 0;
                      });
                    },
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: primaryColor,
                    checkmarkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? primaryColor : Colors.grey.shade300,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Main scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------------- Category Carousel -------------------
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _carouselController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentCarouselPage = index;
                            });
                          },
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(category['image']),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.3),
                                    BlendMode.darken,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  category['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black38,
                                        blurRadius: 10,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        // Page indicators
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _categories.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentCarouselPage == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _currentCarouselPage == index
                                      ? primaryColor
                                      : Colors.white.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // ----------------------------------------------------------

                  // Explore section with Rent/Buy toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(foregroundColor: primaryColor),
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                  ),
                  // Rent / Buy toggle buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ExploreToggleButton(
                            label: 'Rent',
                            isSelected: _selectedExploreMode == 'Rent',
                            onTap: () {
                              setState(() {
                                _selectedExploreMode = 'Rent';
                              });
                            },
                            selectedColor: primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ExploreToggleButton(
                            label: 'Buy',
                            isSelected: _selectedExploreMode == 'Buy',
                            onTap: () {
                              setState(() {
                                _selectedExploreMode = 'Buy';
                              });
                            },
                            selectedColor: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bills & Vouchers horizontal row
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Bills & Vouchers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        final List<Map<String, dynamic>> vouchers = [
                          {
                            'icon': Icons.receipt_long,
                            'label': 'Pay Bills',
                            'color': Colors.orange
                          },
                          {
                            'icon': Icons.local_offer,
                            'label': 'Vouchers',
                            'color': Colors.purple
                          },
                          {
                            'icon': Icons.credit_card,
                            'label': 'Top Up',
                            'color': Colors.green
                          },
                          {
                            'icon': Icons.card_giftcard,
                            'label': 'Rewards',
                            'color': Colors.red
                          },
                        ];
                        final item = vouchers[index];
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: (item['color'] as Color).withOpacity(0.15),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: item['color'] as Color,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item['label'] as String,
                                style: const TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Recommended items header
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recommended for you',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(foregroundColor: primaryColor),
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Two‑column grid with transparent cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductGridCard(product: product);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: primaryColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.bookmark_border,
                activeIcon: Icons.bookmark,
                label: 'Save',
                index: 1,
              ),
              const SizedBox(width: 48),
              _buildNavItem(
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: 'Chat',
                index: 3,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                index: 4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadPage()));
          },
          backgroundColor: primaryColor,
          elevation: 8,
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedNavIndex == index;
    return InkWell(
      onTap: () => _onNavItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? Colors.white : Colors.white70,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// Toggle button for Rent/Buy
class _ExploreToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;

  const _ExploreToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// Grid card (vertical layout) with transparent/glass effect
class ProductGridCard extends StatelessWidget {
  final Product product;

  const ProductGridCard({super.key, required this.product});

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
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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