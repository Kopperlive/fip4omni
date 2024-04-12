import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fip_my_version/core/core.dart' as core;
import 'package:uuid/uuid.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  final int chatId;
  final String chatName;
  final int userId;

  const ChatPage({
    Key? key,
    required this.chatId,
    required this.chatName,
    required this.userId,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  late final types.User _user;  // declare as late final
  final TextEditingController _textController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _user = types.User(id: widget.userId.toString());  // initialize here
    fetchMessages();
    startPeriodicFetch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startPeriodicFetch() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) => fetchMessages());
  }

  bool _isSameDay(DateTime date1, DateTime? date2) {
    if (date2 == null) return false;
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Future<void> fetchMessages() async {
    final response = await http.get(
      Uri.parse('${core.protocol}://${core.domain}/api/v1/message/?chat=${widget.chatId}'),
      headers: core.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = core.json.decode(response.body);
      List<types.Message> chatMessages = [];
      DateTime? previousMessageDate;

      for (var messageJson in jsonResponse) {
        final coreMessage = core.Message.fromJson(messageJson);
        final DateTime messageDate = coreMessage.createdAt;

        if (previousMessageDate == null || !_isSameDay(messageDate, previousMessageDate)) {
          final dividerText = DateFormat('MMMM d').format(messageDate);
          chatMessages.add(types.CustomMessage(
            id: const Uuid().v4(),
            metadata: {'text': dividerText},
            createdAt: messageDate.millisecondsSinceEpoch,
            author: types.User(id: 'divider'),
          ));
        }

        chatMessages.add(types.TextMessage(
          author: types.User(id: coreMessage.userId.toString()),
          createdAt: messageDate.millisecondsSinceEpoch,
          id: coreMessage.id.toString(),
          text: coreMessage.text,
        ));

        previousMessageDate = messageDate;
      }

      setState(() {
        _messages = chatMessages.reversed.toList();
      });
    } else {
      // Handle the error case
    }
  }

  void _handleSendPressed(types.PartialText message) {
    final text = message.text.trim();
    if (text.isEmpty) {
      return;
    }

    final tempMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: text,
    );

    setState(() {
      _messages.insert(0, tempMessage);
    });

    _sendTextMessage(text);
  }

  Future<void> _sendTextMessage(String text) async {
    final response = await http.post(
      Uri.parse('${core.protocol}://${core.domain}/api/v1/message/'),
      headers: core.headers,
      body: core.json.encode({
        'text': text,
        'user': widget.userId,
        'chat': widget.chatId,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = core.json.decode(response.body);
      final messageId = responseData['id'];
      final index = _messages.indexWhere((m) => m.id == const Uuid().v4().toString());
      if (index != -1) {
        setState(() {
          _messages[index] = _messages[index].copyWith(id: messageId.toString());
        });
      }
    } else {
      setState(() {
        _messages.removeWhere((m) => m.id == const Uuid().v4().toString());
      });
    }
    _textController.clear();
  }

  
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.chatName),
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              if (message is types.TextMessage) {
                bool isMine = message.author.id == _user.id;
                return Align(
                  alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * (2 / 3), // Width constraint
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isMine ? Theme.of(context).primaryColor : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: isMine ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(message.createdAt ?? 0),
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: isMine ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (message is types.CustomMessage) {
                // ... CustomMessage logic
              }
              else{
                
              }
              // Handle any other message types if necessary
              return SizedBox.shrink(); // Placeholder for other message types
            },
          ),
        ),
        _buildInputField(),
      ],
    ),
  );
}

  Widget _buildInputField() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3.0,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _textController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
              onPressed: () => _handleSendPressed(types.PartialText(text: _textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isNotEmpty) {
      _handleSendPressed(types.PartialText(text: text));
    }
  }
}