// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

part 'map_page_state.dart';

@injectable
class MapPageCubit extends Cubit<MapPageState> {
  MapPageCubit() : super(MapPageInitial());

  Future<void> getAllLocations(String city) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseDatabase db = FirebaseDatabase.instance;

    User? user = auth.currentUser;
    final logger = Logger();
    List<LatLng> data = [];

    try {
      if (user != null) {
        DatabaseReference _refs = db.ref("location/$city");

        DataSnapshot dataSnapshot =
            await _refs.once().then((event) => event.snapshot);

        if (dataSnapshot.exists) {
          Map<dynamic, dynamic>? locationList = dataSnapshot.value as Map?;
          if (locationList != null && locationList.isNotEmpty) {
            locationList.forEach((locationKey, locationData) {
              if (locationData is Map) {
                double? lat = locationData['lat'] as double?;
                double? long = locationData['longi'] as double?;

                if (lat != null && long != null) {
                  logger.d("Lat: $lat, Long: $long");

                  data.add(LatLng(lat, long));
                } else {
                  logger
                      .w("Missing lat or long in location data: $locationData");
                }
              } else {
                logger.w(
                    "Invalid data format for key $locationKey: $locationData");
              }
            });
            emit(MapPageSuccessState(data));
          } else {
            logger.w("Location list is empty");
            emit(const MapPageErrorState("Location list is empty"));
          }
        } else {
          logger.w("Data snapshot does not exist");

          emit(const MapPageErrorState("Location is Empty"));
        }
      }
    } catch (e) {
      emit(MapPageErrorState("Error: $e"));
    }
  }
}
