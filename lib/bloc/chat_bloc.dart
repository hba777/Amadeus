import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatbot_ai/models/chat_message_model.dart';
import 'package:chatbot_ai/repos/chat_repository.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatSuccessState(messages: [])) {
    on<ChatGenerateNewTextMessageEvent>(chatGenerateNewTextMessageEvent);
  }



  List<ChatMessageModel> messages = [];

  FutureOr<void> chatGenerateNewTextMessageEvent(ChatGenerateNewTextMessageEvent event, Emitter<ChatState> emit) async {

    messages.add(ChatMessageModel(role: "user", parts: [
      ChatPartModel(text: event.inputMessage)
    ]));

    emit(ChatSuccessState(messages: messages));

    String generatedText = await AmadeusRepo.chatTextGeneration(messages);

    if(generatedText.isNotEmpty){
      messages.add(ChatMessageModel(role: 'model', parts: [
        ChatPartModel(text: generatedText)
      ]));

      emit(ChatSuccessState(messages: messages));

    }
  }
}

