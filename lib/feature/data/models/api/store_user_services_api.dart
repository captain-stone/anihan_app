import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/domain/entities/store_data_entity.dart';
import 'package:anihan_app/feature/services/get_location_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class StoreUserServicesApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<ApiResult<StoreDataEntity>> getStoreIdInfo(String storeId) async {
    DatabaseReference _refs = db.ref("store/$storeId");
    final Logger logger = Logger();

    try {
      DataSnapshot dataSnapshot =
          await _refs.once().then((event) => event.snapshot);
      logger.d(dataSnapshot.value);
      if (dataSnapshot.exists) {
        Map<dynamic, dynamic>? storeData = dataSnapshot.value as Map?;

        logger.d(storeData);
        if (storeData != null) {
          var createdAt = storeData['created_at'];
          var storeAddress = await getFullAddress(storeData['storeAddress']);
          var storeLocation = storeData['storeLocation'];
          var storeName = storeData['storeName'];

          var storeInfo = StoreDataEntity(
              createdAt: createdAt,
              storeName: storeName,
              storeLocation: storeLocation,
              storeAddress: storeAddress ?? storeData['storeAddress']);

          return ApiResult.success(storeInfo);
        } else {
          return const ApiResult.error("The store is empty");
        }
      } else {
        return const ApiResult.error("There's an error occured");
      }
    } catch (e) {
      return ApiResult.error("There's an error occured $e");
    }
  }
}
