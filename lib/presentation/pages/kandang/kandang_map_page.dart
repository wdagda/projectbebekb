import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/kandang_model.dart';

class KandangMapPage extends StatelessWidget {
  final Kandang kandang;
  
  const KandangMapPage({Key? key, required this.kandang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double lat = double.tryParse(kandang.lokasiLat) ?? -7.98;
    double lng = double.tryParse(kandang.lokasiLng) ?? 112.63;
    LatLng target = LatLng(lat, lng);

    return Scaffold(
      appBar: AppBar(
        title: Text('Peta: ${kandang.namaKandang}'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: target,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('kandang_${kandang.id}'),
            position: target,
            infoWindow: InfoWindow(title: kandang.namaKandang, snippet: 'Kapasitas: ${kandang.kapasitas}'),
          )
        },
      ),
    );
  }
}
