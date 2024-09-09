import 'package:anihan_app/feature/presenter/gui/widgets/product_items.dart';
import 'package:flutter/material.dart';

import 'products.dart';

class ProductsSection extends StatelessWidget {
  final List<Product> products = List.generate(
    10,
    (index) => Product(
      'Product $index',
      'assets/logo.png', // Placeholder image path
      '\$${(10 + index * 2).toStringAsFixed(2)}',
      4.5, // Placeholder rating
      index * 10 + 5, // Placeholder items sold
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended Products',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          SizedBox(height: 16.0),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.7, // Adjust for item height
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductItem(product: products[index]);
            },
          ),
        ],
      ),
    );
  }
}
