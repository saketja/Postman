import 'package:flutter/material.dart';
import 'ChatScreen.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  CustomAppBar({super.key,required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF144272),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins-Regular',
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
            icon: Image(
              image: AssetImage('assets/chats.png'),
            ),
          ),
        ],
      ),
    );
  }
}
