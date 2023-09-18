import 'package:flutter/material.dart';
import 'Custom_App_bar.dart';
class Donate extends StatelessWidget {
  const Donate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2647),
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: CustomAppBar(
          title:'Donate',
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
