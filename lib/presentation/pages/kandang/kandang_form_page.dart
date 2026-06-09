import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../controllers/kandang_controller.dart';
import '../../../data/models/kandang_model.dart';

class KandangFormPage extends StatelessWidget {
  KandangFormPage({Key? key}) : super(key: key);

  final KandangController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  
  final _namaController = TextEditingController();
  final _kapasitasController = TextEditingController();
  final lat = "".obs;
  final lng = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kandang')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Kandang', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kapasitasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Kapasitas (Ekor)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              const Text('Lokasi Kandang (LBS)', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => Text(
                lat.value.isEmpty ? 'Belum set lokasi' : 'Lat: ${lat.value}\nLng: ${lng.value}',
                style: const TextStyle(color: Colors.blueGrey),
              )),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  Position? pos = await controller.getCurrentLocation();
                  if (pos != null) {
                    lat.value = pos.latitude.toString();
                    lng.value = pos.longitude.toString();
                  }
                },
                icon: const Icon(Icons.location_on),
                label: const Text('Dapatkan Lokasi Saat Ini'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (lat.value.isEmpty) {
                      Get.snackbar('Perhatian', 'Silakan dapatkan lokasi terlebih dahulu');
                      return;
                    }
                    final kandang = Kandang(
                      namaKandang: _namaController.text,
                      kapasitas: int.parse(_kapasitasController.text),
                      lokasiLat: lat.value,
                      lokasiLng: lng.value,
                    );
                    controller.addKandang(kandang);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Simpan', style: TextStyle(color: Colors.white, fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
