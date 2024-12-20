// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/dto/seller_registrations_dto.dart';
import 'package:anihan_app/feature/data/models/dto/user_information_dto.dart';
import 'package:anihan_app/feature/domain/entities/user_information_and_data_entity.dart';
import 'package:anihan_app/feature/domain/parameters/farmers_registration_params.dart';
import 'package:anihan_app/feature/services/date_services.dart';
import 'package:anihan_app/feature/services/generate_hash_key.dart';
import 'package:anihan_app/feature/services/get_location_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class UserInformationServiceApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;
  final logger = Logger();

  Future<User> gettingUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    if (user != null) {
      return user;
    } else {
      // return user ?? ;
      throw Exception('No user is signed in');
    }
  }

  Future<UserInformationDto> getUserInformationById(String uid) async {
    try {
      late final String approvalRemarks;

      DatabaseReference _refs = db.ref("users/$uid");
      DataSnapshot dataSnapshot =
          await _refs.once().then((event) => event.snapshot);
      if (dataSnapshot.exists) {
        Map<dynamic, dynamic> data =
            dataSnapshot.value as Map<dynamic, dynamic>;

        var name = data['fullName'];
        var email = data['emailAddress'];
        var phone = data['phoneNumber'];

        if (!data.containsKey('farmers')) {
          data['farmers'] = Approval.pendingApproval.name;
          approvalRemarks = data['farmers'];
        } else {
          approvalRemarks = data['farmers'];
        }

        return UserInformationDto(name, approvalRemarks, email, phone);
      } else {
        throw Exception('No data found for this user');
      }
    } catch (e) {
      logger.e(e);
      throw Exception("Failed to fetch user information");
    }
  }

  Future<UserInformationDto> userInformation(String uid) async {
    User user = await gettingUserId();

    try {
      late final String approvalRemarks;

      // Reference to the specific user's data in Firebase Realtime Database
      DatabaseReference _refs = db.ref("users/$uid");

      // Await the data snapshot
      DataSnapshot dataSnapshot =
          await _refs.once().then((event) => event.snapshot);

      // Check if data exists in the database
      if (dataSnapshot.exists) {
        Map<dynamic, dynamic> data =
            dataSnapshot.value as Map<dynamic, dynamic>;

        String displayName = user.displayName ?? 'unknown';
        // String approvalRemarks =
        String emailAddress = data['emailAddress'] ?? user.email ?? 'No email';
        int phoneNumber = data['phoneNumber'] ?? 'No phone number';
        String? photoUrl = user.photoURL;

        // String? photoUrl = data['photoUrl'];

        // Log the retrieved data
        // logger.i("User Information: $data");

        if (!data.containsKey('farmers')) {
          data['farmers'] = Approval.pendingApproval.name;
          approvalRemarks = data['farmers'];
        } else {
          approvalRemarks = data['farmers'];
        }

        // Return the UserInformationDto populated with the data
        return UserInformationDto(
          displayName,
          approvalRemarks,
          emailAddress,
          phoneNumber,
          photoUrl: photoUrl,
        );
      } else {
        throw Exception('No data found for this user');
      }

      // Return user information and the data from the database
    } catch (e) {
      logger.e("Error fetching data: $e");
      throw Exception("Failed to fetch user information");
    }
  }

//REGISTRATIONS OF SELLERS OR STORES
  Future<SellerRegistrationsDto> sellersInformation(
      FarmersRegistrationParams params) async {
    DateServices date = DateServices();

    List<String> parts = params.storeAddress.split(',');

    // Convert the strings to double
    double latitude = double.parse(parts[0].trim());
    double longitude = double.parse(parts[1].trim());

    //generate storeID: store+uid

    User user = await gettingUserId();

    // your db mus inside of farmers and userId,
    String storeId = "storeId-${user.uid}-id";

    var sellersData = {
      "onlineTime": params.onlineTime,
      storeId: true,
      "storeAddress": params.storeAddress,
      "isApproved":
          Approval.pendingApproval.name, //approved, pending, not approved
      'date_created': date.dateNow()
    };

    var storeData = {
      "storeName": params.storeName,
      "storeLocation": (await getCityName(latitude, longitude)) ?? "None",
      "storeAddress": params.storeAddress,
      "created_at": date.dateNowMillis(),
    };

    var location = {
      "lat": latitude,
      "longi": longitude,
    };

    try {
      DatabaseReference _farmersRef = db.ref("farmers/${user.uid}");
      DatabaseReference _storeRef = db.ref("store/$storeId");
      DatabaseReference _location =
          db.ref("location/${await getCityName(latitude, longitude)}");
      // DatabaseReference _userRef = db.ref("users/${user.uid}");

      _farmersRef.set(sellersData);
      _storeRef.set(storeData);
      _location.push().set(location);
      // _userRef.update({'farmers' : true}); //this is the logic if you want to approve
      //initially not approved
      return SellerRegistrationsDto(
          storeName: params.storeName,
          storeAddress: params.storeAddress,
          isApprove: Approval.pendingApproval.name);
    } catch (e) {
      return SellerRegistrationsDto(storeName: "", storeAddress: "");
    }
  }

  Future<Map<String, dynamic>> updateUserAddress(
      String uid, String address, String selectedAddress) async {
    DatabaseReference _refs = db.ref("users/$uid/saveAddress");
    var generatedHashKey = generate16CharHash("$address+$uid");

    var data = {
      generatedHashKey: address,
      "address": selectedAddress,
    };

    _refs.update(data);

    DataSnapshot _snapshot = await _refs.once().then((event) => event.snapshot);
    if (_snapshot.exists) {
      Map<String, String> _refData =
          Map<String, String>.from(_snapshot.value as Map);
      logger.d(_refData);
      List<String> data = _refData.values.toList();
    }
    return {"saveAddress": data, "address": data["address"]};
  }

  Future<Map<String, dynamic>> updateSelectedAddress(
      String uid, String selectedAddress) async {
    DatabaseReference _refs = db.ref("users/$uid/saveAddress");

    var data = {
      "address": selectedAddress,
    };

    _refs.update(data);

    DataSnapshot _snapshot = await _refs.once().then((event) => event.snapshot);
    if (_snapshot.exists) {
      Map<String, String> _refData =
          Map<String, String>.from(_snapshot.value as Map);
      logger.d(_refData);
      List<String> data = _refData.values.toList();
    }
    return {"saveAddress": data, "address": data["address"]};
  }

  Future<List<String>> getAllSavedAddressApi(String uid) async {
    DatabaseReference _refs = db.ref("users/$uid/saveAddress");
    List<String> data = [];

    DataSnapshot _snapshot = await _refs.once().then((event) => event.snapshot);
    if (_snapshot.exists) {
      Map<String, String> _refData =
          Map<String, String>.from(_snapshot.value as Map);
      logger.d(_refData);

      data = _refData.entries
          .where((entry) => entry.key != "address") // Exclude specific key
          .map((entry) => entry.value) // Extract values only
          .toList();
    }
    return data;
  }

  Future<Map<String, dynamic>> getAllSavedAndSelectedAddressApi(
      String uid) async {
    DatabaseReference _refs = db.ref("users/$uid/saveAddress");
    List<String> data = [];
    String selectedData = '';

    DataSnapshot _snapshot = await _refs.once().then((event) => event.snapshot);
    if (_snapshot.exists) {
      Map<String, String> _refData =
          Map<String, String>.from(_snapshot.value as Map);
      logger.d(_refData);
      selectedData = _refData['address']!;

      data = _refData.entries
          .where((entry) => entry.key != "address") // Exclude specific key
          .map((entry) => entry.value) // Extract values only
          .toList();
    }
    return {"selectedAddress": selectedData, "data": data};
  }
}
