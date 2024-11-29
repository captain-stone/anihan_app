// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/api_result.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class NameStoreNameApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final logger = Logger();

  Future<ApiResult<Map<String, String>>> getNameAndStoreName(String id) async {
    try {
      DatabaseReference _userReference = db.ref("users");
      DatabaseReference _storeReference = db.ref("store");

      var userId = id.replaceAll("storeId-", "").replaceAll("-id", "");

      //check the userId name
      DataSnapshot userSnapshot = await _userReference.child(userId).get();
      String? userName = userSnapshot.child("fullName").value as String?;

      if (userName == null) {
        logger.w("User name not found for userId: $userId");
        // return {"error": "User name not found"};
        const ApiResult.error("User name not found");
      }

      // Fetch store name
      DataSnapshot storeSnapshot = await _storeReference.child(id).get();
      String? storeLocation =
          storeSnapshot.child("storeLocation").value as String?;

      if (storeLocation == null) {
        logger.w("Store name not found for userId: $userId");
        storeLocation = "No Store Found";
        const ApiResult.error("Store not found");
      }

      // Return both user and store names
      return ApiResult.success(
          {"userName": userName ?? "None", "storeLocation": storeLocation});
    } catch (e) {
      // rethrow;
      // return {'status': "error", "message": "e"};
      return ApiResult.error(e.toString());
    }
  }
}
