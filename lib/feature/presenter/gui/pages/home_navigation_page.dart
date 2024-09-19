import 'dart:async';
import 'dart:io';

import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class HomeNavigationPage extends StatefulWidget {
  final String? uid;
  const HomeNavigationPage(this.uid, {Key? key}) : super(key: key);

  @override
  State<HomeNavigationPage> createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage> {
  late TabsRouter tabsRouter;
  int _selectedIndex = 2;
  bool isBackButtonPressed = false;
  Timer? _backButtonTimer;

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: AutoTabsRouter(
        // initialIndex: 12,
        routes: [
          const WishListRoute(),
          const ChatsRoute(),
          const HomeRoute(),
          const NotificationRoute(),
          MyInformationRoute(uid: widget.uid),
        ],
        builder: (context, child) {
          tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Wishlist',
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
    );
  }
}
