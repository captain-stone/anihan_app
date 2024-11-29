// ignore_for_file: unused_field

import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/product_showcase_bloc/product_showcase_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/stores/store_info_sections.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YourProductShowcase extends StatefulWidget {
  final ProductEntity products;

  const YourProductShowcase({super.key, required this.products});

  @override
  State<YourProductShowcase> createState() => _YourProductShowcaseState();
}

class _YourProductShowcaseState extends State<YourProductShowcase> {
  late PageController _pageController;
  int _currentPage = 0;
  late Map<String, dynamic> storeInfo;

  final logger = Logger();
  @override
  void initState() {
    super.initState();
    logger.d(widget.products);
    storeInfo = {};

    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ProductShowcaseBloc>().add(GetStoreInformations(
        storeId: widget.products
            .storeId)); // Replace 'YourEvent' with the actual event you want to dispatch
    // });

    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: _width,
                height: _height * 0.4,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.products.productImage.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.products.productImage[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 10, // Position the dots at the bottom
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.products.productImage.length,
                      (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: _currentPage == index ? 12.0 : 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color:
                            _currentPage == index ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          // StoreInfoSection(
          //   storeName: storeInfo['storeName'],
          //   storeLocations: storeInfo['storeLocations'],
          //   storeAvatarUrl: storeInfo['storeAvatarUrl'],
          // )
        ],
      ),
    );
  }
}
