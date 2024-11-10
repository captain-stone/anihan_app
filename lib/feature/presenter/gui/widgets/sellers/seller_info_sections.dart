// ignore_for_file: unused_element

import 'package:flutter/material.dart';

class SellerInfoSection extends StatelessWidget {
  final String sellerName;
  final String sellerLocation;
  final String sellerAvatarUrl;
  final double rating;
  final int reviewCount;

  const SellerInfoSection({
    super.key,
    required this.sellerName,
    required this.sellerLocation,
    required this.sellerAvatarUrl,
    required this.rating,
    required this.reviewCount,
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
                    backgroundImage: NetworkImage(sellerAvatarUrl),
                  ),
                  SizedBox(width: 16.0),
                  // Seller Information (Name & Location)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sellerName,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        sellerLocation,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
              // "View Shop" Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.green.shade700,
                ),
                onPressed: () {
                  // Handle "View Shop" button tap
                },
                child: Text(
                  'View Shop',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.white),
                ),
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
