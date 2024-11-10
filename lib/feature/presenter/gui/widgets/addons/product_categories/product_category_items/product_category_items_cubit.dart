import 'dart:async';

import 'package:anihan_app/feature/presenter/gui/widgets/products/products_add_ons_bloc/product_add_ons_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

import '../../../../../../domain/entities/product_entity.dart';

part 'product_category_items_state.dart';

class ProductCategoryItemsCubit extends Cubit<ProductCategoryItemsState> {
  final DatabaseReference _refs;
  StreamSubscription? _subscriptionProducts;
  final logger = Logger();
  ProductCategoryItemsCubit(this._refs) : super(ProductCategoryItemsInitial());
  @override
  Future<void> close() {
    // Cancel the stream when the Cubit is closed
    _subscriptionProducts?.cancel();
    return super.close();
  }

  Future<void> getProductBaseOnCategory(String category) async {
    List<String> imageUrls = [];
    emit(ProductCategoryItemsLoadingState());
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    List<ProductEntity> productList = [];

    try {
      _subscriptionProducts = _refs.onValue.listen((event) {
        if (event.snapshot.value == null) {
          emit(const ProductCategoryItemsErrorState("No data saved"));
          _subscriptionProducts?.isPaused;
        } else {
          var dataObject = (event.snapshot.value as Map<dynamic, dynamic>?);

          if (dataObject != null) {
            List<ProductEntity> productList = [];

            dataObject.forEach((productId, productDetails) {
              productDetails.forEach((key, productInfo) {
                if (productInfo['label'] == category) {
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
                    String itemDescriptions = productInfo['itemDescriptions'];
                    String storeId = "storeId-${user!.uid}-id";

                    List<ProductVariantEntity?>? productVariants;
                    if (productInfo['variant-$productId-id'] != null) {
                      productVariants =
                          (productInfo['variant-$productId-id'] as List)
                              .map((variant) => ProductVariantEntity(
                                  images: variant['variantImages'],
                                  varianName: variant['variantName'],
                                  variantPrice: variant['variantPrice']))
                              .toList();
                    }

                    productList.add(ProductEntity(productImages, productName,
                        productLabel, productPrice, itemDescriptions,
                        productVariant: productVariants,
                        productKey: key,
                        storeId: storeId));
                  }
                }
              });
            });

            emit(ProductCategoryItemsSuccessState(productList));
            _subscriptionProducts?.isPaused;
          } else {
            emit(const ProductCategoryItemsErrorState(
              "No data saved",
            ));

            _subscriptionProducts?.isPaused;
          }
        }
      }, onDone: () {
        _subscriptionProducts!.asFuture();
        emit(ProductCategoryItemsLoadedState());
      }, onError: (error) {
        logger.e(error);
        emit(ProductCategoryItemsErrorState("Error Occured: $error"));
      });
      await _subscriptionProducts!.asFuture();
    } catch (e) {
      logger.e(e.toString());
      emit(ProductCategoryItemsErrorState("Error Occured: $e"));
    }
  }
}
