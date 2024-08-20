import 'dart:io';

import 'package:chatbot_ai/models/chatController.dart';
import 'package:chatbot_ai/models/chat_message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:image_picker/image_picker.dart';

class GetHomeScreen extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());
  late TextEditingController promptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;
  List<String> images = [];
  GetHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Amadeus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: mq.width * .03),
            child: InkWell(
              onTap: () async {
                selectedImage = await _picker.pickImage(source: ImageSource.gallery);
                chatController.image.value = selectedImage;
              },
              child: const Icon(Icons.image_search, color: Colors.white),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  controller: chatController.scrollController,
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    // Determine alignment based on the message role
                    Alignment alignment = chatController.messages[index].role == 'model'
                        ? Alignment.centerLeft
                        : Alignment.centerRight;

                    return chatController.messages[index].role == 'model'
                        ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: mq.width * .02),
                      child: Align(
                        alignment: alignment,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: mq.height * .005),
                          padding: EdgeInsets.all(mq.width * .03),
                          constraints: BoxConstraints(maxWidth: mq.width * .7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mq.width * .04),
                            color: Colors.grey[700],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: mq.width * 0.05,
                                backgroundImage: const AssetImage('assets/images/Amadeus.png'),
                              ),
                              SizedBox(width: mq.width * .02),
                              Expanded(
                                child: Text(
                                  chatController.messages[index].parts.first.text,
                                  style: const TextStyle(color: Colors.white),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Padding(
                      padding: EdgeInsets.symmetric(horizontal: mq.width * .02),
                      child: Align(
                        alignment: alignment,
                        child: chatController.messages[index].imagePath != null  ?
                            Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.file(File(chatController.messages[index].imagePath!)),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: mq.height * .005),
                                  padding: EdgeInsets.all(mq.width * .03),
                                  constraints: BoxConstraints(maxWidth: mq.width * .6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(mq.width * .04),
                                    color: Colors.grey[700],
                                  ),
                                  child: Text(
                                    chatController.messages[index].parts.first.text,
                                    style: const TextStyle(color: Colors.white),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ],
                            ) : Container(
                          margin: EdgeInsets.symmetric(vertical: mq.height * .005),
                          padding: EdgeInsets.all(mq.width * .03),
                          constraints: BoxConstraints(maxWidth: mq.width * .6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mq.width * .04),
                            color: Colors.grey[700],
                          ),
                          child: Text(
                            chatController.messages[index].parts.first.text!,
                            style: const TextStyle(color: Colors.white),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Obx(() {
              if (chatController.generating.value) {
                return SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.asset('assets/Thinking.json'),
                );
              } else {
                return const SizedBox.shrink(); // Return an empty widget if not generating
              }
            }),

            //TextField and Image
            Container(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .02),
              decoration: BoxDecoration(
                color: Colors.grey[900],
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() {
                      return chatController.image.value != null
                          ? Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image.file(File(chatController.image.value!.path)),
                        ),
                      )
                          : SizedBox.shrink();
                    }),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            controller: promptController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: mq.width * .05,
                                vertical: mq.height * .02,
                              ),
                              filled: true,
                              fillColor: Colors.grey,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(mq.width * .1),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: mq.width * .015),
                        CircleAvatar(
                          radius: mq.width * .07,
                          backgroundColor: Colors.grey[900],
                          child: CircleAvatar(
                            radius: mq.width * .065,
                            backgroundColor: Colors.grey[800],
                            child: IconButton(
                              onPressed: () {
                                if (promptController.text.isNotEmpty) {
                                  String message = promptController.text;

                                  if (chatController.image.value != null) {
                                    final file = File(chatController.image.value!.path);

                                    chatController.textAndImage(message, file);
                                    chatController.image.value = null;
                                  } else {
                                    chatController.addUserMessage(message);
                                  }
                                  promptController.clear();
                                }
                              },
                              icon: const Icon(Icons.send, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

}
