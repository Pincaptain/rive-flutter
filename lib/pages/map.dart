import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MapPageState();

}

class MapPageState extends State<MapPage> {

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(41.995921, 21.431442),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        title: Text(
          'Rive'
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        myLocationEnabled: true,
      ),
      floatingActionButton: Container(
        height: 45,
        width: double.infinity,
        margin: EdgeInsets.only(left: 30),
        child: RaisedButton(
          onPressed: () {},
          child: Text(
            'Drive',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          color: Colors.teal[400],
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

}