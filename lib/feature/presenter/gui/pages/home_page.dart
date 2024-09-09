import 'dart:ui';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/location_label.dart';
import '../widgets/new_stock_section.dart';
import '../widgets/product_sections.dart';
import '../widgets/trending_locations_section.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2; // Default selected index is "Home"

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print("Selected index: $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrendingLocationsSection(),
            SizedBox(height: 8.0),
            LocationsLabel(),
            SizedBox(height: 16.0),
            NewStockSection(),
            SizedBox(height: 16.0),
            ProductsSection(),
          ],
        ),
      ),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
        onTap: _onItemTapped,
      ),
    );
  }
}
