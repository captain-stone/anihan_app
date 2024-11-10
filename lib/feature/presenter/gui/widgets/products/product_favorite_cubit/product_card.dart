// ignore_for_file: library_private_types_in_public_api

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/product_showcase_bloc/your_product_showcase.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/product_favorite_cubit/product_favorite_cubit.dart';

import 'package:anihan_app/feature/presenter/gui/widgets/products/product_view_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../../domain/entities/product_entity.dart';

class ProductCard extends StatefulWidget {
  final ProductDist dist;
  final ProductEntity product;
  final String uid;

  const ProductCard(
      {super.key,
      required this.uid,
      required this.product,
      required this.dist});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late PageController _pageController;
  int _currentPage = 0;
  bool isFavorite = false;
  final logger = Logger();
  @override
  void initState() {
    super.initState();
    // logger.d(widget.product);
    context
        .read<ProductFavoriteCubit>()
        .addToFavorite(widget.product.productKey);
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

  _favorite(String productKey) {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      logger.i('Product $productKey added to favorites');
      context.read<ProductFavoriteCubit>().addToFavorite(productKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductFavoriteCubit, ProductFavoriteState>(
      listener: (context, state) {
        if (state is ProductFavoriteSuccessState) {
          var data = state.successMessage;
          // logger.d(data);
          // isFavorite = data["favorite"];
          if (data['favorite'] == widget.product.productKey) {
            isFavorite = true;
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          logger.d(widget.product.productKey);
          logger.d(isFavorite);

          if (widget.dist == ProductDist.personal) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return YourProductShowcase(
                products: widget.product,
              );
            }));
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ProductSectionPage();
            }));
          }

          // AutoRouter.of(context).push(CustomProductViewingRoute(
          //     uid: widget.uid, product: widget.product));
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
                          top: 5,
                          right: 5,
                          child: IconButton(
                              onPressed: () {
                                var productKey = widget.product.productKey;
                                _favorite(productKey);
                              },
                              icon: isFavorite
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite))),
                      Positioned(
                        bottom: 10, // Position the dots at the bottom
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              widget.product.productImage.length, (index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
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
      ),
    );
  }
}

// Update the product grid method
// Widget _buildProductGrid(List<ProductEntity> products) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     child: GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: products.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10.0,
//         mainAxisSpacing: 10.0,
//         childAspectRatio: 0.75,
//       ),
//       itemBuilder: (context, index) {
//         return ProductCard(
//             product: products[index]); // Use the new ProductCard widget
//       },
//     ),
//   );
// }
