// ignore_for_file: library_private_types_in_public_api

import 'package:anihan_app/feature/presenter/gui/pages/Journal/journal_page.dart';
import 'package:anihan_app/feature/presenter/gui/pages/chats_bloc/chats_page_bloc.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/location_label.dart';
import '../widgets/addons/product_categories/new_stock_section.dart';
import '../widgets/product_sections.dart';
import '../widgets/trending_locations_section.dart';
import '../widgets/products/all_products_add_ons_bloc/all_products_add_ons_bloc.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  final String? uid;
  const HomePage({this.uid, super.key});

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
  void initState() {
    super.initState();

    context
        .read<ChatsPageBloc>()
        .add(GetPendingRequestEvent(currentUserId: widget.uid!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(
          onChangeSearchCrops: _searchCrops,
          onPressedIconUser: () {},
          onPressedIconJournal: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return JournalPage();
            }));
          },
        ),
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
                  var data = state.productEntity;

                  return ProductsSection(
                    label: "Recommended Products",
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
    );
  }
}
