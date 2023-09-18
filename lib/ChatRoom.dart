import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ChatRoom extends StatefulWidget {
  final String userEmail;
  ChatRoom({required this.userEmail});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}
class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();
  CollectionReference chatCollection = FirebaseFirestore.instance.collection('chat_messages');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2647),
      appBar: AppBar(
        backgroundColor: Color(0xFF144272),
        title: Text(
          'Chat with ${widget.userEmail}',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatCollection
                  .where('participants', arrayContainsAny: [FirebaseAuth.instance.currentUser?.email, widget.userEmail])
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No messages found.'),
                  );
                }
                List<Widget> messageWidgets = [];
                final messages = snapshot.data!.docs;
                for (var message in messages) {
                  final participants = message['participants'];
                  final messageText = message['message'];
                  final senderEmail = message['sender'];
                  if (participants.contains(FirebaseAuth.instance.currentUser?.email) &&
                      participants.contains(widget.userEmail)) {
                    final isCurrentUser = senderEmail == FirebaseAuth.instance.currentUser?.email;
                    final alignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                    messageWidgets.add(
                      Column(
                        crossAxisAlignment: alignment,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isCurrentUser ? Colors.blue : Colors.green,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              '$senderEmail:\n$messageText',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return ListView(
                  children: messageWidgets,
                );
              },
            ),
          ),
          Padding(
            padding:EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void sendMessage() {
    String messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      chatCollection.add({
        'sender': FirebaseAuth.instance.currentUser?.email,
        'participants': [FirebaseAuth.instance.currentUser?.email, widget.userEmail],
        'message': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    }
  }
}
