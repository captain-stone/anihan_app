// ignore_for_file: unused_field

import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/product_showcase_bloc/product_showcase_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/your_product_carousel.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/stores/store_info_sections.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/app_module.dart';
import '../../../pages/add_ons_blocs/check_friends_bloc/check_friends_bloc.dart';
import '../../../routers/app_routers.dart';
import '../../sellers/seller_info_sections.dart';
import '../product_carousel.dart';
import '../product_custom_app_bar.dart';
import '../product_favorite_cubit/product_favorite_cubit.dart';
import '../product_view_page.dart';

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

  final _checkFriendBloc = getIt<CheckFriendsBloc>();

  final logger = Logger();
  @override
  void initState() {
    super.initState();
    logger.d(widget.products);

    storeInfo = {};

    _checkFriendBloc.add(GetFriendListCountEvent());

    _checkFriendBloc.add(GetUserNameAndStoreNameEvent(widget.products.storeId));

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

  void _showFriendRequestList(BuildContext context) {
    var state = _checkFriendBloc.state;
    logger.d(state);
    if (state is CheckFriendsSuccessState) {
      var data = state.data;
      // var buildContext = context.read<_checkFriendBloc>();

      AutoRouter.of(context).push(FriendRequestRoute(
          data: data, checkFriendBuildContext: _checkFriendBloc));
    }
    if (state is CheckFriendsErrorState) {
      logger.d("NO DATA");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: ProductCustomAppBar(
            blocBuilder: BlocBuilder<CheckFriendsBloc, CheckFriendsState>(
              bloc: _checkFriendBloc,
              builder: (addContext, state) {
                if (state is CheckFriendsSuccessState) {
                  int stateDataCount = state.data.length;
                  // friendsRequestData = state.data;
                  return Text(
                    '$stateDataCount', // Notification count
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  );
                }
                return const Text(
                  '0', // Notification count
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                );
              },
            ),
            addContext: context,
            onPressedIconUser: () => _showFriendRequestList(context),
          ),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Carousel
                    YourProductCarousel(
                      productId: widget.products.productKey,
                      imageUrls: widget.products.productImage,
                      productLabel: widget.products.productLabel,
                      productName: widget.products.productName,
                      price: widget.products.productPrice,
                      productsSold: 0, // Example value
                      productQuantity: widget.products.productQuantity,
                      productVariantEntity:
                          widget.products.productVariant ?? [],
                    ),
                    const SizedBox(height: 16.0),

                    // Seller Info Section with Divider

                    const SizedBox(height: 16.0),

                    // Product Ratings Section with "View All" Button
                    // ProductRatingsSection(
                    //   rating: 4.8,
                    //   reviewCount: 1400,
                    // ),
                    // const SizedBox(height: 16.0),

                    // LatestReviewsSection(reviews: []),
                    // const SizedBox(height: 16.0),

                    // Recommendations Section
                    // // YouMayLikeWidget(),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 16.0, horizontal: 16.0),
                    //   child: Text(
                    //     'Recommended for You',
                    //     style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 18.0,
                    //         ),
                    //   ),
                    // ),
                    // const SizedBox(height: 10),

                    // BlocProvider(
                    //   create: (context) => ProductFavoriteCubit(),
                    //   child: YouMayLikeWidget(widget.uid,
                    //       state: _productEntityList,
                    //       sellerContext: widget.checkUserContext),
                    // ),
                    // ListProduct(uid: widget.uid, product: cpm, dist: dist, parentContext: parentContext)
                    const SizedBox(height: 80), // Adding space for sticky bar
                  ],
                ),
              ),
              Positioned(
                bottom: 2,
                left: 0,
                right: 0,
                child: BlocBuilder<CheckFriendsBloc, CheckFriendsState>(
                  bloc: _checkFriendBloc,
                  builder: (context, state) {
                    Map<String, String> dataMap = {};
                    if (state is GetUserAndStoreNameSuccessState) {
                      dataMap = state.name;
                    }
                    return SellerInfoSection(
                      sellerName: dataMap["userName"] ?? "None",
                      sellerLocation: dataMap["storeLocation"] ?? "None",
                      sellerAvatarUrl:
                          'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
                      rating: 4.8,
                      reviewCount: 1400,
                    );
                  },
                ),
              ),
            ],
          ),
        )
        // body: Column(
        //   children: [
        //     Stack(
        //       children: [
        //         SizedBox(
        //           width: _width,
        //           height: _height * 0.4,
        //           child: PageView.builder(
        //             controller: _pageController,
        //             itemCount: widget.products.productImage.length,
        //             itemBuilder: (context, index) {
        //               return Image.network(
        //                 widget.products.productImage[index],
        //                 fit: BoxFit.cover,
        //               );
        //             },
        //           ),
        //         ),
        //         Positioned(
        //           bottom: 10, // Position the dots at the bottom
        //           left: 0,
        //           right: 0,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: List.generate(widget.products.productImage.length,
        //                 (index) {
        //               return Container(
        //                 margin: const EdgeInsets.symmetric(horizontal: 4.0),
        //                 width: _currentPage == index ? 12.0 : 8.0,
        //                 height: 8.0,
        //                 decoration: BoxDecoration(
        //                   color:
        //                       _currentPage == index ? Colors.green : Colors.grey,
        //                   borderRadius: BorderRadius.circular(4.0),
        //                 ),
        //               );
        //             }),
        //           ),
        //         ),
        //       ],
        //     ),
        //     // StoreInfoSection(
        //     //   storeName: storeInfo['storeName'],
        //     //   storeLocations: storeInfo['storeLocations'],
        //     //   storeAvatarUrl: storeInfo['storeAvatarUrl'],
        //     // )
        //   ],
        // ),
        );
  }
}
