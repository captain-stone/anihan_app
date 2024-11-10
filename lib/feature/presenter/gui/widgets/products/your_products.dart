// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/product_favorite_cubit/product_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../../domain/entities/product_entity.dart';

import '../../pages/user_information_bloc/user_information_page.dart';

class YourProduct extends StatefulWidget {
  final String uid;
  final BuildContext sellerContext;
  final List<ProductEntity> state;
  const YourProduct(this.uid, this.sellerContext, this.state, {super.key});

  @override
  State<YourProduct> createState() => _YourProductState();
}

class _YourProductState extends State<YourProduct> {
  late Future<List<ProductEntity>> _recommendedProductsFuture;
  // final _userBloc = getIt<UserInformationBlocBloc>();
  final FirebaseDatabase db = FirebaseDatabase.instance;
  late List<ProductEntity> state;
  final logger = Logger();
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    state = widget.state;
    _recommendedProductsFuture = _fetchRecommendedProducts();
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void didUpdateWidget(YourProduct oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      setState(() {
        state = widget.state;
        _recommendedProductsFuture =
            _fetchRecommendedProducts(); // Refresh the future
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<List<ProductEntity>> _fetchRecommendedProducts() async {
    // return state
    //     .map((e) => Product(
    //         imageUrl: e.productImage.first,
    //         name: e.productName,
    //         price: e.productPrice))
    //     .toList();
    return state.map((e) => e).toList();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference _userUpdate = db.ref("products/product-id${widget.uid}/");
    // context.read();
    // var data = widget.sellerContext.widget.key;
    if (state.isNotEmpty) {
      return FutureBuilder<List<ProductEntity>>(
        future: _recommendedProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            logger.e(snapshot.error);
            return const Center(
              child: Text('Failed to load products. Please try again.'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _buildProductGrid(snapshot.data!);
          } else {
            return const Center(
              child: Text('No recommended products available.'),
            );
          }
        },
      );
    } else {
      return const SizedBox(
        child:
            Center(child: Text("You don't have any products, please add one")),
      );
    }
  }

  Widget _buildProductGrid(List<ProductEntity> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return ProductCard(
            uid: widget.uid,
            product: products[index],
            dist: ProductDist.personal,
          );
        },
      ),
    );
  }

  // Widget _buildProductCard(ProductEntity product) {
  //   return GestureDetector(
  //     onTap: () {
  //       logger.d(product.productVariant);
  //     },
  //     child: Card(
  //       elevation: 4,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12.0),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           ClipRRect(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(12),
  //               topRight: Radius.circular(12),
  //             ),
  //             child: SizedBox(
  //               height: 150, // Adjust height as needed
  //               child: Stack(
  //                 children: [
  //                   PageView.builder(
  //                     controller: _pageController,
  //                     itemCount: product.productImage.length,
  //                     itemBuilder: (context, index) {
  //                       return Image.network(
  //                         product.productImage[
  //                             index], // Use the current index for different images
  //                         fit: BoxFit.cover,
  //                       );
  //                     },
  //                   ),
  //                   Positioned(
  //                     bottom: 10, // Position the dots at the bottom
  //                     left: 0,
  //                     right: 0,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children:
  //                           List.generate(product.productImage.length, (index) {
  //                         return Container(
  //                           margin: const EdgeInsets.symmetric(horizontal: 4.0),
  //                           width: _currentPage == index ? 12.0 : 8.0,
  //                           height: 8.0,
  //                           decoration: BoxDecoration(
  //                             color: _currentPage == index
  //                                 ? Colors.blue
  //                                 : Colors.grey,
  //                             borderRadius: BorderRadius.circular(4.0),
  //                           ),
  //                         );
  //                       }),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Text(
  //               product.productName,
  //               style: const TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black87,
  //               ),
  //               maxLines: 1,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //             child: Text(
  //               '₱${product.productPrice.toStringAsFixed(2)}',
  //               style: const TextStyle(
  //                 fontSize: 14,
  //                 color: Colors.green,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
