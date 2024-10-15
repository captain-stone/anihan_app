// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../../../domain/entities/product_entity.dart';

import '../user_information_page.dart';

class YourProduct extends StatefulWidget {
  final String uid;
  final BuildContext sellerContext;
  final List<ProductEntity> state;
  const YourProduct(this.uid, this.sellerContext, this.state, {super.key});

  @override
  State<YourProduct> createState() => _YourProductState();
}

class _YourProductState extends State<YourProduct> {
  late Future<List<Product>> _recommendedProductsFuture;
  // final _userBloc = getIt<UserInformationBlocBloc>();
  final FirebaseDatabase db = FirebaseDatabase.instance;
  late List<ProductEntity> state;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    state = widget.state;
    _recommendedProductsFuture = _fetchRecommendedProducts();
  }

  Future<List<Product>> _fetchRecommendedProducts() async {
    await Future.delayed(const Duration(seconds: 2));
    logger.d(state);

    return state
        .map((e) => Product(
            imageUrl:
                "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg",
            name: e.productName,
            price: e.productPrice))
        .toList();

    // return List.generate(
    //   5,
    //   (index) => Product(
    //     imageUrl: 'https://via.placeholder.com/150',
    //     name: 'Product ${index + 1}',
    //     price: (index + 1) * 10.0,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference _userUpdate = db.ref("products/product-id${widget.uid}/");
    // context.read();
    // var data = widget.sellerContext.widget.key;
    if (state.isNotEmpty) {
      return FutureBuilder<List<Product>>(
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
    } else {
      return const SizedBox(
        child:
            Center(child: Text("You don't have any products, please add one")),
      );
    }
  }

  Widget _buildProductGrid(List<Product> products) {
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
          return _buildProductCard(products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
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
    );
  }
}
