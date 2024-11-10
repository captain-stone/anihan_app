// ignore_for_file: unused_element

import 'package:flutter/material.dart';

class StoreInfoSection extends StatelessWidget {
  final String storeName;
  final String storeLocations;
  final String? storeAvatarUrl;
  final double? rating;
  final int? reviewCount;

  const StoreInfoSection({
    super.key,
    required this.storeName,
    required this.storeLocations,
    this.storeAvatarUrl,
    this.rating,
    this.reviewCount,
  });

  String _formatReviewCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Seller Info Section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Seller Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(storeAvatarUrl ?? ""),
                  ),
                  const SizedBox(width: 16.0),
                  // Seller Information (Name & Location)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storeName,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        storeLocations,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Separator Line
        Divider(
          color: Colors.grey.shade300,
          thickness: 1.0,
          height: 1.0,
        ),
      ],
    );
  }
}
