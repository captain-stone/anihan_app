// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/domain/entities/add_to_cart_entity.dart';
import 'package:anihan_app/feature/domain/parameters/product_add_cart_params.dart';
import 'package:anihan_app/feature/services/date_services.dart';
import 'package:anihan_app/feature/services/generate_hash_key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

import 'user_information_service_api.dart';

mixin CheckoutApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final logger = Logger();
  final UserInformationServiceApi _userInformationServiceApi =
      UserInformationServiceApi();

  Future<AddToCartEntity> checkout(
      List<ProductAddCartParams> params, String? storeId) async {
    User? user = auth.currentUser;
    final DateServices date = DateServices();
    String checkoutId = "";

    try {
      if (user != null) {
        int dateInMillis = date.dateNowMillis();
        checkoutId = generate16CharHash("$storeId$dateInMillis");

        DatabaseReference _refs =
            db.ref("checkout/${user.uid}/${storeId ?? "none"}/$checkoutId");
        double totalPrice = calculateTotal(params);

        _refs.set({"total": totalPrice.toDouble(), "created_at": dateInMillis});

        for (var param in params) {
          DatabaseReference _savingCartRef = _refs.push();
          logger.d(checkoutId);

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

                // var da = entry.key;

                final map = entry.value as Map<dynamic, dynamic>;
                return AddToCartProductEntity(
                  map["name"],
                  double.tryParse(map["price"].toString())!,
                  map["quantity"],
                  map['image'],
                );
              })
              .whereType<AddToCartProductEntity>()
              .toList();

          return AddToCartEntity(
            storeId: storeId ?? "none",
            createAt: dateInMillis,
            cartId: checkoutId,
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

  Future<bool> saveCheckoutData({
    required List<AllCartEntity> productEntity,
    required double total,
    required String deliveryDate,
    required String messageToSeller,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      var userFullData = await _userInformationServiceApi
          .getUserInformationById(user?.uid ?? "None");
      DatabaseReference _refs = db.ref("checkout");
      DatabaseReference _pushRef = _refs.push();

      String? genKey = _pushRef.key;

      // Structure data for saving

      // var dateEntity =
      List<String> cartId = [];
      String storeId = "";

      List<Map<String, dynamic>> jsonList = productEntity.map((entity) {
        cartId.add(entity.cartId);
        storeId = entity.storeId;
        return entity.toJson();
      }).toList();
      // logger.d(cartId);

      Map<String, dynamic> checkoutData = {
        "id": genKey ?? "None",
        'buyer': user?.uid ?? "None",
        'buyerName': userFullData.displayName,
        'storeId': storeId,
        'total': total,
        'deliveryDate': deliveryDate,
        'products': jsonList,
        'timestamp': DateTime.now().toIso8601String(),
        'messageToSeller': messageToSeller,
        'forApproval': Approval.pendingApproval.name,
      };

      // Save data to Firebase
      await _pushRef.set(checkoutData);

      return true; // Indicate success
    } catch (e) {
      logger.e("Error saving checkout data: $e");
      return false;
    }
  }

  Future<bool> updateApproval(
      {required String id, required String approval}) async {
    DatabaseReference _refs = db.ref("checkout/$id");

    await _refs.update({"forApproval": approval}).then((_) {
      logger.d("Value updated successfully!");

      return true;
    }).catchError((error) {
      logger.e("Failed to update value: $error");
      return false;
    });
    return false;
  }
}

class CheckoutClassApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final logger = Logger();
  final UserInformationServiceApi _userInformationServiceApi =
      UserInformationServiceApi();

  Future<ApiResult<Map<String, dynamic>>> updateApproval({
    required String id,
    required String approval,
  }) async {
    try {
      DatabaseReference _refs = db.ref("checkout/$id");

      // Perform the update
      await _refs.update({"forApproval": approval});
      logger.d("Value updated successfully!");

      // Return success
      return const ApiResult.success({
        "status": "success",
      });
    } catch (error) {
      logger.e("Failed to update value: $error");

      // Return error
      return ApiResult.error("Can't update approval: $error");
    }
  }
}
