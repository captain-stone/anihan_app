// ignore_for_file: library_private_types_in_public_api, unused_element, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/parameters/params.dart';
import 'package:anihan_app/feature/domain/parameters/user_information_params.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/customer_order.dart';
import 'package:anihan_app/feature/presenter/gui/pages/order_details/order_details_widget.dart';
import 'package:anihan_app/feature/presenter/gui/pages/order_details/order_page.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/add_to_cart/add_to_cart_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/product_favorite_cubit/product_favorite_cubit.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/product_showcase_bloc/product_showcase_bloc.dart';

import 'package:anihan_app/feature/presenter/gui/widgets/products/your_products.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/sellers/seller_add_ons/seller_info_add_ons_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/user_information_bloc_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/services/permission_handles_sevices.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/addons/informations_widgets/activities_widget.dart';
import '../../widgets/addons/informations_widgets/header_widget.dart';
import '../../widgets/addons/informations_widgets/orders_widget.dart';
import '../../widgets/addons/informations_widgets/sections_titles.dart';
import '../../widgets/products/all_products_add_ons_bloc/all_products_add_ons_bloc.dart';
import '../../widgets/products/your_suggestions.dart';
import '../../widgets/products/products_add_ons_bloc/product_add_ons_bloc.dart';

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
  final _cartBloc = getIt<AddToCartBloc>();
  final _addProductBloc = getIt<ProductAddOnsBloc>();
  final logger = Logger();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  onOrders(
    String label,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          double _w = MediaQuery.of(context).size.width;
          double _h = MediaQuery.of(context).size.height;
          return Container(
              width: _w,
              height: label == 'Shipments' ? _h * 0.3 : _h * 0.5,
              padding: const EdgeInsets.all(18),
              child: label == "Payments"
                  ? Column(
                      children: [
                        Text("$label (cash)"),
                        // ...accessRolesLabel
                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                            height: 100,
                            width: _w,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green.shade50,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("User's Name"),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text("approved"))
                              ],
                            ))
                      ],
                    )
                  : label == "Shipments"
                      ? Column(
                          children: [
                            Text("$label And Delivery"),
                            // ...accessRolesLabel
                            const SizedBox(
                              height: 18,
                            ),
                            Container(
                                height: 100,
                                width: _w,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.green.shade50,
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(),
                                    CircleAvatar(),
                                    CircleAvatar()
                                  ],
                                ))
                          ],
                        )
                      : Container());
        });
  }

  Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User signed out successfully.");
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _bloc.add(LogoutEvent(NoParams()));
      }
    } catch (e) {
      logger.e("Error signing out: $e");
    }
  }

  _permission() {
    checkPermision(Permission.locationWhenInUse).then((value) async {
      if (Platform.isAndroid) {
        Location location = Location();
        bool isLocationEnabled = await location.serviceEnabled();

        if (!isLocationEnabled) {
          const intent = AndroidIntent(
              action: 'android.settings.LOCATION_SOURCE_SETTINGS');
          await intent.launch();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // logger.d(widget.uid);
    final _width = MediaQuery.of(context).size.width;

    return BlocConsumer<UserInformationBlocBloc, UserInformationBlocState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is UserInformationSuccessState) {
          setState(() {
            name = state.userInformationEntity.displayName;
            isFarmers = state.userInformationEntity.remarks;
            phoneNumber = state.userInformationEntity.phoneNumber;
          });
        }

        if (state is LogoutSuccessState) {
          AutoRouter.of(context).replace(const LoginRoute());
        }
      },
      builder: (context, widgetState) {
        if (widgetState is UserInformationLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } // Show loading spinner

        return Scaffold(
          key: _scaffoldKey,
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
                      BlocBuilder<AddToCartBloc, AddToCartState>(
                        bloc: _cartBloc,
                        builder: (context, state) {
                          return IconButton(
                            icon: const Icon(Icons.shopping_cart,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const OrdersPage()));
                            },
                          );
                        },
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
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
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
                    _permission();
                    AutoRouter.of(context).push(SellerRegistrationRoute(
                      uid: widget.uid!,
                      fullName: name,
                      phoneNumber: phoneNumber,
                    ));
                  });
                },
              ),
              BlocBuilder<SellerInfoAddOnsBloc, SellerInfoAddOnsState>(
                  builder: (context, state) {
                String isApproved = Approval.notApproved.name;

                if (state is SellerInfoAddOnsSuccessState) {
                  isApproved = state.dataModel['isApproved'];
                  isFarmers = state.dataModel['isApproved'];
                  if (state.dataModel['farmers'] != null) {
                    isFarmers = state.dataModel['farmers'];
                  }

                  if (isApproved == Approval.approved.name) {
                    if (!accessRolesLabel.contains('seller')) {
                      // accessRolesLabel.add('seller');
                      // accessRoles.add(widgetData);
                      return CustomerOrder(
                        onPressedPayments: () {
                          print("Paymentsssss");
                          onOrders("Payments");
                        },
                        onPressedShipments: () {
                          print("Shipments");

                          onOrders("Shipments");
                        },
                        onGoing: () {},
                        onDone: () {},
                      );
                    }
                  } else {
                    if (accessRolesLabel.contains('seller')) {
                      accessRolesLabel.remove('seller');
                      accessRoles.remove(widgetData);
                    }
                  }
                }
                return Container();
              }),
              const MyOrdersWidget(),
              ActivitiesWidget(
                uid: widget.uid!,
              ),
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
                    // logger.f(data);
                    return YourProduct(
                      widget.uid!,
                      state: data,
                      sellerContext: context,
                    );
                  } else {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text('You don\'t have any products available.'),
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
                  builder: (context, allProductState) {
                // logger.f(state);
                if (allProductState is AllProductSuccessState) {
                  // logger.d(state.productEntity);
                  var data = allProductState.productEntity;

                  // logger.d(data);
                  return YouMayLikeWidget(
                    sellerContext: context,
                    widget.uid!,
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
          endDrawer: Drawer(
            width: _width * 0.45,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: signOutUser,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
