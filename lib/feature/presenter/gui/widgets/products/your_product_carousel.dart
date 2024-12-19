// ignore_for_file: no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'cubit/product_update_cubit.dart';

class YourProductCarousel extends StatefulWidget {
  final String productId;
  final List<String> imageUrls;
  final String productLabel;
  final String productName;
  final double price;
  final int productsSold;
  final int productQuantity;
  final List<ProductVariantEntity?> productVariantEntity;

  const YourProductCarousel({
    super.key,
    required this.productId,
    required this.imageUrls,
    required this.productLabel,
    required this.productName,
    required this.price,
    required this.productsSold,
    required this.productQuantity,
    required this.productVariantEntity,
  });

  @override
  _YourProductCarouselState createState() => _YourProductCarouselState();
}

class _YourProductCarouselState extends State<YourProductCarousel> {
  final logger = Logger();
  final _updateProductCubit = getIt<ProductUpdateCubit>();
  int _currentImageIndex = 0;
  bool _isLiked = false;
  List<String> allImageUrl = [];
  // List<String> allProductEntity = [];
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int totalKg = 0;
  int addKilo = 0;
  int productKilo = 0;
  int productKiloVariantKilo = 0;
  List<int> productKiloQuantities = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      // widget.
      productKilo = widget.productQuantity;
      allImageUrl = [...widget.imageUrls];

      for (var image in widget.productVariantEntity) {
        if (image != null && image.images != null) {
          allImageUrl.add(image.images!);
        }
      }

      if (widget.productVariantEntity.isNotEmpty) {
        productKiloQuantities = List.generate(
          widget.productVariantEntity.length,
          (index) {
            var variant = widget.productVariantEntity[index];
            if (variant != null && variant.variantQuantity != null) {
              return double.tryParse(variant.variantQuantity!)?.toInt() ?? 0;
            }
            return 0;
          },
        );

        totalKg = productKiloQuantities.reduce((a, b) => a + b);
      }
    });
    // logger.d(allImageUrl);
  }

  String _formatProductsSold(int sold) {
    if (sold >= 1000) {
      return '${(sold / 1000).toStringAsFixed(1)}k';
    }
    return '$sold';
  }

  void updateQuantity(int index, int newQuantity) {
    setState(() {
      // Update the quantity for the specific variant at [index]
      productKiloQuantities[index] = newQuantity;
    });
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
                  logger.d(_currentImageIndex);
                },
              ),
              items: allImageUrl.map((imageUrl) {
                // logger.e(imageUrl);
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
                    'Total Kilo: ${totalKg + productKilo}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.productLabel,
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

        const SizedBox(height: 10),

        GestureDetector(
          onTap: () {
            setState(() {
              _currentImageIndex = 0;
            });
            _carouselController.animateToPage(0);
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.grey.shade300), // Border for items
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white, // Background color for the item
              ),
              child: Row(
                children: [
                  Image.network(
                    widget.imageUrls[0],
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.productName),
                      Text(widget.price.toStringAsFixed(2)),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            if (productKilo > 0) {
                              setState(() {
                                // productKilo = value--;
                                productKilo--;
                                _updateProductCubit.updateMainProductQuantity(
                                    widget.productId,
                                    widget.productName,
                                    productKilo);
                              });
                            }
                          },
                          icon: const Icon(Icons.remove)),
                      Text("${productKilo.toString()} kg"),
                      IconButton(
                          onPressed: () {
                            if (productKilo > 0) {
                              setState(() {
                                // productKilo = value--;
                                productKilo++;

                                _updateProductCubit.updateMainProductQuantity(
                                    widget.productId,
                                    widget.productName,
                                    productKilo);
                              });
                            }
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        if (widget.productVariantEntity.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.3, // Fixed height for thumbnail section
              child: ListView.builder(
                scrollDirection: Axis.vertical, // To make the list horizontal
                itemCount: widget.productVariantEntity.length, // Count of items
                itemBuilder: (context, index) {
                  int _index = index + widget.imageUrls.length;

                  productKiloVariantKilo = int.tryParse(
                      widget.productVariantEntity[index]!.variantQuantity!)!;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentImageIndex = _index;
                      });
                      _carouselController.animateToPage(_index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 70,
                        width: 70,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300), // Border for items
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white, // Background color for the item
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              widget.productVariantEntity[index]!.images!,
                              width: 60,
                              height: 60,
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget
                                    .productVariantEntity[index]!.varianName!),
                                Text(widget.productVariantEntity[index]!
                                    .variantPrice!),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      logger.d(index);
                                      // if (_index == _currentImageIndex) {
                                      if (productKiloQuantities[index] > 0) {
                                        setState(() {
                                          productKiloQuantities[index]--;
                                          totalKg--;

                                          _updateProductCubit
                                              .updateVariantMainProductQuantity(
                                                  widget.productId,
                                                  index,
                                                  productKiloQuantities[index]);

                                          // updateQuantity(index,
                                          //     productKiloQuantities[index]);
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.remove)),
                                Text("${productKiloQuantities[index]} kg"),
                                IconButton(
                                    onPressed: () {
                                      if (productKiloQuantities[index] > 0) {
                                        setState(() {
                                          productKiloQuantities[index]++;
                                          totalKg++;

                                          _updateProductCubit
                                              .updateVariantMainProductQuantity(
                                                  widget.productId,
                                                  index,
                                                  productKiloQuantities[index]);
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.add)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        // SizedBox(
        //   height: 500,
        //   width: 500,
        //   child: ListView.builder(
        //     itemCount: widget.productVariantEntity.length,
        //     itemBuilder: (context, index) {
        //       final variant = widget.productVariantEntity[index];

        //       return Padding(
        //         padding: const EdgeInsets.symmetric(
        //             vertical: 18.0, horizontal: 18.0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             // Variant Details
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   variant?.varianName ?? 'Variant Name',
        //                   style: Theme.of(context).textTheme.bodyLarge,
        //                 ),
        //                 Text(
        //                   '₱${variant?.variantPrice ?? 0}',
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .bodyMedium!
        //                       .copyWith(color: Colors.black54),
        //                 ),
        //               ],
        //             ),

        //             // Editable Quantity
        //             Row(
        //               children: [
        //                 IconButton(
        //                   icon: const Icon(Icons.remove),
        //                   onPressed: () {
        //                     setState(() {
        //                       int variantQuantity =
        //                           int.parse(variant?.variantQuantity ?? "0");
        //                       if (variantQuantity > 0) {
        //                         variantQuantity--;
        //                       }
        //                     });
        //                   },
        //                 ),
        //                 Text(
        //                   '${variant?.variantQuantity ?? 0}',
        //                   style: Theme.of(context).textTheme.bodyMedium,
        //                 ),
        //                 IconButton(
        //                   icon: const Icon(Icons.add),
        //                   onPressed: () {
        //                     int variantQuantityAdd =
        //                         int.parse(variant?.variantQuantity ?? "0");
        //                     setState(() {
        //                       variantQuantityAdd++;
        //                     });
        //                   },
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
