import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductSectionPage extends StatefulWidget {
  @override
  _ProductSectionPageState createState() => _ProductSectionPageState();
}

class _ProductSectionPageState extends State<ProductSectionPage> {
  int _selectedIndex = 2;
  List<Map<String, dynamic>> cart = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (_, controller) {
            return _buildBottomSheetContent();
          },
        );
      },
    );
  }

  Widget _buildBottomSheetContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left side - Product Grid
            Expanded(
              flex: 3, // Give more space to the left side
              child: Column(
                children: [
                  // Product Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Change to 2 columns
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return _buildProductCard(index);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  // Buttons at the bottom (Optional; can be removed if not needed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add to cart action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                        child: Text("Add to Cart",
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Buy now action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                        child: Text("Buy Now",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),

            // Right side - Order Details
            Expanded(
              flex: 2, // Make the right side wider
              child: _buildOrderDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final List<Map<String, dynamic>> products = [
      {
        'name': 'Lanzones',
        'price': 180,
        'imageUrl':
            'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65'
      },
      {
        'name': 'Rambutans',
        'price': 200,
        'imageUrl':
            'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65'
      },
      {
        'name': 'Durians',
        'price': 140,
        'imageUrl':
            'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65'
      },
      {
        'name': 'Mangoes',
        'price': 120,
        'imageUrl':
            'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65'
      },
      {
        'name': 'Bananas',
        'price': 65,
        'imageUrl':
            'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65'
      },
    ];

    return GestureDetector(
      onTap: () {
        setState(() {
          // Check if the product is already in the cart
          int existingIndex = cart
              .indexWhere((item) => item['name'] == products[index]['name']);
          if (existingIndex >= 0) {
            // If it exists, increment the quantity
            cart[existingIndex]['quantity']++;
          } else {
            // If not, add it to the cart with quantity 1
            cart.add({
              'name': products[index]['name'],
              'price': products[index]['price'],
              'quantity': 1
            });
          }
        });
      },
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                child: Image.network(
                  products[index]['imageUrl']!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                products[index]['name']!,
                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    int total = cart.fold(
        0,
        (sum, item) =>
            sum + (item['price'] as int) * (item['quantity'] as int));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Order/s",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${cart[index]['name']} x${cart[index]['quantity']}'),
                    trailing: Text(
                        '₱${cart[index]['price'] * cart[index]['quantity']}'),
                    onTap: () {
                      setState(() {
                        cart.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOTAL',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                Text('₱$total',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(),
      ),
      body: Stack(
        children: [
          // The scrollable content (Product Details and Recommendations)
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Carousel
                ProductCarousel(
                  imageUrls: [
                    "https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65"
                    // 'https://example.com/image1.jpg',
                    // 'https://example.com/image2.jpg',
                    // 'https://example.com/image3.jpg',
                  ],
                  productName: 'Saplings',
                  price: 180,
                  productsSold: 3100, // Example value
                ),
                SizedBox(height: 16.0),

                // Seller Info Section with Divider
                SellerInfoSection(
                  sellerName: 'John Doe',
                  sellerLocation: 'Tanauan City, Batangas',
                  sellerAvatarUrl: '',
                  rating: 4.8,
                  reviewCount: 1400,
                ),
                SizedBox(height: 16.0),

                // Product Ratings Section with "View All" Button
                ProductRatingsSection(
                  rating: 4.8,
                  reviewCount: 1400,
                ),
                SizedBox(height: 16.0),

                // Latest Reviews Section with Image Carousel and Overlays
                LatestReviewsSection(
                  reviews: const [
                    {
                      'name': 'F****s',
                      'rating': 5,
                      'text': 'Excellent quality! Fast shipping!',
                      'avatarUrl':
                          'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65',
                      'images': [
                        "https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65"
                        // 'https://example.com/review1_img1.jpg',
                        // 'https://example.com/review1_img2.jpg',
                        // 'https://example.com/review1_img3.jpg',
                        // 'https://example.com/review1_img4.jpg',
                        // 'https://example.com/review1_img5.jpg',
                      ]
                    },
                    {
                      'name': 'S****a',
                      'rating': 4,
                      'text': 'Product is good, but delivery took a bit long.',
                      'avatarUrl':
                          'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65',
                      'images': [
                        "https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65"
                            "https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65",
                      ] // No images for this review
                    },
                    {
                      'name': 'M****o',
                      'rating': 5,
                      'text': 'Great seller, will definitely buy again!',
                      'avatarUrl':
                          'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65',
                      'images': [
                        "https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65"
                        // 'https://example.com/review3_img1.jpg',
                        // 'https://example.com/review3_img2.jpg',
                        // 'https://example.com/review3_img3.jpg'
                      ]
                    },
                    {
                      'name': 'L****a',
                      'rating': 5,
                      'text':
                          'Fast shipping and excellent packaging. Highly recommended!',
                      'avatarUrl':
                          'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65',
                      'images': [
                        "https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65"
                        // 'https://example.com/review4_img1.jpg',
                        // 'https://example.com/review4_img2.jpg'
                      ]
                    },
                    {
                      'name': 'P****l',
                      'rating': 5,
                      'text': 'Very satisfied with the product. Thank you!',
                      'avatarUrl':
                          'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65',
                      'images': [
                        "https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65"
                        // 'https://example.com/review5_img1.jpg',
                        // 'https://example.com/review5_img2.jpg',
                        // 'https://example.com/review5_img3.jpg',
                        // 'https://example.com/review5_img4.jpg',
                        // 'https://example.com/review5_img5.jpg',
                        // 'https://example.com/review5_img6.jpg'
                      ]
                    },
                  ],
                ),
                SizedBox(height: 16.0),

                // Recommendations Section
                RecommendationsSection(
                  recommendations: [
                    {
                      'name': 'Product A',
                      'rating': 4,
                      'sold': 1200,
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65',
                    },
                    {
                      'name': 'Product B',
                      'rating': 5,
                      'sold': 1500,
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65',
                    },
                    {
                      'name': 'Product C',
                      'rating': 4,
                      'sold': 980,
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65',
                    },
                    {
                      'name': 'Product D',
                      'rating': 5,
                      'sold': 1300,
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/captainstone-e005a.appspot.com/o/products%2Fproduct-idTDZgtkiOykhUNaeSpQAwDZrif3z2%2Fvariant-images%2Fasd?alt=media&token=cd179fae-94fb-484b-b8ac-8db3e2af5b65',
                    },
                  ],
                ),
                SizedBox(height: 80), // Adding space for sticky bar
              ],
            ),
          ),

          // Sticky Bottom Bar (Now Touching Bottom Navigation Bar)
          Positioned(
            bottom: 0, // Sticky bar touching the bottom navigation bar
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -1), // Shadow above the bar
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Shop Icon Button
                  IconButton(
                    onPressed: () {
                      // Handle Shop icon button action
                    },
                    icon: Icon(Icons.store),
                    color: Colors.green.shade700,
                    iconSize: 30.0,
                  ),
                  // Chat Seller Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Chat Seller action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: Icon(Icons.chat_bubble_outline),
                    label: Text("Chat Seller"),
                  ),

                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),

                  // Buy Now Button
                  ElevatedButton(
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Buy Now",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  hintText: 'Search a Crop!',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.search, size: 24.0),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  // Placeholder for future search function
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.people),
                onPressed: () {
                  // Placeholder for future community function
                },
              ),
              const Positioned(
                right: 4,
                top: 4,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    '3', // Notification count
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Placeholder for future cart function
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
    );
  }
}

class ProductCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final String productName;
  final int price;
  final int productsSold;

  ProductCarousel({
    required this.imageUrls,
    required this.productName,
    required this.price,
    required this.productsSold,
  });

  @override
  _ProductCarouselState createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int _currentImageIndex = 0;
  bool _isLiked = false;

  String _formatProductsSold(int sold) {
    if (sold >= 1000) {
      return '${(sold / 1000).toStringAsFixed(1)}k';
    }
    return '$sold';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carousel Slider for Images
        Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300.0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
              ),
              items: widget.imageUrls.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                );
              }).toList(),
            ),
            // Like/Heart Button on top of carousel
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 10),

        // Image Thumbnails Slider (Horizontal)
        Container(
          height: 80, // Fixed height for thumbnail section
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.imageUrls.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentImageIndex == index
                            ? Colors.green.shade700
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Image.network(
                      widget.imageUrls[index],
                      width: 60,
                      height: 60,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 10),

        // Product Details Section with background color
        Container(
          color: Colors.green, // Background color for product details
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Product Price and Name
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₱${widget.price}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.productName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              // Sold count and Like button aligned to the right
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatProductsSold(widget.productsSold)} Sold',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isLiked = !_isLiked;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SellerInfoSection extends StatelessWidget {
  final String sellerName;
  final String sellerLocation;
  final String sellerAvatarUrl;
  final double rating;
  final int reviewCount;

  SellerInfoSection({
    required this.sellerName,
    required this.sellerLocation,
    required this.sellerAvatarUrl,
    required this.rating,
    required this.reviewCount,
  });

  String _formatReviewCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Seller Info Section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Seller Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(sellerAvatarUrl),
                  ),
                  SizedBox(width: 16.0),
                  // Seller Information (Name & Location)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sellerName,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        sellerLocation,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
              // "View Shop" Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.green.shade700,
                ),
                onPressed: () {
                  // Handle "View Shop" button tap
                },
                child: Text(
                  'View Shop',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        // Separator Line
        Divider(
          color: Colors.grey.shade300,
          thickness: 1.0,
          height: 1.0,
        ),
      ],
    );
  }
}

class ProductRatingsSection extends StatelessWidget {
  final double rating;
  final int reviewCount;

  ProductRatingsSection({
    required this.rating,
    required this.reviewCount,
  });

  String _formatReviewCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Rating Star Icon
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 24.0,
              ),
              SizedBox(width: 4),

              // Display Product Rating
              Text(
                '$rating',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
              ),

              SizedBox(width: 8),

              // Review Count
              Text(
                'Product Ratings (${_formatReviewCount(reviewCount)})',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
            ],
          ),
          // "View All" Button aligned to the right
          TextButton(
            onPressed: () {
              // Navigate to full reviews page
            },
            child: Text(
              'View All',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class LatestReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  LatestReviewsSection({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Reviews',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
          ),
          SizedBox(height: 10),
          Column(
            children: List.generate(
              reviews.length > 3 ? 3 : reviews.length,
              (index) {
                var review = reviews[index];
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: review['avatarUrl'] != null
                              ? NetworkImage(review['avatarUrl'])
                              : null,
                          child: review['avatarUrl'] == null
                              ? Icon(Icons.person, size: 20)
                              : null,
                        ),
                        SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review['name'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  return Icon(
                                    starIndex < review['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 16,
                                  );
                                }),
                              ),
                              SizedBox(height: 4),
                              Text(
                                review['text'],
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (review['images'] != null &&
                                  review['images'].length > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child:
                                      _buildImageRow(context, review['images']),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      height: 16.0,
                      thickness: 1.0,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageRow(BuildContext context, List<String> images) {
    int imageCount = images.length;

    return Row(
      children: List.generate(
        imageCount > 3 ? 3 : imageCount,
        (index) {
          if (index == 2 && imageCount > 3) {
            return _buildMoreImagesIndicator(context, images, imageCount);
          } else {
            return _buildReviewImage(context, images, index);
          }
        },
      ),
    );
  }

  Widget _buildReviewImage(
      BuildContext context, List<String> images, int index) {
    return GestureDetector(
      onTap: () {
        _showImageFullScreen(context, images, index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        width: 80,
        height: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            images[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMoreImagesIndicator(
      BuildContext context, List<String> images, int totalImages) {
    return GestureDetector(
      onTap: () {
        _showImageFullScreen(context, images, 2);
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                images[2],
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.6),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                '+${totalImages - 3}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageFullScreen(
      BuildContext context, List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageCarousel(
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class FullScreenImageCarousel extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  FullScreenImageCarousel({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              initialPage: initialIndex,
            ),
            itemCount: images.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return Center(
                child: Image.network(
                  images[itemIndex],
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationsSection extends StatelessWidget {
  final List<Map<String, dynamic>> recommendations;

  RecommendationsSection({required this.recommendations});

  String _formatSoldCount(int sold) {
    if (sold >= 1000) {
      return '${(sold / 1000).toStringAsFixed(1)}k';
    }
    return '$sold';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended for You',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
          ),
          SizedBox(height: 10),

          // GridView for 2-column layout
          GridView.builder(
            physics:
                NeverScrollableScrollPhysics(), // Prevent inner scroll, use the main scroll
            shrinkWrap: true, // Allows GridView inside a Column
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 12.0, // Spacing between columns
              mainAxisSpacing: 12.0, // Spacing between rows
              childAspectRatio: 0.75, // Adjust the height of the card
            ),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final product = recommendations[index];
              return GestureDetector(
                onTap: () {
                  // Handle product card tap
                },
                child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: Image.network(
                          product['imageUrl'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              product['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.0),

                            // Row for Rating (Numerical + Stars) and Sold Items
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Rating (Numerical + Stars)
                                Row(
                                  children: [
                                    Text(
                                      product['rating'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          ),
                                    ),
                                    SizedBox(width: 4.0),
                                    Row(
                                      children: List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < product['rating']
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      }),
                                    ),
                                  ],
                                ),

                                // Number of items sold (formatted)
                                Text(
                                  '${_formatSoldCount(product['sold'])} sold',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
