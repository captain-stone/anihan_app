// ignore_for_file: library_private_types_in_public_api, unused_element, no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/parameters/user_information_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/add_ons/product_favorite_bloc/product_favorite_cubit.dart';

import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/add_ons/your_products.dart';
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/add_ons/seller_add_ons/seller_info_add_ons_bloc.dart';
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
import 'add_ons/all_products_add_ons_bloc/all_products_add_ons_bloc.dart';
import 'add_ons/your_suggestions.dart';
import 'add_ons/products_add_ons_bloc/product_add_ons_bloc.dart';

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
  final _addProductBloc = getIt<ProductAddOnsBloc>();
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

    // context.updateUserInformation(widget.uid!);
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
    DatabaseReference _allProductsRef = db.ref("products");
    // logger.d(widget.uid);

    return MultiBlocProvider(
      providers: [
        // BlocProvider(create: (context) => <UserInformationBlocBloc>()..add(GetUidEvent(UserUidParams(widget.uid!)))),

        BlocProvider(
          create: (context) =>
              SellerInfoAddOnsBloc(_ref, _userUpdate)..add(SellerStreanEvent()),
        ),
        BlocProvider(
          create: (context) =>
              ProductAddOnsBloc(_productsRef)..add(GetSelfProductEvents()),
        ),
//no
        BlocProvider(
          create: (context) => AllProductsAddOnsBloc(_allProductsRef)
            ..add(GetAllProductEvents()),
        ),

        BlocProvider(create: (context) => ProductFavoriteCubit())
      ],
      child: BlocConsumer<UserInformationBlocBloc, UserInformationBlocState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is UserInformationSuccessState) {
            setState(() {
              name = state.userInformationEntity.displayName;
              isFarmers = state.userInformationEntity.remarks;
              phoneNumber = state.userInformationEntity.phoneNumber;
            });
          }
        },
        builder: (context, widgetState) {
          if (widgetState is UserInformationLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } // Show loading spinner

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
                      isFarmers = state.dataModel['isApproved'];
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
                Visibility(
                  visible: isFarmers == Approval.approved.name,
                  child: SectionTitle(
                    title: 'Your Products',
                    addProducts: () {
                      AutoRouter.of(context)
                          .push(AddProductFormRoute(uid: widget.uid));
                    },
                  ),
                ),
                Visibility(
                  visible: isFarmers == Approval.approved.name,
                  child: BlocBuilder<ProductAddOnsBloc, ProductAddOnsState>(
                      builder: (context, state) {
                    // logger.d(state);
                    if (state is ProductSuccessState) {
                      var data = state.productEntity;
                      logger.f(data);
                      return YourProduct(
                        widget.uid!,
                        context,
                        data,
                      );
                    } else {
                      return const SizedBox(
                        height: 100,
                        child: Center(
                          child:
                              Text('You don\'t have any products available.'),
                        ),
                      );
                    }
                  }),
                ),
                const SizedBox(
                  height: 12,
                ),
                const SectionTitle(
                  title: 'You May Like',
                ),
                BlocBuilder<AllProductsAddOnsBloc, AllProductsAddOnsState>(
                    builder: (context, state) {
                  // logger.f(state);
                  if (state is AllProductSuccessState) {
                    // logger.d(state.productEntity);
                    var data = state.productEntity;
                    // var data = state.productEntity.productVariant;
                    // logger.d(data);
                    return YouMayLikeWidget(
                      state: data,
                    );
                  } else {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text('No recommended products available.'),
                      ),
                    );
                  }
                })
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
