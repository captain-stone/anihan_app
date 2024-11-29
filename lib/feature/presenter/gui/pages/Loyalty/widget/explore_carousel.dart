import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ExploreCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      "image": "assets/apple.png",
      "title": "Apples",
      "description": "Different varieties to choose from",
      "available": 10,
      "max": 5, // Maximum units allowed per person
      "totalStock": 50, // Total stock available
    },
    {
      "image": "assets/apple.png",
      "title": "Berries",
      "description": "Fresh berries, perfect for snacking",
      "available": 20,
      "max": 10, // Maximum units allowed per person
      "totalStock": 100, // Total stock available
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider.builder(
          itemCount: items.length,
          itemBuilder: (context, index, realIndex) {
            final item = items[index];
            return _buildCarouselCard(context, item);
          },
          options: CarouselOptions(
            height: 320, // Adjusted height for layout
            autoPlay: true,
            enlargeCenterPage: true,
            autoPlayCurve: Curves.easeInOut,
            aspectRatio: 16 / 9,
            viewportFraction: 0.85,
          ),
        ),
      ],
    );
  }

  /// Build a visually enhanced carousel card
  Widget _buildCarouselCard(BuildContext context, Map<String, dynamic> item) {
    return Stack(
      children: [
        // Product Image Background
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              item['image'],
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),

        // Overlay Gradient for Text
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.4),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),

        // Product Details
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Title
              Text(
                item['title'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              SizedBox(height: 4),

              // Product Description
              Text(
                item['description'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              SizedBox(height: 12),

              // Progress Bar and Stock Information
              _buildProductQuantityBar(context, item),

              SizedBox(height: 10),

              // Claim Now Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(
                  'Claim Now',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a product quantity bar with labels for "Available" and "Max"
  Widget _buildProductQuantityBar(
      BuildContext context, Map<String, dynamic> item) {
    final available = item['available'];
    final totalStock = item['totalStock'];
    final maxPerPerson = item['max'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Total Stock Available
            Text(
              'Available: $available/$totalStock',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            // Maximum Units Allowed Per Person
            Text(
              'Max per person: $maxPerPerson',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
        SizedBox(height: 4),
        // Progress Bar
        LinearProgressIndicator(
          value: available / totalStock, // Reflect available vs total stock
          backgroundColor: Colors.grey[400],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ],
    );
  }
}
