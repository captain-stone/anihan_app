import 'package:flutter/material.dart';

class ProductCustomAppBar extends StatelessWidget {
  const ProductCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: Container(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 10),
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.people),
                    onPressed: () {
                      // Placeholder for future community function
                    },
                  ),
                  const Positioned(
                    right: 4,
                    top: 4,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '3', // Notification count
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Placeholder for future cart function
                },
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      elevation: 0,
    );
  }
}
