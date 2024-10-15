// ignore_for_file: library_private_types_in_public_api, unused_element, no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/parameters/user_information_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/add_ons/your_products.dart';
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/seller_add_ons/seller_info_add_ons_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/user_information_bloc_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../widgets/addons/informations_widgets/activities_widget.dart';
import '../../widgets/addons/informations_widgets/header_widget.dart';
import '../../widgets/addons/informations_widgets/orders_widget.dart';
import '../../widgets/addons/informations_widgets/sections_titles.dart';
import 'products_add_ons/product_add_ons_bloc.dart';

@RoutePage()
class MyInformationPage extends StatefulWidget {
  final String? uid;
  const MyInformationPage(this.uid, {super.key});

  @override
  _MyInformationPageState createState() => _MyInformationPageState();
}

class _MyInformationPageState extends State<MyInformationPage> {
  final FirebaseDatabase db = FirebaseDatabase.instance;

  final _bloc = getIt<UserInformationBlocBloc>();
  final logger = Logger();
  final ScrollController _scrollController = ScrollController();

  List<String> accessRolesLabel = ['user'];
  List<Widget> accessRoles = [
    Padding(
      // padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(horizontal: 2.0),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'User',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    ),
  ];

  Widget widgetData = Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.lightGreen,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Text(
        'Seller',
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    ),
  );

  String name = "";
  int phoneNumber = 0;

  int cartData = 0;
  String isFarmers = Approval.pendingApproval.name;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    _bloc.add(GetUidEvent(UserUidParams(widget.uid!)));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Implement loading more items when scrolled to the bottom
    }
  }

  Widget _buildSellButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        backgroundColor: Colors.white.withOpacity(0.2),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.white),
        ),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sell, color: Colors.white),
          SizedBox(height: 8.0), // Space between icon and text
          Text('Sell Your Own'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference _ref = db.ref("farmers/${widget.uid}/");
    DatabaseReference _userUpdate = db.ref("users/${widget.uid}/");
    DatabaseReference _productsRef = db.ref("products/product-id${widget.uid}");

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SellerInfoAddOnsBloc(_ref, _userUpdate)..add(SellerStreanEvent()),
        ),
        BlocProvider(
          create: (context) =>
              ProductAddOnsBloc(_productsRef)..add(GetSelfProductEvents()),
        ),
      ],
      child: BlocConsumer<UserInformationBlocBloc, UserInformationBlocState>(
        bloc: _bloc,
        listener: (context, state) {
          logger.d(state);

          if (state is UserInformationSuccessState) {
            setState(() {
              name = state.userInformationEntity.displayName;
              isFarmers = state.userInformationEntity.remarks;
              phoneNumber = state.userInformationEntity.phoneNumber;
            });

            // if (isFarmers == Approval.approved.name) {
            //   accessRoles.add(
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 2.0),
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 8.0, vertical: 4.0),
            //         decoration: BoxDecoration(
            //           color: Colors.lightGreen,
            //           borderRadius: BorderRadius.circular(8.0),
            //         ),
            //         child: const Text(
            //           'Seller',
            //           style: TextStyle(
            //               color: Colors.black,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 12),
            //         ),
            //       ),
            //     ),
            //   );
            // }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                'My Information',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              actions: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {},
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: CircleAvatar(
                            radius: 10.0,
                            backgroundColor: Colors.red,
                            child: Text(
                              cartData.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                )
              ],
            ),
            body: ListView(
              controller: _scrollController,
              children: [
                BlocBuilder<SellerInfoAddOnsBloc, SellerInfoAddOnsState>(
                  builder: (context, state) {
                    String isApproved = Approval.notApproved.name;

                    // logger.d(state);
                    if (state is SellerInfoAddOnsSuccessState) {
                      isApproved = state.dataModel['isApproved'];
                      if (state.dataModel['farmers'] != null) {
                        isFarmers = state.dataModel['farmers'];
                      }

                      if (isApproved == Approval.approved.name) {
                        if (!accessRolesLabel.contains('seller')) {
                          accessRolesLabel.add('seller');
                          accessRoles.add(widgetData);
                        }
                      } else {
                        if (accessRolesLabel.contains('seller')) {
                          accessRolesLabel.remove('seller');
                          accessRoles.remove(widgetData);
                        }
                      }
                    }
                    return HeaderWidget(name,
                        isApproved: isApproved,
                        accessRoles: accessRoles, onPressSell: () {
                      AutoRouter.of(context).push(SellerRegistrationRoute(
                        uid: widget.uid!,
                        fullName: name,
                        phoneNumber: phoneNumber,
                      ));
                    });
                  },
                ),
                const MyOrdersWidget(),
                const ActivitiesWidget(),
                // Visibility(
                //   visible: isFarmers == Approval.approved.name,
                //   child: SectionTitle(
                //     title: 'Your Products',
                //     addProducts: () {
                //       AutoRouter.of(context).push(const AddProductFormRoute());
                //     },
                //   ),
                // ),
                // Visibility(
                //     visible: isFarmers == Approval.approved.name,
                //     child: YourProduct(widget.uid!)),

                SectionTitle(
                  title: 'Your Products',
                  addProducts: () {
                    AutoRouter.of(context).push(const AddProductFormRoute());
                  },
                ),
                BlocBuilder<ProductAddOnsBloc, ProductAddOnsState>(
                    builder: (context, state) {
                  // logger.d(state);
                  if (state is ProductSuccessState) {
                    // logger.d(state.productEntity);
                    var data = state.productEntity;
                    // var data = state.productEntity.productVariant;
                    logger.d(data);
                    return YourProduct(
                      widget.uid!,
                      context,
                      data,
                    );
                  } else {
                    return Container();
                  }
                }),
                const SizedBox(
                  height: 12,
                ),
                const SectionTitle(
                  title: 'You May Like',
                ),

                const YouMayLikeWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Product {
  final String imageUrl;
  final String name;
  final double price;

  Product({required this.imageUrl, required this.name, required this.price});
}

class YouMayLikeWidget extends StatefulWidget {
  const YouMayLikeWidget({super.key});

  @override
  _YouMayLikeWidgetState createState() => _YouMayLikeWidgetState();
}

class _YouMayLikeWidgetState extends State<YouMayLikeWidget> {
  late Future<List<Product>> _recommendedProductsFuture;

  @override
  void initState() {
    super.initState();
    _recommendedProductsFuture = _fetchRecommendedProducts();
  }

  Future<List<Product>> _fetchRecommendedProducts() async {
    await Future.delayed(const Duration(seconds: 2));

    return List.generate(
      10,
      (index) => Product(
        imageUrl:
            'https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg',
        name: 'Product ${index + 1}',
        price: (index + 1) * 10.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _recommendedProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Failed to load products. Please try again.'),
          );
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildProductGrid(snapshot.data!);
        } else {
          return const Center(
            child: Text('No recommended products available.'),
          );
        }
      },
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return _buildProductCard(products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.network(
              product.imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
