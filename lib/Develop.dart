import 'package:flutter/material.dart';
import 'Custom_App_bar.dart';

class Developer extends StatelessWidget {
  const Developer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2647),
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: CustomAppBar(
          title:'Developers',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/app1.png'),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                  'Saket Jain',
                style: TextStyle(
                  fontSize:20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'f20220118@pilani.bits-pilani.ac.in',
                style: TextStyle(
                  fontSize:20,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                '2022A7PS0118P',
                style: TextStyle(
                  fontSize:20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
