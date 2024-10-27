import 'package:anihan_app/feature/presenter/gui/widgets/product_items.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/product_entity.dart';
import 'products.dart';

class ProductsSection extends StatelessWidget {
  final String? label;
  final List<ProductEntity> state;
  const ProductsSection({super.key, this.label, required this.state});

  // final List<Product> products = List.generate(
  //   10,
  //   (index) => Product(
  //     'Product $index',
  //     'assets/logo.png', // Placeholder image path
  //     '\$${(10 + index * 2).toStringAsFixed(2)}',
  //     4.5, // Placeholder rating
  //     index * 10 + 5, // Placeholder items sold
  //   ),
  // );

  List<Product> _fetchRecommendedProducts() {
    return state
        .map((e) => Product(
            imagePath: e.productImage.first,
            name: e.productName,
            price: e.productPrice))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label != null
              ? Text(
                  label!,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                )
              : Container(),
          const SizedBox(height: 16.0),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.7, // Adjust for item height
            ),
            itemCount: _fetchRecommendedProducts().length,
            itemBuilder: (context, index) {
              return ProductItem(product: _fetchRecommendedProducts()[index]);
            },
          ),
        ],
      ),
    );
  }
}
