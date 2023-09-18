import 'package:flutter/material.dart';
import 'Custom_App_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';

class BookmarkPosts extends StatefulWidget {
  const BookmarkPosts({super.key});

  @override
  State<BookmarkPosts> createState() => _BookmarkPostsState();
}

class _BookmarkPostsState extends State<BookmarkPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2647),
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: CustomAppBar(
          title: 'Bookmark Posts',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookmarked').snapshots(),
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
          final User? user = FirebaseAuth.instance.currentUser;
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            for (final document in documents) {
              final data = document.data() as Map<String, dynamic>;
              if (user != null && data['UserEmail'] == user.email) {
                borrowedItems.add(data);
              }
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                  image: AssetImage('assets/image.png'),
                                  width: 20,
                                  height: 20,
                                ),
                                Text(
                                  borrowedItems[index]['BorrowedItemData']
                                          ['UserEmail'] ??
                                      '',
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                    borrowedItems[index]['Timestamp'] != null
                                        ? borrowedItems[index]['Timestamp']
                                            .toDate()
                                            .toString()
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
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(borrowedItems[index]
                                        ['BorrowedItemData']['ImageUrl'] ??
                                    ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        borrowedItems[index]['BorrowedItemData']
                                                ['ItemTitle'] ??
                                            '',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: Text(
                                        '< ${borrowedItems[index]['BorrowedItemData']['SelectedDropdownoption'] ?? ''}',
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
                                      borrowedItems[index]['BorrowedItemData']
                                              ['ItemDescription'] ??
                                          '',
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
                                onPressed: () {},
                                icon: Image(
                                  image: AssetImage('assets/bookmark.png'),
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Share.share(
                                    'Check out this post:'
                                        '\nTitle:${borrowedItems[index]['BorrowedItemData']['ItemTitle']}'
                                        '\nDescription:${borrowedItems[index]['BorrowedItemData']['ItemDescription']}'
                                        '\nEmail_Id:${borrowedItems[index]['BorrowedItemData']['UserEmail']}'
                                        '\nTime:${borrowedItems[index]['Timestamp'].toDate().toString()}'
                                        '\nImage_Url:${borrowedItems[index]['BorrowedItemData']['ImageUrl']}',
                                  );
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
