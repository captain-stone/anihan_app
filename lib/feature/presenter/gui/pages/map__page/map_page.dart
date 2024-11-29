import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/presenter/gui/pages/map__page/map_page_cubit.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

@RoutePage()
class MapPage extends StatefulWidget {
  final LatLng center;
  final String city;
  // final BuildContext myContext;
  const MapPage({
    super.key,
    required this.center,
    required this.city,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> markers = [];
  late LatLng addressFromTheMap;
  LatLng _center = const LatLng(14.084558, 121.149701);
  MapController mapController = MapController();
  final logger = Logger();
  final _cubit = getIt<MapPageCubit>();

  @override
  void initState() {
    super.initState();

    // widget.myContext.read<MapPageCubit>().getAllLocations((widget.city));
    _cubit.getAllLocations(widget.city);
    setState(() {
      _center = widget.center;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    return BlocConsumer<MapPageCubit, MapPageState>(
      bloc: _cubit,
      listener: (context, state) {
        // TODO: implement listener
        if (state is MapPageSuccessState) {
          var data = state.locations;

          if (data.isNotEmpty) {
            for (var latlong in data) {
              var marker = Marker(
                  point: LatLng(latlong.latitude, latlong.longitude),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.blue,
                    size: 42,
                  ));

              markers.add(marker);
            }
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
                  height: _height,
                  width: _width,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _center, // Default map center
                      initialZoom: 13,
                      onTap: (tapPosition, point) {
                        // print("Selected location: $point");
                        setState(() {
                          addressFromTheMap = point;
                          // storeAddressController.text =
                          //     "${point.latitude}, ${point.longitude}";
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
              ], // Adjust for keyboard
            ),
          ),
        );
      },
    );
  }
}
