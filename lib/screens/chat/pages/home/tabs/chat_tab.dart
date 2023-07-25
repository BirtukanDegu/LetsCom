import 'package:flutter/material.dart';
import '../../home/tabs/components/story_list.dart';
import '../../home/tabs/components/chat_widget.dart';
import '../../../data/chat.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final chats = getChats();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            StoryList(),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Chats", style: theme.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),),
            ),
              Column(
                children: chats.map((e) => Column(
                  children: [
                    ChatWidget(chat: e),
                    chats.indexOf(e) != chats.length - 1 ? Divider(indent: 80, height: 1, endIndent: 16,) : SizedBox(),
                  ],
                )).toList(),
              ),
          ],
        ),
      ),
    );  
  }
}
