// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/presenter/gui/pages/wish_list_page/wishlist_bloc/wish_list_page_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../pages/wish_list_page/wish_list_page.dart';
import '../../../products/product_favorite_cubit/product_favorite_cubit.dart';

@RoutePage()
class MyLikePage extends StatefulWidget {
  final String uid;

  const MyLikePage({super.key, required this.uid});

  @override
  State<MyLikePage> createState() => _MyLikePageState();
}

class _MyLikePageState extends State<MyLikePage> {
  final _bloc = getIt<WishListPageBloc>();
  @override
  void initState() {
    super.initState();

    _bloc.add(GetWishListEvent());
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => ProductFavoriteCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Wishlist"),
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<WishListPageBloc, WishListPageState>(
            bloc: _bloc,
            builder: (context, state) {
              // logger.d(state);
              if (state is WishListPageSuccessState) {
                var productEntity = state.productEntityList;
                return WishlistSection(
                  label: "Products",
                  uid: widget.uid,
                  productEntityList: productEntity,
                  // productListEntity
                  size: Size(_width, _height),
                );
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: _width * 0.7,
                    child: const Center(
                      child: Text(
                        "You do not have any wishlist, try adding one.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
