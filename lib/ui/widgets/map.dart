import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loggy/loggy.dart';

class MapWidget extends StatelessWidget {
  final Completer<GoogleMapController> _controller = Completer();
  final double lat;
  final double lng;

  MapWidget({Key? key, required this.lat, required this.lng}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logInfo(lat);
    return Scaffold(
      body: GoogleMap(
        compassEnabled: false,
        mapToolbarEnabled: false,
        rotateGesturesEnabled: false,
        zoomGesturesEnabled: false,
        zoomControlsEnabled: false,
        trafficEnabled: false,
        buildingsEnabled: false,
        liteModeEnabled: true,
        tiltGesturesEnabled: false,
        scrollGesturesEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(lat, lng), zoom: 18),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
