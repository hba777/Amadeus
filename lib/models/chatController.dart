import 'package:chatbot_ai/repos/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatbot_ai/models/chat_message_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatController extends GetxController {
  var messages = <ChatMessageModel>[].obs;
  ScrollController scrollController = ScrollController();
  FlutterTts flutterTts = FlutterTts();
  var generating = false.obs;

  void addUserMessage(String message) {
    messages.add(ChatMessageModel(
      role: 'user',
      parts: [ChatPartModel(text: message)],
    ));
    _generateResponse();
    _scrollToBottom();
  }

  Future<void> _generateResponse() async {
    try {
      generating.value = true;

      String generatedText = await AmadeusRepo.chatTextGeneration(messages);
      // Remove all asterisks and extra characters
      generatedText = generatedText.replaceAll(RegExp(r'[^\w\s]'), '').trim();
      if (generatedText.isNotEmpty) {
        messages.add(ChatMessageModel(
          role: 'model',
          parts: [ChatPartModel(text: generatedText)],
        ));
        generating.value = false;
        _scrollToBottom();

        //Remove this for Text To Speech
        await _speakResponse(generatedText);

      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate response');
    }
  }

  Future<void> _speakResponse(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.3); // Higher pitch to approximate anime voice
    await flutterTts.setSpeechRate(0.9); // Slightly slower rate for a calm, controlled tone
    await flutterTts.speak(text);
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
