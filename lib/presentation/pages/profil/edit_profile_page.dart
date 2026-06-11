import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profil_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({Key? key}) : super(key: key);

  final ProfilController controller = Get.find();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Isi default username
    usernameCtrl.text = controller.username.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.fingerprint, size: 80, color: Colors.pink),
            const SizedBox(height: 16),
            const Text('Verifikasi biometrik diperlukan untuk menyimpan perubahan.'),
            const SizedBox(height: 32),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama Lengkap Baru', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameCtrl,
              decoration: const InputDecoration(labelText: 'Username Baru', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password Baru', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                controller.updateProfileData(nameCtrl.text, usernameCtrl.text, passwordCtrl.text);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              child: const Text('Simpan Perubahan'),
            )
          ],
        ),
      ),
    );
  }
}
