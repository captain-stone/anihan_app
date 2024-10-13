// ignore_for_file: library_private_types_in_public_api

import 'package:anihan_app/feature/presenter/gui/widgets/debugger/logger_debugger.dart';
import 'package:flutter/material.dart';

import 'animation_theme.dart';
import 'product_category.dart';

class ProductCategoryItem extends StatefulWidget {
  final ProductCategory category;

  const ProductCategoryItem({super.key, required this.category});

  @override
  _ProductCategoryItemState createState() => _ProductCategoryItemState();
}

class _ProductCategoryItemState extends State<ProductCategoryItem>
    with SingleTickerProviderStateMixin, LoggerEvent {
  bool _isPressed = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AnimationTheme animationTheme =
        Theme.of(context).extension<AnimationTheme>()!;
    final scale = _isPressed ? animationTheme.pressScale : 1.0;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        // Placeholder for future functionality when category is clicked
        debug('Category ${widget.category.name} clicked');
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Padding(
        padding:
            const EdgeInsets.all(8.0), // Added padding around the container
        child: AnimatedScale(
          scale: scale,
          duration: animationTheme.duration,
          child: Container(
            width: 160.0, // Width for better display
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0), // More rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4), // Shadow effect
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0), // Top rounded corners for image
                  ),
                  child: Image.asset(
                    widget.category.imagePath,
                    fit: BoxFit.cover,
                    height: 120.0, // Fixed height for the image
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    widget.category.name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
