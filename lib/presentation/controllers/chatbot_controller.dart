import 'package:get/get.dart';
import '../../data/datasources/api_service.dart';

class ChatbotController extends GetxController {
  var messages = <Map<String, String>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    messages.add({'sender': 'AI', 'text': 'Halo Peternak! Ada yang bisa saya bantu terkait bebek hari ini?'});
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    messages.add({'sender': 'User', 'text': text});
    isLoading.value = true;
    
    String reply = await ApiService.chatWithAI(text);
    
    isLoading.value = false;
    messages.add({'sender': 'AI', 'text': reply});
  }
}
