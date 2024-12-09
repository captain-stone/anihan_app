// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:anihan_app/feature/domain/entities/product_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'wish_list_page_event.dart';
part 'wish_list_page_state.dart';

@injectable
class WishListPageBloc extends Bloc<WishListPageEvent, WishListPageState> {
  late StreamSubscription? _subscription;
  final FirebaseDatabase db = FirebaseDatabase.instance;

  WishListPageBloc() : super(WishListPageInitial()) {
    on<GetWishListEvent>((event, emit) async {
      emit(const WishListPageLoadingState());

      FirebaseAuth auth = FirebaseAuth.instance;

      User? user = auth.currentUser;

      List<ProductEntity> productEntityList = [];

      List<String> keyList = [];
      final logger = Logger();

      try {
        DatabaseReference _wishListRef = db.ref('wishlist/${user!.uid}');
        DatabaseReference _productRefs = db.ref('products');

        //get the key.
        _subscription = _wishListRef.onValue.listen((event) async {
          final snapShot = event.snapshot;

          if (!snapShot.exists) {
            //emittt here
            if (!emit.isDone) {
              emit(const WishListPageErrorState(
                  "You don't have any wishlist, try adding one"));
              return;
            }
          }

          keyList = snapShot.children
              .where((child) => child.value == true)
              .map((child) => child.key!)
              .toList();

          final productsSnapshot = await _productRefs.get();

          if (!productsSnapshot.exists) {
            if (!emit.isDone) {
              emit(const WishListPageErrorState(
                  "You don't have any wishlist products, try adding one"));
              return;
            }
          }

          final List<ProductEntity> productEntityList = [];
          productsSnapshot.children.forEach((userNode) {
            userNode.children.forEach((productNode) {
              final productData = productNode.value as Map<dynamic, dynamic>;
              var productIdKey = productNode.key!;

              if (keyList.contains(productIdKey)) {
                if (productData['imageUrls'] != null &&
                    productData['name'] != null &&
                    productData['label'] != null &&
                    productData['price'] != null &&
                    productData['itemDescriptions'] != null) {
                  List<String> productImages =
                      List<String>.from(productData['imageUrls']);
                  String productName = productData['name'];
                  String productLabel = productData['label'];
                  double productPrice = productData['price'].toDouble();
                  int productQuantity = productData['productQuantity'] ?? 0;
                  String itemDescriptions = productData['itemDescriptions'];

                  String? storeIdKey;
                  productData.forEach((key, value) {
                    if (key.startsWith('storeId-') && value == true) {
                      storeIdKey = key;
                    }
                  });

                  //get the id on storeid
                  var getID = storeIdKey!.replaceAll("storeId-", "");
                  var productIdModified = storeIdKey!.replaceAll("-id", "");

                  List<ProductVariantEntity?>? productVariants;

                  // logger.d(productData[
                  //     'variant-${productId.replaceFirst("product-id", "")}-id']);
                  // logger.d('variant-$productId-id');
                  //logger.d(productData);

                  if (productData
                      .containsKey('variant-$productIdModified-id')) {
                    logger.d("IT's OKAY");
                    productVariants =
                        (productData['variant-$productIdModified-id'] as List)
                            .map((variant) => ProductVariantEntity(
                                images: variant['variantImages'],
                                varianName: variant['variantName'],
                                variantPrice: variant['variantPrice'],
                                variantQuantity: variant['variantQuantity']))
                            .toList();
                  }

                  productEntityList.add(ProductEntity(
                    productImages,
                    productName,
                    productLabel,
                    productPrice,
                    productQuantity,
                    itemDescriptions,
                    productVariant: productVariants,
                    productKey: productIdKey,
                    storeId: storeIdKey!,
                  ));
                }
              }

              // productEntityList
            });
          });

          if (productEntityList.isEmpty) {
            if (!emit.isDone) {
              emit(const WishListPageErrorState(
                  "You don't have any wishlist products, try adding one"));
              return;
            }
          }

          emit(WishListPageSuccessState(productEntityList));
        }, onDone: () {
          _subscription!.asFuture();
        }, onError: (error) {
          emit(WishListPageErrorState(
              "Error occured (Subscription Error): $error"));
        });
        await _subscription!.asFuture();
      } catch (e) {
        emit(WishListPageErrorState("Error occured (Error): $e"));
      }
    });
  }
}
