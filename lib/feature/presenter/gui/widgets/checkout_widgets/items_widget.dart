// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/feature/domain/entities/add_to_cart_entity.dart';
import 'package:flutter/material.dart';

class ItemsWidget extends StatelessWidget {
  final List<AddToCartEntity> productEntity;
  const ItemsWidget({super.key, required this.productEntity});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: List.generate(productEntity.length, (index) {
              return Column(
                children: List.generate(
                  productEntity[index].productEntity.length,
                  (innerIndex) {
                    return _buildItemRow(
                      context,
                      productEntity[index].productEntity[innerIndex].name,
                      productEntity[index].productEntity[innerIndex].price,
                      productEntity[index].productEntity[innerIndex].quantity,
                    );
                  },
                ),
              );
            }),
          ),
        ));
  }

  Widget _buildItemRow(
      BuildContext context, String name, double price, int quantity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/banana.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 60,
                height: 60,
                color: Colors.grey.shade300,
                child: Icon(Icons.broken_image, color: Colors.grey.shade700),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Details Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Text(
                //   weight,
                //   style: Theme.of(context)
                //       .textTheme
                //       .bodyMedium
                //       ?.copyWith(color: Colors.black54),
                // ),
              ],
            ),
          ),
          // Price and Quantity Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price.toString(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                quantity.toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
