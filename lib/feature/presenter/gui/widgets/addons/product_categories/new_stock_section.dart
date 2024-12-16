import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'product_category.dart';
import 'product_category_items.dart';

class NewStockSection extends StatelessWidget {
  final String uid;
  final logger = Logger();
  final List<ProductCategory> categories = [
    ProductCategory('Seeds', 'assets/seeds.jpg'),
    ProductCategory('Fruits', 'assets/fruits.jpg'),
    ProductCategory('Vegetables', 'assets/vegetables.jpg'),
    ProductCategory('Fertilizers', 'assets/fertilizers.jpg'),
    ProductCategory('Farming Tools', 'assets/tools.jpg'),
    ProductCategory('Saplings', 'assets/sapling.jpg'),
  ];

  NewStockSection({required this.uid, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Product Categories',
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: 20.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        SizedBox(
          height: 200.0, // Adjusted height to fit categories content
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return ProductCategoryItem(uid: uid, category: categories[index]);
              // return Container();
            },
          ),
        ),
      ],
    );
  }
}
