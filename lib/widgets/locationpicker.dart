import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class VendorLocationPicker extends StatefulWidget {
  const VendorLocationPicker({Key? key}) : super(key: key);

  @override
  State<VendorLocationPicker> createState() => _VendorLocationPickerState();
}

class _VendorLocationPickerState extends State<VendorLocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  bool _isLoading = true;
  late CameraPosition _initialPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enable location services.'),
      ));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Location permissions are denied.'),
      ));
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition =
          CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 15);
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) => _mapController = controller,
              markers: _selectedLocation == null
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selectedLocation!,
                        draggable: true,
                        onDragEnd: (newPosition) {
                          setState(() {
                            _selectedLocation = newPosition;
                          });
                        },
                      )
                    },
              onTap: (position) {
                setState(() {
                  _selectedLocation = position;
                });
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green.shade700,
        onPressed: () {
          if (_selectedLocation != null) {
            Navigator.pop(context, _selectedLocation);
          }
        },
        label: const Text('Confirm Location'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
