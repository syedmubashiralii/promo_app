import 'package:flutter/material.dart';
import 'package:flutter_ui/utils/color_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedLocation;
  GoogleMapController? _mapController;
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Location location = Location();

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }
    }

    // Request location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('Location permissions are denied.');
        return;
      }
    }

    // Get the user's current location
    LocationData locationData = await location.getLocation();

    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });

    // Move the camera to the user's location
    _mapController
        ?.animateCamera(CameraUpdate.newLatLngZoom(currentLocation!, 14));
  }

  void _onMapTap(LatLng position) {
    setState(() => selectedLocation = position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHelper.white,
        title: Text('Select Location'),
        foregroundColor: Colors.black,
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation!,
                zoom: 14,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onTap: _onMapTap,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: {
                if (selectedLocation != null)
                  Marker(
                      markerId: MarkerId('selected'),
                      position: selectedLocation!)
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedLocation != null) {
            Navigator.pop(context, selectedLocation);
          } else if (currentLocation != null) {
            Navigator.pop(context, currentLocation);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
