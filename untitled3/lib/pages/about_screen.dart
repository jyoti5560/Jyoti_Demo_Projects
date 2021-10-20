import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
         // onTap: _handleTap,
          myLocationEnabled: true,
          compassEnabled: false,
          onMapCreated: _onMapCreated,
          //onCameraMove: _onCameraMove,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 14,
          ),
          zoomGesturesEnabled: true,
        ),
      ),
    );
  }
}
