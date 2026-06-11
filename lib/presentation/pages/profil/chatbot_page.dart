import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chatbot_controller.dart';

class ChatbotPage extends StatelessWidget {
  ChatbotPage({Key? key}) : super(key: key);

  final ChatbotController controller = Get.put(ChatbotController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asisten Peternakan AI')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                var msg = controller.messages[index];
                bool isUser = msg['sender'] == 'User';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.pink.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg['text']!, style: const TextStyle(fontSize: 16)),
                  ),
                );
              },
            )),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(color: Colors.pink),
              );
            }
            return const SizedBox.shrink();
          }),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Tanya tentang pakan, penyakit...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.pink,
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      controller.sendMessage(textController.text);
                      textController.clear();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
