import 'package:flutter/material.dart';
import 'package:flutter_geolocation/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GeoMapScreen(),
    );
  }
}

class GeoMapScreen extends StatefulWidget {
  const GeoMapScreen({super.key});

  @override
  State<GeoMapScreen> createState() => _GeoMapScreenState();
}

class _GeoMapScreenState extends State<GeoMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() => _loading = true);
    Position? position = await LocationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to fetch location")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Geolocation Mapping"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  position: _currentPosition!,
                  infoWindow: const InfoWindow(title: 'You are here'),
                )
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 16,
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
