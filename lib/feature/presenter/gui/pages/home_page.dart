// ignore_for_file: library_private_types_in_public_api

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/location_label.dart';
import '../widgets/new_stock_section.dart';
import '../widgets/product_sections.dart';
import '../widgets/trending_locations_section.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logger = Logger();

  void _searchCrops(String value) {
    logger.d(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(onChangeSearchCrops: _searchCrops),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrendingLocationsSection(),
            const SizedBox(height: 8.0),
            const LocationsLabel(),
            const SizedBox(height: 16.0),
            NewStockSection(),
            const SizedBox(height: 16.0),
            ProductsSection(),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite),
      //       label: 'Wishlist',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.message),
      //       label: 'Messages',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: 'Notifications',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Account',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.green.shade700,
      //   unselectedItemColor: Colors.black54,
      //   backgroundColor: Colors.white,
      //   showSelectedLabels: true,
      //   showUnselectedLabels: false,
      //   type: BottomNavigationBarType.fixed,
      //   elevation: 8.0,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
