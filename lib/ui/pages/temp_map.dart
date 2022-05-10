import 'package:flutter/material.dart';

import 'package:chat_app/ui/widgets/map.dart';

class TempMap extends StatelessWidget {
  final double lat;
  final double lng;

  const TempMap({Key? key, required this.lat, required this.lng})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MapWidget map = MapWidget(lat: lat, lng: lng);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Secret chatter"),
      ),
      body: SafeArea(child: map),
    );
  }
}
