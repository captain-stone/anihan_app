// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/feature/domain/entities/add_to_cart_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_add_cart_params.dart';
import 'package:anihan_app/feature/services/date_services.dart';
import 'package:anihan_app/feature/services/generate_hash_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

mixin CartServiceApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final logger = Logger();

  Future<AddToCartEntity> addToCartApi(
      List<ProductAddCartParams> params, String? storeId) async {
    User? user = auth.currentUser;
    final DateServices date = DateServices();
    String cartId = "";

    try {
      if (user != null) {
        int dateInMillis = date.dateNowMillis();
        cartId = generate16CharHash("$storeId$dateInMillis");

        DatabaseReference _refs =
            db.ref("cart/${user.uid}/${storeId ?? "none"}/$cartId");
        double totalPrice = calculateTotal(params);

        _refs.set({"total": totalPrice.toDouble(), "created_at": dateInMillis});

        for (var param in params) {
          DatabaseReference _savingCartRef = _refs.push();
          logger.d(cartId);

          var data = {
            "name": param.name,
            "image": param.image,
            "price": param.price,
            "quantity": param.quantity,
          };
          await _savingCartRef.set(data);
        }

        // Fetch and return saved data
        DataSnapshot dataSnapshot =
            await _refs.once().then((event) => event.snapshot);

        Map<dynamic, dynamic>? cartDataList = dataSnapshot.value as Map?;
        logger.d(cartDataList);

        if (cartDataList != null) {
          // String cartIdFromFirebase = "None";
          var productsEntity = cartDataList.entries
              .map((entry) {
                if (entry.value.runtimeType == int) {
                  return null;
                }

                final map = entry.value as Map<dynamic, dynamic>;
                return AddToCartProductEntity(map["name"],
                    double.tryParse(map["price"].toString())!, map["quantity"]);
              })
              .whereType<AddToCartProductEntity>()
              .toList();

          return AddToCartEntity(
            storeId: storeId ?? "none",
            createAt: dateInMillis,
            cartId: cartId,
            totalPrice: totalPrice,
            productEntity: productsEntity,
          );
        } else {
          // return [];
          throw Exception("No saved data");
        }
      } else {
        // return [];
        throw Exception("No User found. Please login first");
      }
    } catch (e) {
      rethrow;
    }
  }

  double calculateTotal(List<ProductAddCartParams> dataParams) {
    return dataParams.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }
}
