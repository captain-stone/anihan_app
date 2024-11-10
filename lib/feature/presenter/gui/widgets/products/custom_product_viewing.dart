// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

@RoutePage()
class CustomProductViewingPage extends StatefulWidget {
  final ProductEntity product;
  final String uid;
  final double width;
  final double height;
  const CustomProductViewingPage(this.uid,
      {super.key, required this.product, this.height = 100, this.width = 100});

  @override
  State<CustomProductViewingPage> createState() =>
      _CustomProductViewingPageState();
}

class _CustomProductViewingPageState extends State<CustomProductViewingPage> {
  final logger = Logger();
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    logger.d(widget.product);
    // context
    //     .read<ProductFavoriteCubit>()
    //     .addToFavorite(widget.product.productKey);
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
    final double _heigh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_basket_outlined))
        ],
      ),
      body: Column(
        children: [
          //product image
          SizedBox(
            height: _heigh * 0.4,
            width: _width,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.product.productImage.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.product.productImage[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                  bottom: 10, // Position the dots at the bottom
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.product.productImage.length,
                        (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: _currentPage == index ? 12.0 : 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.green
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 5,
          ),
          widget.product.productVariant != null
              ? Container(
                  width: _width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  child: Text(
                      "${widget.product.productVariant!.length} Variant Images"))
              : Container(),

          widget.product.productVariant != null
              ? SizedBox(
                  width: _width,
                  height: _heigh * 0.07,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.product.productVariant!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          child: Image.network(
                            widget.product.productVariant![index]!.images!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Add to Cart',
          ),
          BottomNavigationBarItem(
              icon: Container(
                color: Colors.red,
              ),
              label: 'Buy',
              backgroundColor: Colors.red),
        ],
        // currentIndex: tabsRouter.activeIndex,
        selectedItemColor: const Color.fromRGBO(56, 142, 60, 1),
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,

        elevation: 8.0,
        unselectedLabelStyle:
            const TextStyle(color: Colors.black54, fontSize: 18),
        // onTap: (index) {
        //   setState(() {
        //     _selectedIndex = index;
        //   });
        //   tabsRouter.setActiveIndex(index);
        // },
      ),
    );
  }
}
