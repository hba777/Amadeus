import 'package:chatbot_ai/bloc/chat_bloc.dart';
import 'package:chatbot_ai/models/chat_message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController promptController;
  late ScrollController scrollController = ScrollController();

  final chatBlock = ChatBloc();

  @override
  void initState() {
    // TODO: implement initState
    promptController = TextEditingController();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    promptController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Amadeus',style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: mq.width *.03),
            child: const Icon(Icons.image_search, color: Colors.white,),
          )
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBlock,
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    switch(state.runtimeType){
      case ChatSuccessState:
        List<ChatMessageModel> messages = (state as ChatSuccessState).messages;
        return Column(
          children: [
            Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length,
                    itemBuilder: (context, index){

                      // Determine alignment based on the message role
                      Alignment alignment = messages[index].role == 'model'
                          ? Alignment.centerLeft
                          : Alignment.centerRight;

                  return messages[index].role == 'model'?
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width *.02),
                    child: Align(
                      alignment: alignment,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: mq.height *.005),
                        padding: EdgeInsets.all(mq.width *.03),
                        constraints: BoxConstraints(
                            maxWidth: mq.width * .7
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mq.width *.04),
                            color: Colors.grey[700]
                        ),
                        child: Row(crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: mq.width * 0.05, // Adjust radius as needed
                              backgroundImage: AssetImage('assets/images/Amadeus.png'),
                            ),
                            SizedBox(width: mq.width *.02,),
                            Expanded(
                              child: Text(messages[index].parts.first.text!, style:
                              const TextStyle(
                                  color: Colors.white
                              ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),),
                    ),
                  ):
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mq.width *.02),
                    child: Align(
                      alignment: alignment,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: mq.height *.005),
                        padding: EdgeInsets.all(mq.width *.03),
                          constraints: BoxConstraints(
                            maxWidth: mq.width * .6
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mq.width *.04),
                            color: Colors.grey[700]
                          ),
                          child: Text(messages[index].parts.first.text!, style:
                            const TextStyle(
                              color: Colors.white
                            ),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),),
                    ),
                  );
                })
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: mq.width *.02),
              height: mq.height *.09,
              decoration: BoxDecoration(
                  color: Colors.grey[900]
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.white,
                      style: const TextStyle(
                          color: Colors.white
                      ),
                      controller: promptController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: mq.width *.05,vertical: mq.height *.02),
                          filled: true,
                          fillColor: Colors.grey,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(mq.width *.1)
                          )
                      ),
                    ),
                  ),
                  SizedBox(width: mq.width *.015,),

                  CircleAvatar(
                    radius: mq.width *.07,
                    backgroundColor: Colors.grey[900],
                    child: CircleAvatar(
                        radius: mq.width *.065,
                        backgroundColor: Colors.grey[800],
                        child: IconButton(onPressed: (){
                          if(promptController.text.isNotEmpty){
                            String message = promptController.text;
                            chatBlock.add(ChatGenerateNewTextMessageEvent(inputMessage: message));
                            promptController.clear();
                          }
                        }, icon: const Icon(Icons.send, color: Colors.white,))),
                  )
                ],
              ),
            )
          ],
        );


      default:
        return SizedBox();
    }
  },
),
    );
  }
}
