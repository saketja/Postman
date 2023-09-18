import 'package:flutter/material.dart';
import 'ChatScreen.dart';

class Donate extends StatelessWidget {
  const Donate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2647),
      appBar: AppBar(
        backgroundColor: Color(0xFF144272),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Donate',
                style: TextStyle(
                  fontFamily:'Poppins-Regular',
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              icon:Image(
                image: AssetImage('assets/chats.png'),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Image(
                image: AssetImage('assets/QRcode.jpg'),
              ),
            ),
            Text(
                'QR Code',
              style: TextStyle(
                fontSize: 20,
                color:Colors.white,
                fontFamily: 'Poppins-Regular',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
