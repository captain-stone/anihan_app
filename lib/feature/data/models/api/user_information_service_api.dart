// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/feature/data/models/dto/seller_registrations_dto.dart';
import 'package:anihan_app/feature/data/models/dto/user_information_dto.dart';
import 'package:anihan_app/feature/domain/parameters/farmers_registration_params.dart';
import 'package:anihan_app/feature/services/date_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class UserInformationServiceApi {
  final FirebaseDatabase db = FirebaseDatabase.instance;

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

  Future<UserInformationDto> userInformation(String uid) async {
    final logger = Logger();
    User user = await gettingUserId();

    logger.d(uid);

    try {
      late final String approvalRemarks;

      // Reference to the specific user's data in Firebase Realtime Database
      DatabaseReference _refs = db.ref("users/$uid");

      // Await the data snapshot
      DataSnapshot dataSnapshot =
          await _refs.once().then((event) => event.snapshot);
      logger.d(dataSnapshot.exists);

      // Check if data exists in the database
      if (dataSnapshot.exists) {
        Map<dynamic, dynamic> data =
            dataSnapshot.value as Map<dynamic, dynamic>;

        // String displayName = data['displayName'] ?? 'Unknown';
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
      storeId: {
        "storeName": params.storeName,
        "storeAddress": params.storeAddress,
        //  : true,
      }
    };

    try {
      DatabaseReference _farmersRef = db.ref("farmers/${user.uid}");
      DatabaseReference _storeRef = db.ref("store");
      // DatabaseReference _userRef = db.ref("users/${user.uid}");

      _farmersRef.set(sellersData);
      _storeRef.set(storeData);
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
}
