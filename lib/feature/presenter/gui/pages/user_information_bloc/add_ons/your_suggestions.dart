// ignore_for_file: library_private_types_in_public_api

import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/add_ons/product_card.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../../../domain/entities/product_entity.dart';
import '../user_information_page.dart';

class YouMayLikeWidget extends StatefulWidget {
  final String uid;
  final List<ProductEntity> state;
  const YouMayLikeWidget(this.uid, {super.key, required this.state});

  @override
  _YouMayLikeWidgetState createState() => _YouMayLikeWidgetState();
}

class _YouMayLikeWidgetState extends State<YouMayLikeWidget> {
  // late Future<List<Product>> _recommendedProductsFuture;
  late Future<List<ProductEntity>> _recommendedProductsFuture;

  late final List<ProductEntity> state;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    setState(() {
      state = widget.state;
      _recommendedProductsFuture = _fetchRecommendedProducts();
    });
  }

  @override
  void didUpdateWidget(YouMayLikeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      setState(() {
        state = widget.state;
        _recommendedProductsFuture =
            _fetchRecommendedProducts(); // Refresh the future
      });
    }
  }

  // Future<List<Product>> _fetchRecommendedProducts() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   // logger.d(state);

  //   return state
  //       .map((e) => Product(
  //           imageUrl: e.productImage.first,
  //           name: e.productName,
  //           price: e.productPrice))
  //       .toList();
  // }

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
    return FutureBuilder<List<ProductEntity>>(
      future: _recommendedProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
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
          return ProductCard(uid: widget.uid, product: products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        logger.d("THIS PRODUCT CLIC");
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
              child: Image.network(
                product.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.name,
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
                '\$${product.price.toStringAsFixed(2)}',
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
