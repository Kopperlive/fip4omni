import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fip_my_version/core/core.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late Future<List<Chat>> _chats;

  @override
  void initState() {
    super.initState();
    _chats = fetchChats(); // Fetch chats when the widget is created
  }

Future<List<Chat>> fetchChats() async {
  final response = await http.get(Uri.parse('$protocol://$domain/api/v1/chat/'), headers: headers);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((chat) => Chat.fromJson(chat)).toList();
  } else {
    throw Exception('Failed to load chats from API');
  }
}

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: FutureBuilder<List<Chat>>(
        future: _chats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No chats found."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final chat = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(chat.title[0]), // Just a simple avatar with the chat's title initial
                  ),
                  title: Text(chat.title),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/chatScreen',
                      arguments: {'chatId': chat.id, 'chatName': chat.title, 'userId': 2},
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateChatPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Create New Chat',
      ),
    );
  }
}