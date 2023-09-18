import 'package:flutter/material.dart';
import 'search.dart';
import 'Custom_App_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2647),
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: CustomAppBar(
          title:'Chat Screen',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Search()),
          );
        },
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Text(
            'Welcome to the Chat Screen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
