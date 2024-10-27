// ignore_for_file: library_private_types_in_public_api

import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/add_ons/products_add_ons_bloc/product_add_ons_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/debugger/logger_debugger.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../animation_theme.dart';
import 'product_category.dart';
import 'product_category_items/product_category_items_cubit.dart';

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
  final FirebaseDatabase db = FirebaseDatabase.instance;

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
    DatabaseReference _allProductsRef = db.ref("products");

    return BlocProvider(
      create: (context) => ProductCategoryItemsCubit(_allProductsRef),
      child: BlocConsumer<ProductCategoryItemsCubit, ProductCategoryItemsState>(
        listener: (context, state) {
          // TODO: implement listener
          // logger.d(state);

          if (state is ProductCategoryItemsSuccessState) {
            logger.d(state.productEntity);
            AutoRouter.of(context).push(ShowProductByCategoryRoute(
                label: widget.category.name, productData: state.productEntity));
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              context
                  .read<ProductCategoryItemsCubit>()
                  .getProductBaseOnCategory(widget.category.name);
            },
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
            },
            onTapCancel: () {
              setState(() {
                _isPressed = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(
                  8.0), // Added padding around the container
              child: AnimatedScale(
                scale: scale,
                duration: animationTheme.duration,
                child: Container(
                  width: 160.0, // Width for better display
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16.0), // More rounded corners
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
                          top: Radius.circular(
                              16.0), // Top rounded corners for image
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
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
        },
      ),
    );
  }
}
