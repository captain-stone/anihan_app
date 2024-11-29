// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/domain/parameters/farmers_registration_params.dart';
import 'package:anihan_app/feature/presenter/gui/pages/seller_registration_bloc/seller_registration_bloc.dart';
import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/addons/custom_alert_dialog.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

import '../../widgets/custom_app_bar.dart';
import '../add_ons_blocs/check_friends_bloc/check_friends_bloc.dart';

@RoutePage()
class SellerRegistrationPage extends StatefulWidget {
  final String uid;
  final String fullName;
  final int phoneNumber;

  const SellerRegistrationPage(
      {required this.uid,
      required this.fullName,
      required this.phoneNumber,
      super.key});

  @override
  State<SellerRegistrationPage> createState() => _SellerRegistrationPageState();
}

class _SellerRegistrationPageState extends State<SellerRegistrationPage> {
  final _bloc = getIt<SellerRegistrationBloc>();
  List<Marker> markers = [];
  TextEditingController storeNameController = TextEditingController();
  TextEditingController onlineTimeController = TextEditingController();
  TextEditingController storeAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final logger = Logger();
  late LatLng addressFromTheMap;
  bool isPassHide = true;

  String storeAddress = "";
  String storeName = "";
  LatLng _center = const LatLng(14.084558, 121.149701);
  MapController mapController = MapController();
  Widget _buildTextField(BuildContext context,
      {required String hintText,
      required IconData icon,
      required TextEditingController controller,
      bool isPassword = false,
      bool hasSuffixIcon = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && isPassHide,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: _shoHidePassWord,
                icon: isPassHide
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility))
            : hasSuffixIcon
                ? TextButton(onPressed: _showMap, child: const Text("show map"))
                : null,
      ),
    );
  }

  _showError(String message) {
    showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
            colorMessage: Colors.red,
            title: "Map Error",
            onPressedCloseBtn: () {
              Navigator.pop(context);
            },
            child: Text(message)));
  }

  void _searchLocation(String query, StateSetter setState) async {
    try {
      // Fetch the list of locations matching the query
      List<Location> locations = await locationFromAddress(query);
      logger.d(locations);
      if (locations.isNotEmpty) {
        // Get the first location result
        final location = locations.first;

        setState(() {
          // markers = [];
          // Update the map center to the searched location
          _center = LatLng(location.latitude, location.longitude);

          markers = [
            Marker(
                point: _center,
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.blue,
                  size: 32,
                ))
          ];
        });

        // Optionally, move the map controller to the searched location
        mapController.move(_center, 13.0);

        print("Location found: ${location.latitude}, ${location.longitude}");
      } else {
        logger.e("No location found for query: $query");
        _showError("No location found for query: $query");
      }
    } catch (e) {
      logger.e("Error occurred while searching: $e");
      _showError("Error occurred while searching: $e");
    }
  }

  _showMap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(12))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Search location...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      logger.d(value);
                      // Implement search logic here, e.g., use geocoding to get coordinates
                      _searchLocation(value, setState);
                    },
                  ),
                ),
                // Map Container
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                  height: 350,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _center, // Default map center
                      initialZoom: 13,
                      onTap: (tapPosition, point) {
                        // print("Selected location: $point");
                        setState(() {
                          addressFromTheMap = point;
                          storeAddressController.text =
                              "${point.latitude}, ${point.longitude}";
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                    mapController: mapController,
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        // tileProvider: const DefaultTileProvider(),
                      ),
                      MarkerLayer(markers: markers),
                      // MarkerLayer(
                      //   markers: [
                      //     Marker(
                      //       point: _center, // Example marker at the center
                      //       // builder: (ctx) =>
                      //       //     Icon(Icons.location_pin, color: Colors.red),
                      //       child: Text("ADSf"),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  _shoHidePassWord() {
    setState(() {
      isPassHide = !isPassHide;
    });
  }

  bool isConvertibleToDouble(String value) {
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return BlocConsumer<SellerRegistrationBloc, SellerRegistrationState>(
      bloc: _bloc,
      listener: (context, state) {
        logger.d(state);

        if (state is SellerRegistrationSuccessState) {
          // var data = state.registrationFarmersEntity.
          //

          showDialog(
              context: context,
              builder: (buildContext) {
                return CustomAlertDialog(
                    colorMessage: Colors.greenAccent,
                    onPressedCloseBtn: () {
                      AutoRouter.of(context)
                          .replace(HomeNavigationRoute(uid: widget.uid));
                    },
                    title: "Registration Success",
                    child: Text(
                        "Thank you for Registration. \nYour Store name is ${storeNameController.text}"));
              });
        }
        if (state is SellerErrorState) {
          showDialog(
              context: context,
              builder: (buildContext) {
                return CustomAlertDialog(
                    colorMessage: Colors.red,
                    onPressedCloseBtn: () {
                      Navigator.of(context).pop();
                    },
                    title: "Registration Error",
                    child: Text(state.message));
              });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: _height,
              width: _width,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned(
                        top: -100,
                        left: -200,
                        child: Transform.rotate(
                          angle: 0.3490,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 2.0,
                            height: 250,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -100,
                        right: -200,
                        child: Transform.rotate(
                          angle: 0.3490,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 2.0,
                            height: 250,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'assets/logo.png', // Replace with your actual logo path
                                  height: 100,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Please provide additional\nInformation to become a seller!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        fontSize: 20,
                                      ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                            _buildTextField(
                              context,
                              controller: storeNameController,
                              hintText: 'Store Name',
                              icon: Icons.store,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              context,
                              controller: onlineTimeController,
                              hintText: 'Online Time',
                              icon: Icons.access_time,
                            ),
                            const SizedBox(height: 16),

                            // GestureDetector(
                            //   onTap: () {
                            //     logger.d("HELLO");
                            //     _showMap();
                            //   },
                            //   child: Focus(
                            //     onFocusChange: (hasFocus) {
                            //       if (hasFocus) {

                            //         // If TextFormField gains focus, close the keyboard immediately
                            //         FocusScope.of(context)
                            //             .requestFocus(FocusNode());
                            //       }
                            //     },
                            _buildTextField(context,
                                controller: storeAddressController,
                                hintText: 'Physical Store/Farm Location',
                                icon: Icons.map,
                                hasSuffixIcon: true),
                            //   ),
                            // ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              context,
                              controller: passwordController,
                              hintText: 'Enter Your Password',
                              icon: Icons.lock,
                              isPassword: true,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                // logger.d(storeNameController.text);
                                // logger.d(passwordController.text);

                                List<String> latLngList =
                                    storeAddressController.text.split(',');

                                // Convert the strings to doubles
                                if (isConvertibleToDouble(
                                    latLngList[0].trim())) {
                                  var params = FarmersRegistrationParams(
                                      storeName: storeNameController.text,
                                      onlineTime: onlineTimeController.text,
                                      storeAddress: storeAddressController.text,
                                      password: passwordController.text);

                                  _bloc.add(SellerUidEvent(params));
                                  logger.d(params);
                                } else {
                                  _showError(
                                      "Please choose your address on the map. Thank you!");
                                }
                              },
                              style:
                                  Theme.of(context).elevatedButtonTheme.style,
                              child: const Text('Finish'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
