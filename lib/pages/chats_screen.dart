import 'package:flutter/material.dart';
import 'package:fip_my_version/core/core.dart'; // Ensure this is correctly imported

class ChatsScreen extends StatelessWidget {
  final List<Chat> chats = [
    Chat(
      id: '1',
      created: DateTime.now(),
      updated: DateTime.now(),
      deleted: DateTime.now(),
      header: 'Chief Accountant',
      participants: [1, 2],
      messages: [
        Message(
          id: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          deletedAt: DateTime.now(),
          text: 'Please, confirm your reports!',
          user: 1,
          chat: 1,
        ),
      ],
      imageUrl: 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/e03a4e56-5e74-4518-8e39-55ee84ebe63b/d48k7li-d19abdf2-e7c6-46ce-8961-ad2c3cf8923e.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2UwM2E0ZTU2LTVlNzQtNDUxOC04ZTM5LTU1ZWU4NGViZTYzYlwvZDQ4azdsaS1kMTlhYmRmMi1lN2M2LTQ2Y2UtODk2MS1hZDJjM2NmODkyM2UucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.q_5wRoriPiLKhWEKT73DxzpeaSkwESJL83T1PuYXFQw',
    ),
    Chat(
      id: '2',
      created: DateTime.now().subtract(Duration(days: 20)),
      updated: DateTime.now().subtract(Duration(days: 20)),
      deleted: DateTime.now().subtract(Duration(days: 20)),
      header: 'My bro',
      participants: [1, 3],
      messages: [
        Message(
          id: 2,
          createdAt: DateTime.now().subtract(Duration(days: 4)),
          updatedAt: DateTime.now().subtract(Duration(days: 4)),
          deletedAt: DateTime.now().subtract(Duration(days: 4)),
          text: 'Hey, what\'s up?',
          user: 3,
          chat: 2,
        ),
      ],
      imageUrl: 'https://i.redd.it/3ntdykbuoi271.jpg'
      )
    // Add more Chat instances as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              color: Color(0xff000000),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
              border: Border.all(color: Color(0x4d9e9e9e), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                  child:

                      ///***If you have exported images you must have to copy those images in assets/images directory.
                      Image(
                    image: AssetImage("assets/images/omni_logo_sign_in.png"),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width * 0.1,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Turdieva Dilnaza Dilmuratovna",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 22,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 0, 15),
                    child: Text(
                      "Messages",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 22,
                        color: Color(0xff000000),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                      color: Color(0xff212435),
                      iconSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                var chat = chats[index];
                var lastMessage = chat.messages.isNotEmpty ? chat.messages.last : null;
                var now = DateTime.now();
                String formattedTime;

                if (lastMessage != null) {
                  var difference = now.difference(lastMessage.createdAt);

                  if (difference.inDays == 0) {
                    formattedTime = DateFormat('HH:mm').format(lastMessage.createdAt);
                  } else if (difference.inDays == 1) {
                    formattedTime = 'Yesterday';
                  } else {
                    formattedTime = DateFormat('EEEE').format(lastMessage.createdAt);
                  }
                } else {
                  formattedTime = 'No messages';
                }

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chat.imageUrl),
                  ),
                  title: Text(
                    chat.header,
                    style: TextStyle(
                      color: Color(0xffc5a000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    lastMessage != null ? lastMessage.text : "No messages",
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(
                    formattedTime,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/chatScreen');
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle "start a chat" action
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.edit),
      ),
    );
  }
}
