// ignore_for_file: library_private_types_in_public_api, prefer_final_fields

import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/data/models/api/store_user_services_api.dart';
import 'package:anihan_app/feature/domain/parameters/product_add_cart_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/myinformation_farmer.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/informations_widgets/page/list_product.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/add_to_cart/add_to_cart_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/product_carousel.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/your_suggestions.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../domain/entities/product_entity.dart';
import '../../pages/add_ons_blocs/check_friends_bloc/check_friends_bloc.dart';
import '../../pages/order_details/order_page.dart';
import '../../routers/app_routers.dart';

import 'product_custom_app_bar.dart';
import '../sellers/seller_info_sections.dart';
import 'product_favorite_cubit/product_favorite_cubit.dart';

class ProductSectionPage extends StatefulWidget {
  final String uid;
  final ProductEntity productEntity;
  final BuildContext checkUserContext;
  final List<ProductEntity>? productList;

  const ProductSectionPage(
      {super.key,
      required this.productEntity,
      required this.checkUserContext,
      required this.uid,
      this.productList});
  @override
  _ProductSectionPageState createState() => _ProductSectionPageState();
}

class _ProductSectionPageState extends State<ProductSectionPage> {
  int _selectedIndex = 2;
  List<Map<String, dynamic>> cart = [];
  List<String> variantImage = [];
  final logger = Logger();
  List<String> allImageUrl = [];
  late final BuildContext _context;
  late final CheckFriendsBloc checkFriendsBloc;
  final _addToCartBloc = getIt<AddToCartBloc>();
  List<ProductEntity> _productEntityList = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      _context = widget.checkUserContext;
      checkFriendsBloc = _context.read<CheckFriendsBloc>();
      if (widget.productList != null) {
        _productEntityList = widget.productList!;
      }

      allImageUrl = [...widget.productEntity.productImage];

      if (widget.productEntity.productVariant != null) {
        for (var image in widget.productEntity.productVariant!) {
          if (image != null && image.images != null) {
            allImageUrl.add(image.images!);
          }
        }
      }
    });

    _context.read<CheckFriendsBloc>().add(GetFriendListCountEvent());
    _context
        .read<CheckFriendsBloc>()
        .add(GetUserNameAndStoreNameEvent(widget.productEntity.storeId));

    List<ProductVariantEntity?>? productVariant =
        widget.productEntity.productVariant;
    if (productVariant != null) {
      for (var image in productVariant) {
        if (image != null) {
          String? imageUrl = image.images;
          if (imageUrl != null) {
            variantImage.add(imageUrl);
          }
        }
      }
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setState) {
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.7,
                maxChildSize: 0.9,
                minChildSize: 0.5,
                builder: (_, controller) {
                  return _buildBottomSheetContent(setState);
                },
              );
            }));
  }

  Widget _buildBottomSheetContent(StateSetter setState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left side - Product Grid
            Expanded(
              flex: 3, // Give more space to the left side
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    // height: 340,
                    fit: FlexFit.loose, // Use Flexible instead of Expanded
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allImageUrl.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child:
                              _buildProductCard(setState, allImageUrl, index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (cart.isNotEmpty) {
                            var listOfParams = cart
                                .map((val) => ProductAddCartParams(
                                    name: val['name'] as String,
                                    quantity: val['quantity'],
                                    price: val['price'],
                                    image: val['image']))
                                .toList();

                            logger.d(widget.productEntity.storeId);

                            _addToCartBloc.add(AddProductListToCart(
                                widget.productEntity.storeId, listOfParams));
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => CustomAlertDialog(
                                    colorMessage: Colors.red,
                                    title: "Error",
                                    onPressedCloseBtn: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                        "The cart is empty please add your product to proceed")));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                        child: const Text("Add to Cart",
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Buy now action

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OrdersPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                        child: const Text("Buy Now",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Right side - Order Details
            Expanded(
              flex: 2, // Make the right side wider
              child: _buildOrderDetails(setState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      StateSetter setState, List<String> images, int index) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () => _removeProduct(setState, images, index),
              icon: const Icon(Icons.remove)),
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.25, // Constrained width (full screen width)
                height: 100, // Fixed height for the image
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 8, right: 8),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12.0)),
                    child: Image.network(
                      allImageUrl[index],
                      fit: BoxFit.cover, // Make sure the image covers the area
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  index + 1 > widget.productEntity.productImage.length
                      ? widget
                          .productEntity
                          .productVariant![
                              index - widget.productEntity.productImage.length]!
                          .varianName!
                      : widget.productEntity.productName,
                  style: const TextStyle(
                      fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
          IconButton(
              onPressed: () => _addProduct(setState, images, index),
              icon: const Icon(Icons.add)),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(StateSetter setState) {
    double total = cart.fold(
        0,
        (sum, item) =>
            sum + (item['price'] as double) * (item['quantity'] as int));

    return Container(
      // width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Order/s",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${cart[index]['name']} x${cart[index]['quantity']}'),
                    trailing: Text(
                        '₱${cart[index]['price'] * cart[index]['quantity']}'),
                    onTap: () {
                      setState(() {
                        cart.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TOTAL',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                Text('₱$total',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _searchCrops(String value) {
    logger.d(value);
  }

  void _showFriendRequestList(BuildContext context) {
    var state = context.read<CheckFriendsBloc>().state;
    logger.d(state);
    if (state is CheckFriendsSuccessState) {
      var data = state.data;
      var buildContext = context.read<CheckFriendsBloc>();

      AutoRouter.of(context).push(FriendRequestRoute(
          data: data, checkFriendBuildContext: buildContext));
    }
    if (state is CheckFriendsErrorState) {
      logger.d("NO DATA");
    }
  }

  _addProduct(StateSetter setState, List<String> image, int index) {
    setState(() {
      logger.d(cart);
      // int existingIndex = cart.indexWhere((item) {
      //   logger.d(item['name']);
      //   return item['name'] == widget.productEntity.productName;
      // });

      int existingIndex = cart.indexWhere((item) {
        String productName;

        if (index + 1 > widget.productEntity.productImage.length) {
          productName = widget
              .productEntity
              .productVariant![
                  index - widget.productEntity.productImage.length]!
              .varianName!;
        } else {
          productName = widget.productEntity.productName;
        }

        logger.d('Cart item name: ${item['name']}');
        logger.d('Product name to compare: $productName');

        // Compare the item name with the selected product name
        return item['name'] == productName;
      });

      logger.d(existingIndex);

      if (existingIndex >= 0) {
        cart[existingIndex]['quantity']++;
      } else {
        if (index + 1 > widget.productEntity.productImage.length) {
          widget
              .productEntity
              .productVariant![
                  index - widget.productEntity.productImage.length]!
              .varianName!;
          cart.add({
            'name': widget
                .productEntity
                .productVariant![
                    index - widget.productEntity.productImage.length]!
                .varianName,
            'image': widget
                .productEntity
                .productVariant![
                    index - widget.productEntity.productImage.length]!
                .imageData,
            'price': double.tryParse(widget
                .productEntity
                .productVariant![
                    index - widget.productEntity.productImage.length]!
                .variantPrice
                .toString()),
            'quantity': 1
          });
        } else {
          cart.add({
            'name': widget.productEntity.productName,
            'image': widget.productEntity.productImage[index],
            'price':
                double.tryParse(widget.productEntity.productPrice.toString()),
            'quantity': 1
          });
        }
      }
    });
  }

  _removeProduct(StateSetter setState, List<String> image, int index) {
    setState(() {
      int existingIndex = cart.indexWhere((item) {
        String productName;

        if (index + 1 > widget.productEntity.productImage.length) {
          productName = widget
              .productEntity
              .productVariant![
                  index - widget.productEntity.productImage.length]!
              .varianName!;
        } else {
          productName = widget.productEntity.productName;
        }

        return item['name'] == productName;
      });

      if (existingIndex >= 0) {
        if (cart[existingIndex]['quantity'] > 1) {
          cart[existingIndex]['quantity']--;
        } else {
          cart.removeAt(existingIndex);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddToCartBloc, AddToCartState>(
      bloc: _addToCartBloc,
      listener: (context, state) {
        // logger.d(state);
        if (state is AddToCartLoadingState) {
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevent dismissing the dialog by tapping outside
            builder: (context) => const AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Adding to cart...'), // Optional: Display a message
                ],
              ),
            ),
          );
        }

        if (state is AddToCartSuccessState) {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                  colorMessage: Colors.green,
                  title: "Success",
                  actionOkayVisibility: true,
                  actionLabel: "Checkout",
                  onPressOkay: () {
                    Navigator.pop(context);
                    Navigator.pop(context);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OrdersPage()));
                  },
                  onPressedCloseBtn: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                      "You have added a product to your cart with a total price of ${state.dataModel.totalPrice}. Would you like to proceed to checkout?")));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: ProductCustomAppBar(
              blocBuilder: BlocBuilder<CheckFriendsBloc, CheckFriendsState>(
                bloc: checkFriendsBloc,
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
              addContext: _context,
              onPressedIconUser: () => _showFriendRequestList(_context),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Carousel
                    ProductCarousel(
                      imageUrls: widget.productEntity.productImage,
                      productName: widget.productEntity.productLabel,
                      price: widget.productEntity.productPrice,
                      productsSold: 3100, // Example value
                      productVariantEntity:
                          widget.productEntity.productVariant ?? [],
                    ),
                    const SizedBox(height: 16.0),

                    // Seller Info Section with Divider
                    BlocBuilder<CheckFriendsBloc, CheckFriendsState>(
                      bloc: checkFriendsBloc,
                      builder: (context, state) {
                        Map<String, String> dataMap = {};
                        if (state is GetUserAndStoreNameSuccessState) {
                          dataMap = state.name;
                        }
                        return SellerInfoSection(
                          sellerName: dataMap["userName"] ?? "None",
                          sellerLocation: dataMap["storeLocation"] ?? "None",
                          sellerAvatarUrl: '',
                          rating: 4.8,
                          reviewCount: 1400,
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Product Ratings Section with "View All" Button
                    ProductRatingsSection(
                      rating: 4.8,
                      reviewCount: 1400,
                    ),
                    const SizedBox(height: 16.0),

                    LatestReviewsSection(reviews: []),
                    const SizedBox(height: 16.0),

                    // Recommendations Section
                    // YouMayLikeWidget(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0),
                      child: Text(
                        'Recommended for You',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    BlocProvider(
                      create: (context) => ProductFavoriteCubit(),
                      child: YouMayLikeWidget(widget.uid,
                          state: _productEntityList,
                          sellerContext: widget.checkUserContext),
                    ),
                    // ListProduct(uid: widget.uid, product: cpm, dist: dist, parentContext: parentContext)
                    const SizedBox(height: 80), // Adding space for sticky bar
                  ],
                ),
              ),

              // Sticky Bottom Bar (Now Touching Bottom Navigation Bar)
              Positioned(
                bottom: 0, // Sticky bar touching the bottom navigation bar
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -1), // Shadow above the bar
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Shop Icon Button
                        IconButton(
                          onPressed: () {
                            // Handle Shop icon button action
                          },
                          icon: const Icon(Icons.store),
                          color: Colors.green.shade700,
                          iconSize: 30.0,
                        ),
                        // Chat Seller Button
                        ElevatedButton.icon(
                          onPressed: () {
                            // logger.d(variantImage);
                            StoreUserServicesApi s = StoreUserServicesApi();

                            s.getStoreIdInfo(
                                'storeId-um2CJNQK4EeVy4xFck5kciIEZHA3-id');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text("Chat Seller"),
                        ),

                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            "Add to Cart",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),

                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showBottomSheet(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28.0, vertical: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            "Buy Now",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProductRatingsSection extends StatelessWidget {
  final double rating;
  final int reviewCount;

  ProductRatingsSection({
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Rating Star Icon
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 24.0,
              ),
              SizedBox(width: 4),

              // Display Product Rating
              Text(
                '$rating',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
              ),

              SizedBox(width: 8),

              // Review Count
              Text(
                'Product Ratings (${_formatReviewCount(reviewCount)})',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
            ],
          ),
          // "View All" Button aligned to the right
          TextButton(
            onPressed: () {
              // Navigate to full reviews page
            },
            child: Text(
              'View All',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class LatestReviewsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;

  LatestReviewsSection({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Reviews',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
          ),
          SizedBox(height: 10),
          reviews.isNotEmpty
              ? Column(
                  children: List.generate(
                    reviews.length > 3 ? 3 : reviews.length,
                    (index) {
                      var review = reviews[index];
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: review['avatarUrl'] != null
                                    ? NetworkImage(review['avatarUrl'])
                                    : null,
                                child: review['avatarUrl'] == null
                                    ? Icon(Icons.person, size: 20)
                                    : null,
                              ),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < review['rating']
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      }),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      review['text'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (review['images'] != null &&
                                        review['images'].length > 0)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: _buildImageRow(
                                            context, review['images']),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey.shade300,
                            height: 16.0,
                            thickness: 1.0,
                          ),
                        ],
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text("No Reviews"),
                )
        ],
      ),
    );
  }

  Widget _buildImageRow(BuildContext context, List<String> images) {
    int imageCount = images.length;

    return Row(
      children: List.generate(
        imageCount > 3 ? 3 : imageCount,
        (index) {
          if (index == 2 && imageCount > 3) {
            return _buildMoreImagesIndicator(context, images, imageCount);
          } else {
            return _buildReviewImage(context, images, index);
          }
        },
      ),
    );
  }

  Widget _buildReviewImage(
      BuildContext context, List<String> images, int index) {
    return GestureDetector(
      onTap: () {
        _showImageFullScreen(context, images, index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        width: 80,
        height: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            images[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMoreImagesIndicator(
      BuildContext context, List<String> images, int totalImages) {
    return GestureDetector(
      onTap: () {
        _showImageFullScreen(context, images, 2);
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            width: 80,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                images[2],
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.6),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                '+${totalImages - 3}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageFullScreen(
      BuildContext context, List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImageCarousel(
          images: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class FullScreenImageCarousel extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  FullScreenImageCarousel({required this.images, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              initialPage: initialIndex,
            ),
            itemCount: images.length,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) {
              return Center(
                child: Image.network(
                  images[itemIndex],
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationsSection extends StatelessWidget {
  final List<Map<String, dynamic>> recommendations;

  const RecommendationsSection({super.key, required this.recommendations});

  String _formatSoldCount(int sold) {
    if (sold >= 1000) {
      return '${(sold / 1000).toStringAsFixed(1)}k';
    }
    return '$sold';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommended for You',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
          ),
          const SizedBox(height: 10),

          // GridView for 2-column layout
          GridView.builder(
            physics:
                const NeverScrollableScrollPhysics(), // Prevent inner scroll, use the main scroll
            shrinkWrap: true, // Allows GridView inside a Column
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 12.0, // Spacing between columns
              mainAxisSpacing: 12.0, // Spacing between rows
              childAspectRatio: 0.75, // Adjust the height of the card
            ),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final product = recommendations[index];
              return GestureDetector(
                onTap: () {
                  // Handle product card tap
                },
                child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12.0),
                        ),
                        child: Image.network(
                          product['imageUrl'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            Text(
                              product['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),

                            // Row for Rating (Numerical + Stars) and Sold Items
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Rating (Numerical + Stars)
                                Row(
                                  children: [
                                    Text(
                                      product['rating'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Row(
                                      children: List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < product['rating']
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      }),
                                    ),
                                  ],
                                ),

                                // Number of items sold (formatted)
                                Text(
                                  '${_formatSoldCount(product['sold'])} sold',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
