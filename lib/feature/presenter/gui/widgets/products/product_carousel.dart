// ignore_for_file: no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final String productName;
  final double price;
  final int productsSold;
  final List<ProductVariantEntity?> productVariantEntity;

  const ProductCarousel({
    super.key,
    required this.imageUrls,
    required this.productName,
    required this.price,
    required this.productsSold,
    required this.productVariantEntity,
  });

  @override
  _ProductCarouselState createState() => _ProductCarouselState();
}

class _ProductCarouselState extends State<ProductCarousel> {
  int _currentImageIndex = 0;
  bool _isLiked = false;
  List<String> allImageUrl = [];
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    setState(() {
      allImageUrl = [...widget.imageUrls];

      for (var image in widget.productVariantEntity) {
        if (image != null && image.images != null) {
          allImageUrl.add(image.images!);
        }
      }
    });
  }

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
              carouselController: _carouselController,
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
              items: allImageUrl.map((imageUrl) {
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

            //indicator
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(allImageUrl.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentImageIndex == index ? 12.0 : 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.green
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  );
                }),
              ),
            ),

            Positioned(
              bottom: 10,
              // left: 0,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the text
                children: [
                  Text(
                    "${_currentImageIndex + 1}/${allImageUrl.length}", // Add 1 to _currentImageIndex to make it 1-based
                    style: const TextStyle(
                      color: Colors.white, // Adjust for visibility
                      fontSize: 16, // Font size for the indicator
                      fontWeight: FontWeight
                          .bold, // Make the text bold for better readability
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Image Thumbnails Slider (Horizontal)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(widget.productVariantEntity.length > 1
              ? '${widget.productVariantEntity.length} Variations Available'
              : '${widget.productVariantEntity.length} Variation Available'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            height: 80, // Fixed height for thumbnail section
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    List.generate(widget.productVariantEntity.length, (index) {
                  //index of variant
                  int _index = index + widget.imageUrls.length;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentImageIndex = _index;
                      });
                      _carouselController.animateToPage(_index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _currentImageIndex == _index
                              ? Colors.green.shade700
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Image.network(
                        widget.productVariantEntity[index]!.images!,
                        width: 60,
                        height: 60,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

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
                    _currentImageIndex + 1 > widget.imageUrls.length
                        ? '₱${widget.productVariantEntity[(_currentImageIndex) - widget.imageUrls.length]!.variantPrice!}'
                        : '₱${widget.price}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 4),
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
