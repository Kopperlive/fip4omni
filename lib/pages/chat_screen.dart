import 'package:flutter/material.dart';
import 'package:fip_my_version/core/core.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> messages = [
    // Sample messages for illustration. Replace with your data source
    Message(
      id: 1,
      createdAt: DateTime.now().subtract(Duration(minutes: 1)),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      text: "How are you doing?",
      user: 2, // Assuming '2' is the ID of the other user
      chat: 1,
    ),
    Message(
      id: 2,
      createdAt: DateTime.now().subtract(Duration(days: 4)),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      text: "Yesterday's message",
      user: 1, // Assuming '1' is the ID of the current user
      chat: 1,
    ),
    // More messages...
  ];
  final TextEditingController _messageController = TextEditingController();
  final int currentUserId = 1; // Assuming '1' is the ID of the current user

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        messages.insert(
          0,
          Message(
            id: messages.length + 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            deletedAt: DateTime.now(),
            text: _messageController.text.trim(),
            user: currentUserId,
            chat: 1,
          ),
        );
        _messageController.clear();
      });
      // Implement your message sending logic here (e.g., send to server)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My bro", 
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold, 
        ),
        ),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true, // To keep the newest messages at the bottom
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var message = messages[index];
                var isCurrentUser = message.user == currentUserId;
                var alignment =
                    isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                var messageColor =
                    isCurrentUser ? Colors.lightBlueAccent : Colors.grey[300];
                var timestamp = DateFormat('HH:mm').format(message.createdAt);

                // Create a day divider if necessary
                Widget dayDivider;
                if (index == messages.length - 1 ||
                    (messages[index + 1].createdAt.day != message.createdAt.day)) {
                  var dividerText = DateFormat('yyyy-MM-dd').format(message.createdAt);
                  if (DateTime.now().difference(message.createdAt).inDays < 1) {
                    dividerText = 'Today';
                  } else if (DateTime.now().difference(message.createdAt).inDays == 1) {
                    dividerText = 'Yesterday';
                  } else {
                    dividerText = DateFormat('EEEE, MMM d').format(message.createdAt);
                  }

                  dayDivider = Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(dividerText),
                    ),
                  );
                } else {
                  dayDivider = SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: alignment,
                  children: [
                    dayDivider,
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      decoration: BoxDecoration(
                        color: messageColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(message.text),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                        bottom: 8.0,
                        left: 12.0,
                        right: 12.0,
                      ),
                      child: Text(
                        timestamp,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Send a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}