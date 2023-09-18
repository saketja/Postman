import 'package:flutter/material.dart';
import 'Lendpage.dart';
import 'BorrowPage.dart';
import 'LanPage.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final String image1;
  final String image2;
  final String image3;

  CustomBottomNavigationBar({
    required this.image1,
    required this.image2,
    required this.image3,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF144272),
      fixedColor: Colors.white,
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LendPage()),
              );
            },
            child: Image(
              image: AssetImage(image1),
            ),
          ),
          label: 'Lend',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanPage()),
              );
            },
            child: Image(
              image: AssetImage(image2),
            ),
          ),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BorrowPage()),
              );
            },
            child: Image(
              image: AssetImage(image3),
            ),
          ),
          label: 'Borrow',
        ),
      ],
    );
  }
}
