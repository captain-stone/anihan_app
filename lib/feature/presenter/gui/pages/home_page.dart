// ignore_for_file: library_private_types_in_public_api

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/location_label.dart';
import '../widgets/new_stock_section.dart';
import '../widgets/product_sections.dart';
import '../widgets/trending_locations_section.dart';
import 'user_information_bloc/add_ons/all_products_add_ons_bloc/all_products_add_ons_bloc.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseDatabase db = FirebaseDatabase.instance;

  final logger = Logger();

  void _searchCrops(String value) {
    logger.d(value);
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference _allProductsRef = db.ref("products");

    return BlocProvider(
      create: (context) =>
          AllProductsAddOnsBloc(_allProductsRef)..add(GetAllProductEvents()),
      child: Scaffold(
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
              BlocBuilder<AllProductsAddOnsBloc, AllProductsAddOnsState>(
                builder: (context, state) {
                  if (state is AllProductSuccessState) {
                    // logger.d(state.productEntity);
                    var data = state.productEntity;
                    // var data = state.productEntity.productVariant;
                    // logger.d(data);
                    return ProductsSection(
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
                },
              ),
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
      ),
    );
  }
}
