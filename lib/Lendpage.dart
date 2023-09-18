import 'package:flutter/material.dart';
import 'navbar.dart';
import 'BorrowPage.dart';
import 'LanPage.dart';
import 'ChatScreen.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LendPage extends StatefulWidget {
  LendPage({super.key});

  @override
  State<LendPage> createState() => _LendPageState();
}

class _LendPageState extends State<LendPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> toggleBookmark(Map<String, dynamic> itemData) async {
    try {
      final User? user = _auth.currentUser;
      final String? userEmail = user?.email;

      final QuerySnapshot<Map<String, dynamic>> bookmarks = await FirebaseFirestore
          .instance
          .collection('bookmarked')
          .where('UserEmail', isEqualTo: userEmail)
          .where('BorrowedItemData', isEqualTo: itemData)
          .get();

      if (bookmarks.docs.isNotEmpty) {
        // Item is already bookmarked, remove it
        final docId = bookmarks.docs.first.id;
        await FirebaseFirestore.instance.collection('bookmarked').doc(docId).delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item removed from bookmarks!'),
          ),
        );
      } else {
        // Item is not bookmarked, add it to bookmarks
        await FirebaseFirestore.instance.collection('bookmarked').add({
          'UserEmail': userEmail,
          'BorrowedItemData': itemData,
          'Timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item bookmarked!'),
          ),
        );
      }
    } catch (e) {
      print('Error handling bookmark: $e');
    }
  }

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
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF144272),
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {},
              child: Image(
                image: AssetImage('assets/Group.png'),
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
                image: AssetImage('assets/pos.png'),
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
                image: AssetImage('assets/borrow.png'),
              ),
            ),
            label: 'Borrow',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
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
                final item = borrowedItems[index];
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage('assets/image.png'),
                                width: 20,
                                height: 20,
                              ),
                              Text(
                                borrowedItems[index]['UserEmail'],
                                style: TextStyle(
                                  fontFamily: 'Poppins-Regular',
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  borrowedItems[index]['Timestamp'] != null
                                      ? borrowedItems[index]['Timestamp'].toDate().toString()
                                      : 'No Timestamp',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
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
                                          fontFamily: 'Poppins-Regular',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: Text(
                                        '< ${borrowedItems[index]['SelectedDropdownoption']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          color: Color(0xFF5AF5FF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      borrowedItems[index]['ItemDescription'],
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Regular',
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
                                  toggleBookmark(item);
                                },
                                icon: Image(
                                  image: AssetImage('assets/bookmark.png'),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {});
                                },
                                icon: Image(
                                  image: AssetImage('assets/share.png'),
                                  width: 20,
                                  height: 20,
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