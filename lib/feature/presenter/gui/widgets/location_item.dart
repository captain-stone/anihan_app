// ignore_for_file: library_private_types_in_public_api, prefer_final_fields

import 'package:anihan_app/feature/presenter/gui/routers/app_routers.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/debugger/logger_debugger.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'animation_theme.dart';

class LocationItem extends StatefulWidget {
  final String location;

  const LocationItem({super.key, required this.location});

  @override
  _LocationItemState createState() => _LocationItemState();
}

class _LocationItemState extends State<LocationItem>
    with SingleTickerProviderStateMixin, LoggerEvent {
  bool _isPressed = false;
  late final AnimationController _controller;
  String _location = "";
  // final _center = LatLng(latitude, longitude)
  LatLng _center = const LatLng(14.084558, 121.149701);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AnimationTheme animationTheme =
        Theme.of(context).extension<AnimationTheme>()!;
    final scale = _isPressed ? animationTheme.pressScale : 1.0;

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        // Placeholder for future functionality when location is clicked
        debug('Location ${widget.location} clicked');

        if (widget.location == "Sambat") {
          _location = "Sambat";
          _center = const LatLng(14.082060511234795, 121.12909413658744);
        } else if (widget.location == "Malvar") {
          _location = "Malvar";
          _center = const LatLng(14.04373503588802, 121.15885602263576);
        } else if (widget.location == "Sto. Tomas") {
          _location = "Santo Tomas";
          _center = const LatLng(14.108881082993346, 121.14602689397782);
        } else {
          _location = widget.location;
          _center = _center;
        }

        AutoRouter.of(context).push(MapRoute(center: _center, city: _location));
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Padding(
        padding:
            const EdgeInsets.all(8.0), // Added padding around the container
        child: AnimatedScale(
          scale: scale,
          duration: animationTheme.duration,
          child: Container(
            width: 160.0, // Width for better display
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0), // More rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: const Offset(0, 4), // Shadow effect
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(
                        16.0), // Top rounded corners for image/icon
                  ),
                  child: Container(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    height: 100.0, // Reduced height for the content
                    child: Center(
                      child: Icon(
                        Icons.map_outlined,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Adjusted padding
                  child: Text(
                    widget.location,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
