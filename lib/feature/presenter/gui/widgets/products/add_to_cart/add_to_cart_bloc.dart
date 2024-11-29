// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:anihan_app/common/api_result.dart';

import 'package:anihan_app/feature/domain/entities/add_to_cart_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_add_cart_params.dart';
import 'package:anihan_app/feature/domain/usecases/product_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../../../../services/date_services.dart';

part 'add_to_cart_event.dart';
part 'add_to_cart_state.dart';

@injectable
class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  AddToCartProductUsecase _addToCartProductUsecase;
  final FirebaseDatabase db = FirebaseDatabase.instance;

  late StreamSubscription? _subscriptionProducts;

  AddToCartBloc(this._addToCartProductUsecase) : super(AddToCartInitial()) {
    on<AddProductListToCart>((event, emit) async {
      emit(AddToCartLoadingState());

      var response =
          await _addToCartProductUsecase(event.params, event.storeId);

      var status = response.status;

      if (status == Status.success) {
        var data = response.data;
        if (data != null) {
          emit(AddToCartSuccessState(data));
        }
      } else {
        emit(AddToCartErrorState(response.message!));
      }
    });

    on<GetAllCartEvent>((event, emit) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      final DateServices date = DateServices();
      final logger = Logger();

      // var data =

      try {
        if (user != null) {
          DatabaseReference _refs = db.ref("cart/${user.uid}");

          _subscriptionProducts = _refs.onValue.listen((event) {
            if (event.snapshot.value == null) {
              if (!emit.isDone) {
                emit(const AddToCartErrorState("No Data Save"));
              }
            } else {
              var dataObject = (event.snapshot.value as Map<dynamic, dynamic>?);
              logger.d(dataObject);
              if (dataObject != null) {
                List<Map<dynamic, dynamic>> extractedData = [];
                List<AddToCartProductEntity> products = [];
                List<AddToCartEntity> productsCart = [];
                double totalPrice = 0.0;
                String storeId = "";
                String cartId = "";
                int createdAt = 0;

                dataObject.forEach((storeKey, storeData) {
                  storeId = storeKey.toString();

                  storeData.forEach((productKey, productData) {
                    cartId = productKey;

                    productData.forEach((key, map) {
                      if (key != 'total' && key != 'created_at') {
                        // createdAt = map['created_at'];
                        var productEntity = AddToCartProductEntity(
                            map["name"],
                            double.tryParse(map["price"].toString())!,
                            map["quantity"]);

                        products.add(productEntity);
                      } else if (key == 'total') {
                        totalPrice = map.toDouble() ?? 0.0;
                      } else {
                        // No action required for other keys
                      }
                    });
                  });
                  productsCart.add(AddToCartEntity(
                    storeId: storeId,
                    cartId: cartId,
                    createAt: createdAt,
                    totalPrice: totalPrice,
                    productEntity: products,
                  ));
                });

                // logger.d(productsCart);

                if (!emit.isDone) {
                  emit(AllCartSuccessState(productsCart));
                }
              }
            }
          }, onDone: () {
            _subscriptionProducts!.asFuture();
          }, onError: (error) {
            emit(AddToCartErrorState(
                "There's an error occured (Error) : $error"));
          });
          await _subscriptionProducts!.asFuture();
        }
      } catch (e) {
        emit(AddToCartErrorState("There's an error occured (Error) : $e"));
      }
    });
  }
}
