import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class MapPickerPage extends StatefulWidget {
  final double initialLat;
  final double initialLng;

  const MapPickerPage({Key? key, this.initialLat = -7.98, this.initialLng = 112.63}) : super(key: key);

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _currentCenter;

  @override
  void initState() {
    super.initState();
    _currentCenter = LatLng(widget.initialLat, widget.initialLng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi Kandang'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.initialLat, widget.initialLng),
              zoom: 15,
            ),
            onCameraMove: (CameraPosition position) {
              _currentCenter = position.target;
            },
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 32.0), // Geser sedikit ke atas agar pas di tengah
              child: Icon(Icons.location_on, size: 48, color: Colors.pink),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_currentCenter != null) {
            Get.back(result: _currentCenter);
          }
        },
        label: const Text('Pilih Lokasi Ini', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.check, color: Colors.white),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
