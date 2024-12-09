// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';

import 'package:anihan_app/feature/presenter/gui/pages/add_ons_blocs/check_friends_bloc/check_friends_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/pages/map__page/map_page_cubit.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/addons/product_categories/product_category_items/product_category_items_cubit.dart';
import '../widgets/products/all_products_add_ons_bloc/all_products_add_ons_bloc.dart';
import '../widgets/products/product_favorite_cubit/product_favorite_cubit.dart';
import '../widgets/products/product_showcase_bloc/product_showcase_bloc.dart';
import '../widgets/products/products_add_ons_bloc/product_add_ons_bloc.dart';
import '../widgets/sellers/seller_add_ons/seller_info_add_ons_bloc.dart';
import 'chats_bloc/blocs/chat_page/chats_page_bloc.dart';
import 'notification_bloc/notification_page_bloc.dart';
import 'wish_list_page/friends_bloc/friends_list_page_bloc.dart';
import 'wish_list_page/wishlist_bloc/wish_list_page_bloc.dart';

@RoutePage()
class HomeNavigationPage extends StatefulWidget {
  final String? uid;
  const HomeNavigationPage(this.uid, {super.key});

  @override
  State<HomeNavigationPage> createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage> {
  late TabsRouter tabsRouter;
  int _selectedIndex = 2;
  bool isBackButtonPressed = false;
  Timer? _backButtonTimer;
  final FirebaseDatabase db = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabsRouter.setActiveIndex(_selectedIndex);
    });
  }

  @override
  void dispose() {
    _backButtonTimer?.cancel();

    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (isBackButtonPressed) {
      // If back button is pressed twice, exit the app
      if (Platform.isAndroid) {
        exit(0);
      } else {
        SystemNavigator.pop();
      }
      return true;
    }

    setState(() {
      isBackButtonPressed = true;
    });

    // Reset the back button flag after 2 seconds
    _backButtonTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        isBackButtonPressed = false;
      });
    });

    // Show a message to the user (e.g., using a SnackBar)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Press back again to exit'),
        duration: Duration(seconds: 2),
      ),
    );

    return false; // Prevent the app from exiting
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference _ref = db.ref("farmers/${widget.uid}/");
    DatabaseReference _userUpdate = db.ref("users/${widget.uid}/");
    DatabaseReference _productsRef = db.ref("products/product-id${widget.uid}");
    DatabaseReference _allProductsRef = db.ref("products");

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
//no
        BlocProvider(
          create: (context) => AllProductsAddOnsBloc(_allProductsRef)
            ..add(GetAllProductEvents()),
        ),

        BlocProvider(create: (context) => ProductFavoriteCubit()),

        BlocProvider(create: (context) => ProductShowcaseBloc()),
        BlocProvider(
          create: (context) => ChatsPageBloc(),
        ),

        // BlocProvider(
        //   create: (context) => NotificationPageBloc()
        //     ..add(GetFarmersNotificationsEvent(uid: widget.uid)),
        // ),

        BlocProvider(
          create: (context) => ProductCategoryItemsCubit(_allProductsRef),
        ),

        BlocProvider(
          create: (context) => CheckFriendsBloc(),
        ),

        BlocProvider(create: (context) => WishListPageBloc()),
        BlocProvider(create: (context) => FriendsListPageBloc()),
      ],
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: AutoTabsRouter(
          // initialIndex: 12,
          routes: [
            WishListRoute(uid: widget.uid),
            ChatsRoute(uid: widget.uid),
            HomeRoute(uid: widget.uid),
            NotificationRoute(uid: widget.uid),
            MyInformationRoute(uid: widget.uid),
          ],
          builder: (context, child) {
            tabsRouter = AutoTabsRouter.of(context);
            return Scaffold(
              body: child,
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.handshake),
                    label: 'Community',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    label: 'Messages',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Notifications',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Account',
                  ),
                ],
                currentIndex: tabsRouter.activeIndex,
                selectedItemColor: Colors.green.shade700,
                unselectedItemColor: Colors.black54,
                backgroundColor: Colors.white,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                elevation: 8.0,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                  tabsRouter.setActiveIndex(index);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
