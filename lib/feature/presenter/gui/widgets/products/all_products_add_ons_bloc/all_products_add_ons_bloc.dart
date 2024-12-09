import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

import 'package:logger/logger.dart';

import '../../../../../domain/entities/product_entity.dart';

part 'all_products_add_ons_event.dart';
part 'all_products_add_ons_state.dart';

// @injectable
class AllProductsAddOnsBloc
    extends Bloc<AllProductsAddOnsEvent, AllProductsAddOnsState> {
  final DatabaseReference _refs;
  late StreamSubscription? _subscriptionProducts;
  final logger = Logger();

  AllProductsAddOnsBloc(this._refs) : super(AllProductsAddOnsInitial()) {
    on<GetAllProductEvents>(
      (event, emit) async {
        List<String> imageUrls = [];
        emit(AllProductsAddOnsLoadingState());
        FirebaseAuth auth = FirebaseAuth.instance;

        User? user = auth.currentUser;
        List<ProductEntity> productList = [];

        try {
          await Future.delayed(const Duration(milliseconds: 500));
          _subscriptionProducts = _refs.onValue.listen((event) {
            if (event.snapshot.value == null) {
              if (!emit.isDone) {
                emit(const AllProductErrorState("No data saved"));
                // _subscriptionProducts?.isPaused;
              }
            } else {
              var dataObject = (event.snapshot.value as Map<dynamic, dynamic>?);
              // logger.d(dataObject);
              if (dataObject != null) {
                List<ProductEntity> productList = [];

                dataObject.forEach((productId, productDetails) {
                  var productIdModified =
                      productId.replaceFirst("product-id", "");
                  productDetails.forEach((key, productInfo) {
                    String productIdKey = key;

                    if (productInfo['imageUrls'] != null &&
                        productInfo['name'] != null &&
                        productInfo['label'] != null &&
                        productInfo['price'] != null &&
                        productInfo['itemDescriptions'] != null) {
                      List<String> productImages =
                          List<String>.from(productInfo['imageUrls']);
                      String productName = productInfo['name'];
                      String productLabel = productInfo['label'];
                      double productPrice = productInfo['price'].toDouble();
                      int productQuantity = productInfo['productQuantity'] ?? 0;
                      String itemDescriptions = productInfo['itemDescriptions'];
                      String storeId = "storeId-$productIdModified-id";

                      List<ProductVariantEntity?>? productVariants;

                      // logger.d(productInfo[
                      //     'variant-${productId.replaceFirst("product-id", "")}-id']);
                      // logger.d('variant-$productId-id');
                      //logger.d(productInfo);

                      if (productInfo
                          .containsKey('variant-$productIdModified-id')) {
                        // logger.d("IT's OKAY");
                        productVariants =
                            (productInfo['variant-$productIdModified-id']
                                    as List)
                                .map((variant) => ProductVariantEntity(
                                    images: variant['variantImages'],
                                    varianName: variant['variantName'],
                                    variantPrice: variant['variantPrice'],
                                    variantQuantity:
                                        variant['variantQuantity']))
                                .toList();
                      }

                      productList.add(ProductEntity(
                        productImages,
                        productName,
                        productLabel,
                        productPrice,
                        productQuantity,
                        itemDescriptions,
                        productVariant: productVariants,
                        productKey: productIdKey,
                        storeId: storeId,
                      ));
                    }
                  });
                });

                emit(AllProductSuccessState(productList));
                // _subscriptionProducts?.isPaused;
              } else {
                if (!emit.isDone) {
                  emit(const AllProductErrorState(
                    "No data saved",
                  ));
                }
                // _subscriptionProducts?.isPaused;
              }
            }
          }, onDone: () {
            _subscriptionProducts!.asFuture();
          }, onError: (error) {
            logger.e(error);
            emit(AllProductErrorState("Error Occured: $error"));
          });
          await _subscriptionProducts!.asFuture();
        } catch (e) {
          logger.e(e.toString());
          emit(AllProductErrorState("Error Occured: $e"));
        }
      },
    );
  }
}
