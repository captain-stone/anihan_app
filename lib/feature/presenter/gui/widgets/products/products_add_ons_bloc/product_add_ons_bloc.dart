import 'dart:async';

import 'package:anihan_app/feature/presenter/controllers/throll_debouncer_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../../domain/entities/product_entity.dart';

part 'product_add_ons_event.dart';
part 'product_add_ons_state.dart';

@injectable
class ProductAddOnsBloc extends Bloc<ProductAddOnsEvent, ProductAddOnsState>
    with ThrollService {
  final DatabaseReference _refs;
  late StreamSubscription? _subscriptionProducts;
  final logger = Logger();

  ProductAddOnsBloc(this._refs) : super(ProductAddOnsInitial()) {
    on<GetSelfProductEvents>(
      (event, emit) async {
        // emit(ProductAddOnsLoadingState());

        try {
          // throttleFunction(() {});
          _subscriptionProducts = _refs.onValue.listen((event) {
            FirebaseAuth auth = FirebaseAuth.instance;
            User? user = auth.currentUser;
            if (event.snapshot.value == null) {
              if (!emit.isDone) {
                emit(const ProductErrorState("No data saved"));
                // _subscriptionProducts?.isPaused;
              }
            } else {
              // logger.d(event.snapshot.value);
              var dataObject = (event.snapshot.value as Map<dynamic, dynamic>?);

              // var data = dataObject
              //     ?.map((key, value) => MapEntry(key.toString(), value));

              //data is storename, storeaddress, and isApproved
              if (dataObject != null) {
                // Create a list to hold the products
                List<ProductEntity> productList = [];

                // Iterate over the entries to populate the list
                if (!emit.isDone) {
                  dataObject.forEach((key, value) {
                    List<String> productImages =
                        (value['imageUrls'] as List<dynamic>?)
                                ?.map((imageUrl) => imageUrl as String)
                                .toList() ??
                            [];
                    String productName = value['name'];
                    String productLabel = value['label'];
                    double productPrice =
                        double.parse(value['price'].toString());
                    String itemDescriptions = value['itemDescriptions'];
                    String storeId = "storeId-${user!.uid}-id";

                    // Assuming uid is accessible in this scope
                    List<ProductVariantEntity?> productVariants =
                        (value['variant-${user!.uid}-id'] as List<dynamic>?)
                                ?.map((variant) => ProductVariantEntity(
                                    images: variant['variantImages'],
                                    varianName: variant['variantName'],
                                    variantPrice: variant['variantPrice']))
                                .toList() ??
                            []; // Fallback to an empty list if null

                    // Create a ProductEntity and add it to the list
                    productList.add(ProductEntity(productImages, productName,
                        productLabel, productPrice, itemDescriptions,
                        productVariant: productVariants,
                        productKey: key,
                        storeId: storeId));
                  });
                  // logger.d(productList);

                  // Emit the new state with the list of ProductEntity

                  emit(ProductSuccessState(productList));
                  // logger.d("DOES EMIT");
                } else {
                  if (!emit.isDone) {
                    emit(const ProductErrorState("No data saved"));
                  }
                  // _subscriptionProducts?.isPaused;
                }

                // _subscriptionProducts?.isPaused;
              }
            }
          }, onDone: () {
            _subscriptionProducts!.asFuture();
            emit(ProductAddOnsLoadedState());
          }, onError: (error) {
            logger.e(error);
            emit(ProductErrorState("Error Occured: $error"));
          });
          await _subscriptionProducts!.asFuture();
        } catch (e) {
          logger.e(e.toString());
          emit(ProductErrorState("Error Occured: $e"));
        }
      },
    );
  }
}
