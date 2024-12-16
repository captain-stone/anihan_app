// ignore_for_file: library_private_types_in_public_api, unused_element, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/parameters/params.dart';
import 'package:anihan_app/feature/domain/parameters/user_information_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/checkout_info/checkout_inf_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/cubit/add_update_user_address_cubit.dart';
import 'package:anihan_app/feature/presenter/gui/pages/user_information_bloc/payments_widget/on_pressed_payments.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/customer_order.dart';

import 'package:anihan_app/feature/presenter/gui/pages/order_details/order_page.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/checkout_widgets/modal/add_update_address.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/add_to_cart/add_to_cart_bloc.dart';

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

import '../../../../data/models/dto/checkout_product_dto.dart';
import '../../widgets/addons/informations_widgets/activities_widget.dart';
import '../../widgets/addons/informations_widgets/header_widget.dart';
import '../../widgets/addons/informations_widgets/orders_widget.dart';
import '../../widgets/addons/informations_widgets/sections_titles.dart';
import '../../widgets/products/all_products_add_ons_bloc/all_products_add_ons_bloc.dart';
import '../../widgets/products/your_suggestions.dart';
import '../../widgets/products/products_add_ons_bloc/product_add_ons_bloc.dart';
import 'helper/order_widget_helper.dart';
import 'payments_widget/on_pressed_buyers,.dart';

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
  final _addUpdateCubit = getIt<AddUpdateUserAddressCubit>();
  final _cartBloc = getIt<AddToCartBloc>();
  final _checkoutBloc = getIt<CheckoutInfBloc>();
  final _addProductBloc = getIt<ProductAddOnsBloc>();
  final logger = Logger();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController addressController = TextEditingController();
  List<String> _listOfAddress = [];
  String _selectedAddress = "";

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
    _addUpdateCubit.getAllTheSavedAddress(widget.uid!);
    _checkoutBloc.add(const GetAllCheckoutProductEvent());
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

  _onSectedValue(String? value, StateSetter setState) {
    // logger.d(value);
    setState(() {
      _selectedAddress = value ?? "None";
    });

    _addUpdateCubit.updateSelectedAddress(widget.uid!, _selectedAddress);
  }

  _onPressedPayments() {}

  Widget _buildOrderWidget(
    Map<String, dynamic> data,
    String key,
    Widget Function(OrderWidgetArgs args) widgetBuilder,
    BuildContext context,
    String name,
  ) {
    int countDataPayment = 0;
    int countDataShipMents = 0;
    int countDataPaymentBuyer = 0;
    int countDataShipMentsBuyer = 0;
    int countDataDone = 0;
    List<CheckoutProductDto> dtoDataList = [];
    List<CheckoutProductDto> dtoDataListShipMents = [];
    List<CheckoutProductDto> dtoListBuyer = [];
    List<CheckoutProductDto> dtoDataListBuyer = [];

    List<CheckoutProductDto> dtoListOnDone = [];
    List<CheckoutProductDto> dtoDataListOnDone = [];

    List<CheckoutProductDto> dtoData = data[key];
    List<String> options = ['Find drivers', 'On Delivery', 'Done'];
    String? selectOption;
    logger.d(dtoData.runtimeType);
    if (key == "seller") {
      if (dtoData.isNotEmpty) {
        for (var dto in dtoData) {
          if (dto.forApproval == Approval.pendingApproval.name) {
            dtoDataList.add(dto);
            countDataPayment++;
          }

          if (dto.forApproval == Approval.approved.name ||
              dto.forApproval == Approval.delivery.name ||
              dto.forApproval == Approval.driver.name ||
              dto.forApproval == Approval.done.name) {
            dtoDataListShipMents.add(dto);
            countDataShipMents++;

            if (dto.forApproval == Approval.done.name) {
              dtoListOnDone.add(dto);
              countDataDone++;
            }
          }
        }
        return widgetBuilder(
          OrderWidgetArgs(
            dataPaymentCount: countDataPayment,
            dataShipMentCount: countDataShipMents,
            dataDoneCount: countDataDone,
            onPressedPayments: () {
              onOrderPayments(
                selectOption: selectOption,
                options: options,
                context: context,
                data: dtoDataList,
                label: "Payments",
                name: name,
                onChangeMenuButton: (id, val) {
                  setState(() {
                    selectOption = val;
                  });
                },
                onPressedApproved: (id) {
                  logger.d("NEED APPROVAL $id");
                  _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                      id: id, approval: Approval.approved.name));

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
              );
            },
            onPressedShipments: () {
              onOrderPayments(
                context: context,
                selectOption: selectOption,
                options: options,
                data: dtoDataListShipMents,
                label: "Shipments",
                name: name,
                onChangeMenuButton: (id, val) {
                  logger.d(val);

                  if (val == options[0]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.driver.name));
                  }

                  if (val == options[1]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.delivery.name));
                  }

                  if (val == options[2]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.done.name));
                  }

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
                onPressedApproved: (id) {
                  logger.d("NEED APPROVAL $id");
                  _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                      id: id, approval: Approval.approved.name));

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
              );
            },
            onGoing: () {},
            onDone: () {
              onOrderPayments(
                selectOption: selectOption,
                options: options,
                context: context,
                data: dtoListOnDone,
                label: "Done",
                name: name,
                onChangeMenuButton: (id, val) {
                  setState(() {
                    selectOption = val;
                  });
                },
                onPressedApproved: (id) {
                  logger.d("NEED APPROVAL $id");
                  _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                      id: id, approval: Approval.approved.name));

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
              );
            },
          ),
        );
      } else {
        return widgetBuilder(
          OrderWidgetArgs(
            dataPaymentCount: countDataPayment,
            dataShipMentCount: countDataShipMents,
            dataDoneCount: countDataDone,
            onPressedPayments: () {
              onOrderPayments(
                context: context,
                selectOption: selectOption,
                options: options,
                data: dtoDataList,
                label: "Payments",
                name: name,
                onChangeMenuButton: (id, val) {
                  setState(() {
                    selectOption = val;
                  });
                },
                onPressedApproved: (id) {
                  logger.d("HELLO $id");
                },
              );
            },
            onPressedShipments: () {
              onOrderPayments(
                context: context,
                selectOption: selectOption,
                options: options,
                data: dtoDataListShipMents,
                label: "Shipments",
                name: name,
                onChangeMenuButton: (id, val) {
                  logger.d(val);

                  if (val == options[0]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.driver.name));
                  }

                  if (val == options[1]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.delivery.name));
                  }

                  if (val == options[2]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.done.name));
                  }

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
                onPressedApproved: (id) {
                  logger.d("NEED APPROVAL $id");
                  _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                      id: id, approval: Approval.approved.name));

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
              );
            },
            onGoing: () {},
            onDone: () {
              onOrderPayments(
                selectOption: selectOption,
                options: options,
                context: context,
                data: dtoListOnDone,
                label: "Done",
                name: name,
                onChangeMenuButton: (id, val) {
                  setState(() {
                    selectOption = val;
                  });
                },
                onPressedApproved: (id) {
                  logger.d("NEED APPROVAL $id");
                  _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                      id: id, approval: Approval.approved.name));

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
              );
            },
          ),
        );
      }
    }

    //BUYYYYYYYYYYYYYYERRRRRR
    else {
      if (dtoData.isNotEmpty) {
        for (var dto in dtoData) {
          logger.d(dto.buyerName);

          if (dto.forApproval == Approval.pendingApproval.name) {
            dtoListBuyer.add(dto);
            countDataPaymentBuyer++;
          }

          if (dto.forApproval == Approval.approved.name ||
              dto.forApproval == Approval.delivery.name ||
              dto.forApproval == Approval.driver.name ||
              dto.forApproval == Approval.done.name) {
            dtoDataListBuyer.add(dto);
            countDataShipMentsBuyer++;

            if (dto.forApproval == Approval.done.name) {
              dtoListOnDone.add(dto);
              countDataDone++;
            }
          }
        }
        return widgetBuilder(
          OrderWidgetArgs(
            dataPaymentCount: countDataPaymentBuyer,
            dataShipMentCount: countDataShipMentsBuyer,
            dataDoneCount: countDataDone,
            onPressedPayments: () {
              onOrderBuyer(
                context: context,
                selectOption: selectOption,
                options: options,
                data: dtoListBuyer,
                label: "To Pay",
                name: name,
                onChangeMenuButton: (id, val) {
                  setState(() {
                    selectOption = val;
                  });
                  logger.d(selectOption);
                },
                onPressedApproved: (id) {
                  logger.d("HELLO To pya");
                },
              );
            },
            onPressedShipments: () {
              onOrderBuyer(
                context: context,
                selectOption: selectOption,
                options: options,
                data: dtoDataListBuyer,
                label: "To Ship",
                name: name,
                onChangeMenuButton: (id, val) {
                  logger.d(val);

                  if (val == options[0]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.driver.name));
                  }

                  if (val == options[1]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.delivery.name));
                  }

                  if (val == options[2]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.done.name));
                  }

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
                onPressedApproved: (id) {
                  logger.d("NEED APPROVAL $id");
                  _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                      id: id, approval: Approval.approved.name));

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
              );
            },
            onGoing: () {},
            onDone: () {
              onOrderBuyer(
                selectOption: selectOption,
                options: options,
                context: context,
                data: dtoListOnDone,
                label: "Done",
                name: name,
                onChangeMenuButton: (id, val) {
                  setState(() {
                    selectOption = val;
                  });
                },
                onPressedApproved: (id) {
                  logger.d("NEED APPROVAL $id");
                  _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                      id: id, approval: Approval.approved.name));

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
              );
            },
          ),
        );
      } else {
        return widgetBuilder(
          OrderWidgetArgs(
            dataPaymentCount: countDataPayment,
            dataShipMentCount: countDataShipMentsBuyer,
            dataDoneCount: countDataDone,
            onPressedPayments: () {
              onOrderBuyer(
                context: context,
                selectOption: selectOption,
                options: options,
                data: dtoListBuyer,
                label: "To Pay",
                name: name,
                onChangeMenuButton: (id, val) {
                  setState(() {
                    selectOption = val;
                  });
                },
                onPressedApproved: (id) {
                  logger.d("HELLO To pya");
                },
              );
            },
            onPressedShipments: () {
              onOrderBuyer(
                context: context,
                selectOption: selectOption,
                options: options,
                data: dtoDataListBuyer,
                label: "To Ship",
                name: name,
                onChangeMenuButton: (id, val) {
                  logger.d(val);

                  if (val == options[0]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.driver.name));
                  }

                  if (val == options[1]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.delivery.name));
                  }

                  if (val == options[2]) {
                    _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                        id: id, approval: Approval.done.name));
                  }

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
                onPressedApproved: (id) {
                  logger.d("NEED APPROVAL $id");
                  _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                      id: id, approval: Approval.approved.name));

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
              );
            },
            onGoing: () {},
            onDone: () {
              onOrderBuyer(
                selectOption: selectOption,
                options: options,
                context: context,
                data: dtoListOnDone,
                label: "Done",
                name: name,
                onChangeMenuButton: (id, val) {
                  setState(() {
                    selectOption = val;
                  });
                },
                onPressedApproved: (id) {
                  logger.d("NEED APPROVAL $id");
                  _checkoutBloc.add(UpdatedApprovedCheckoutEvent(
                      id: id, approval: Approval.approved.name));

                  _checkoutBloc.add(const GetAllCheckoutProductEvent());
                },
              );
            },
          ),
        );
      }
    }
    // return Container();
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
                                  builder: (context) => OrdersPage(
                                        uid: widget.uid!,
                                      )));
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
                      // _bloc.add(GetUidEvent(UserUidParams(widget.uid!)));
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
              BlocBuilder<CheckoutInfBloc, CheckoutInfState>(
                bloc: _checkoutBloc,
                builder: (context, state) {
                  logger.d(state);
                  if (state is ApprovalSuccessState) {
                    _checkoutBloc.add(const GetAllCheckoutProductEvent());
                  }
                  if (state is ApprovalErrorState) {
                    _checkoutBloc.add(const GetAllCheckoutProductEvent());
                  }

                  if (state is CheckoutInfSuccessState) {
                    return Column(
                      children: [
                        _buildOrderWidget(
                          state.data,
                          "seller",
                          (args) => CustomerOrder(
                            dataPaymentCount: args.dataPaymentCount,
                            dataShipMentCount: args.dataShipMentCount,
                            dataDoneCount: args.dataDoneCount,
                            onPressedPayments: args.onPressedPayments,
                            onPressedShipments: args.onPressedShipments,
                            onGoing: args.onGoing,
                            onDone: args.onDone,
                          ),
                          context,
                          name,
                        ),
                        _buildOrderWidget(
                          state.data,
                          "buyer",
                          (args) => MyOrdersWidget(
                            dataPaymentCount: args.dataPaymentCount,
                            dataShipmentCount: args.dataShipMentCount,
                            dataDoneCount: args.dataDoneCount,
                            onPressedPayments: args.onPressedPayments,
                            onPressedShipments: args.onPressedShipments,
                            onGoing: args.onGoing,
                            onDone: args.onDone,
                          ),
                          context,
                          name,
                        ),
                      ],
                    );
                  }
                  return Container(); // Fallback when no data is available
                },
              ),
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
                if (allProductState is AllProductSuccessState) {
                  var data = allProductState.productEntity;
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
          endDrawer:
              BlocBuilder<AddUpdateUserAddressCubit, AddUpdateUserAddressState>(
            bloc: _addUpdateCubit,
            builder: (context, state) {
              // logger.d(state);

              if (state is AddUpdateUserAddressSuccessState) {
                _listOfAddress = state.data['saveAddress'];
                _selectedAddress = state.data['address'];
              }

              if (state is AllSaveAddressSuccessState) {
                // logger.d(state);
                _listOfAddress = state.data;
              }
              return Drawer(
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
                      leading: const Icon(Icons.location_city),
                      title: const Text(
                        'Set Up Address',
                        style: TextStyle(fontSize: 10),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) =>
                                StatefulBuilder(builder: (context, setState) {
                                  return AddUpdateAddress(
                                    controller: addressController,
                                    listOfAddress: _listOfAddress,
                                    selectedAddress: _selectedAddress,
                                    onPressedAddAddress: () {
                                      if (addressController.text.isNotEmpty) {
                                        // logger.d(addressController.text);

                                        // Update state
                                        setState(() {
                                          _listOfAddress
                                              .add(addressController.text);
                                          if (_selectedAddress.isEmpty) {
                                            _selectedAddress =
                                                addressController.text;
                                          }
                                        });

                                        // Prepare parameters and call Cubit method
                                        var params = UserAddressParams(
                                            widget.uid!,
                                            addressController.text);
                                        _addUpdateCubit.addUpdateAddress(
                                            params.uid,
                                            params.address,
                                            _selectedAddress);

                                        // Clear the input field
                                        addressController.clear();
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CustomAlertDialog(
                                                    colorMessage: Colors.red,
                                                    title:
                                                        "Saving Address Error",
                                                    onPressedCloseBtn: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                        "Please fill up the address to proceed")));
                                      }
                                    },
                                    onSelectedValue: (value) {
                                      _onSectedValue(value, setState);
                                    },
                                  );
                                }));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 10),
                      ),
                      onTap: signOutUser,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
