import 'package:flutter/material.dart';
import 'navbar.dart';
import 'Lendpage.dart';
import 'LanPage.dart';
import 'ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BorrowPage extends StatefulWidget {
  const BorrowPage({super.key});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {

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
                'Borrow Requests',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LendPage()),
                );
              },
              child: Image(
                image: AssetImage('assets/borrow3.png'),
              ),
            ),
            label:'Lend',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: (){
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
              onTap: (){

              },
              child: Image(
                image: AssetImage('assets/bor1.png'),
              ),
            ),
            label: 'Borrow',
          ),
        ],
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('borrow').snapshots(),
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
                      padding: EdgeInsets.fromLTRB(2,10,2,5),
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
                                height:20,
                              ),
                              Text(
                                borrowedItems[index]['UserEmail'],
                                style: TextStyle(
                                  fontFamily:'Poppins-Regular',
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width:5),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  borrowedItems[index]['Timestamp'] != null
                                      ? borrowedItems[index]['Timestamp'].toDate().toString()
                                      : 'No Timestamp',
                                  style: TextStyle(
                                    fontFamily:'Poppins-Regular',
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:10),
                          Container(
                            color: Color(0xFF113962),
                            child: Row(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(borrowedItems[index]['ImageUrl']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              borrowedItems[index]['ItemTitle'],
                                              style: TextStyle(
                                                fontFamily:'Poppins-Regular',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '< ${borrowedItems[index]['SelectedDropdownoption']}',
                                            style: TextStyle(
                                              fontFamily:'Poppins-Regular',
                                              color: Color(0xFF15FE64),
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        height: 120,
                                        padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                        child:Text(
                                          borrowedItems[index]['ItemDescription'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily:'Poppins-Regular',
                                          ),
                                        ),
                                      ),
                                    ],
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
                                icon:Image(
                                  image: AssetImage('assets/bookmark.png'),
                                  width:20,
                                  height:20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
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
