import 'dart:developer';

import 'package:chatbot_ai/models/chat_message_model.dart';
import 'package:chatbot_ai/utils/constants.dart';
import 'package:dio/dio.dart';

class AmadeusRepo{

  static Future<String> chatTextGeneration(List<ChatMessageModel> previousMessages) async {
    try {
      Dio dio = Dio();

      final response = await dio.post(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}',
          data: {
            "contents": previousMessages.map((e) => e.toMap()).toList(),
            "generationConfig": {
              "temperature": 1,
              "topK": 64,
              "topP": 0.95,
              "maxOutputTokens": 8192,
              "responseMimeType": "text/plain"
            }
          }
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        var content = response.data['candidates']?.first['content']?['parts']?.first['text'];
        if (content != null) {
          return content;
        } else {
          throw Exception('Content not found in response');
        }
      } else {
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Error occurred during chat text generation');
    }
  }


}