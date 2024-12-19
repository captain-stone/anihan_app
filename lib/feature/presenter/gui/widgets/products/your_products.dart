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
  const YourProduct(this.uid,
      {super.key, required this.state, required this.sellerContext});

  @override
  State<YourProduct> createState() => _YourProductState();
}

class _YourProductState extends State<YourProduct> {
  late Future<List<ProductEntity>> _recommendedProductsFuture;

  List<ProductEntity> _state = [];
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    setState(() {
      _state = widget.state;
      _recommendedProductsFuture = _fetchRecommendedProducts();
    });
  }

  @override
  void didUpdateWidget(YourProduct oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state != widget.state) {
      setState(() {
        _state = widget.state;
        _recommendedProductsFuture = _fetchRecommendedProducts();
      });
    }
  }

  Future<List<ProductEntity>> _fetchRecommendedProducts() async {
    return _state.map((e) => e).toList();
  }

  @override
  Widget build(BuildContext context) {
    // context.read();
    // var data = widget.sellerContext.widget.key;
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
          var data = snapshot.data!
              .where((value) => value.storeId == "storeId-${widget.uid}-id")
              .toList();

          return _buildProductGrid(data);
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
          return ProductCard(
            parentContext: widget.sellerContext,
            uid: widget.uid,
            product: products[index],
            productList: products,
            dist: ProductDist.personal,
            isFavoriteProduct: null,
          );
        },
      ),
    );
  }
}
