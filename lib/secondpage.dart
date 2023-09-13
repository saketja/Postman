import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'thirdpage.dart';
import 'fourthpage.dart';
import 'ChatScreen.dart';
import 'dart:ui';

class SecondPage extends StatefulWidget {
  SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2647),
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Color(0xFF144272),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Lend Requests',
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF144272),
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: (){

                },
                child: Image(
                  image: AssetImage('assets/Group.png'),
                ),
              ),
            label: 'Lend',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FourthPage()),
                );
              },
              child: Image(
                image: AssetImage('assets/pos.png'),
              ),
            ),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdPage()),
                );
              },
              child: Image(
                image: AssetImage('assets/borrow.png'),
              ),
            ),
            label: 'Borrow',
          ),
        ],
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('lend').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final List<Map<String, dynamic>> borrowedItems = [];
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            for (final document in documents) {
              final data = document.data() as Map<String, dynamic>;
              borrowedItems.add(data);
            }
          }
          return Center(
            child: ListView.builder(
              itemCount: borrowedItems.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(20.0),
                      padding: EdgeInsets.fromLTRB(2, 5, 2, 5),
                      decoration: BoxDecoration(
                        color: Color(0xFF144272),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Image(
                                  image: AssetImage('assets/image.png'),
                                  width: 20,
                                  height:20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  borrowedItems[index]['UserEmail'],
                                  style: TextStyle(
                                    fontFamily:'Poppins-Regular',
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width:5),
                                Text(
                                  'an hour ago',
                                  style: TextStyle(
                                    fontFamily:'Poppins-Regular',
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height:10),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(borrowedItems[index]['ImageUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        borrowedItems[index]['ItemTitle'],
                                        style: TextStyle(
                                          fontFamily:'Poppins-Regular',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: Text(
                                        '< ${borrowedItems[index]['SelectedDropdownoption']}',
                                        style: TextStyle(
                                          fontFamily:'Poppins-Regular',
                                          color: Color(0xFF5AF5FF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                  child:Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      borrowedItems[index]['ItemDescription'],
                                      style: TextStyle(
                                        fontFamily:'Poppins-Regular',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                  });
                                },
                                icon:Image(
                                  image: AssetImage('assets/bookmark.png'),
                                  width:20,
                                  height:20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                  });
                                },
                                icon:Image(
                                  image: AssetImage('assets/share.png'),
                                  width:20,
                                  height:20,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

