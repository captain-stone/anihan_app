import 'package:anihan_app/feature/presenter/gui/pages/add_ons_blocs/check_friends_bloc/check_friends_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCustomAppBar extends StatelessWidget {
  final VoidCallback onPressedIconUser;
  final BuildContext addContext;
  final BlocBuilder blocBuilder;

  const ProductCustomAppBar(
      {super.key,
      required this.onPressedIconUser,
      required this.addContext,
      required this.blocBuilder});

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
                    onPressed: onPressedIconUser,
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: blocBuilder,
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
