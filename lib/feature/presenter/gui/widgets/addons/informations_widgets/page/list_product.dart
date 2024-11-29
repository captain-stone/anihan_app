// ignore_for_file: library_private_types_in_public_api

import 'package:anihan_app/common/api_result.dart';

import 'package:anihan_app/feature/presenter/gui/widgets/products/product_view_page.dart';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import '../../../../../../domain/entities/product_entity.dart';

class ListProduct extends StatefulWidget {
  final ProductDist dist;
  final ProductEntity product;
  final String uid;
  final BuildContext parentContext;
  final bool? isFavoriteProduct;

  const ListProduct({
    super.key,
    required this.uid,
    required this.product,
    required this.dist,
    required this.parentContext,
    this.isFavoriteProduct,
  });

  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  late PageController _pageController;
  int _currentPage = 0;
  bool isFavorite = false;
  final logger = Logger();

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProductSectionPage(
            uid: widget.uid,
            checkUserContext: widget.parentContext,
            productEntity: widget.product,
          );
        }));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: SizedBox(
                height: 150, // Adjust height as needed
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: widget.product.productImage.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.product.productImage[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 10, // Position the dots at the bottom
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                            widget.product.productImage.length, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            width: _currentPage == index ? 12.0 : 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.green
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.productName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '₱${widget.product.productPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
