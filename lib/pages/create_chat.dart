import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class CreateChatPage extends StatefulWidget {
  @override
  _CreateChatPageState createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  final TextEditingController _chatNameController = TextEditingController();

  @override
  void dispose() {
    _chatNameController.dispose();
    super.dispose();
  }

  void _createChat() {
    final String chatName = _chatNameController.text.trim();
    if (chatName.isNotEmpty) {
      // Call your API or logic to create a chat with the given name
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _createChat,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _chatNameController,
          decoration: InputDecoration(
            labelText: 'Chat Name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _createChat(),
        ),
      ),
    );
  }
}
