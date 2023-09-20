import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Custom_App_bar.dart';
import 'package:share/share.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2647),
      appBar: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: CustomAppBar(
          title:'My Posts',
        ),
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('post').snapshots(),
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
          final List<Map<String, dynamic>> PostItems = [];
          final User? user = FirebaseAuth.instance.currentUser;
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            for (final document in documents) {
              final data = document.data() as Map<String, dynamic>;
              if (user != null && data['UserEmail'] == user.email) {
                PostItems.add(data);
              }
            }
          }

          return Center(
            child: ListView.builder(
              itemCount: PostItems.length,
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
                          Row(
                            children: [
                              Image(
                                image: AssetImage('assets/image.png'),
                                width: 20,
                                height:20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                PostItems[index]['UserEmail'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily:'Poppins-Regular',
                                ),
                              ),
                              SizedBox(width:5),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                  PostItems[index]['Timestamp'] != null
                                      ? PostItems[index]['Timestamp']
                                      .toDate()
                                      .toString()
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
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(PostItems[index]['ImageUrl']),
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
                                        PostItems[index]['ItemTitle'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily:'Poppins-Regular',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 5.0),
                                      child: Text(
                                        '< ${PostItems[index]['SelectedDropdownoption']}',
                                        style: TextStyle(
                                          color: Color(0xFF5AF5FF),
                                          fontFamily:'Poppins-Regular',
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
                                      PostItems[index]['ItemDescription'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily:'Poppins-Regular',
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
                                },
                                icon:Image(
                                  image: AssetImage('assets/bookmark.png'),
                                  width:20,
                                  height:20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Share.share(
                                    'Check out this post:'
                                        '\nTitle:${PostItems[index]['ItemTitle']}'
                                        '\nDescription:${PostItems[index]['ItemDescription']}'
                                        '\nEmail_Id:${PostItems[index]['UserEmail']}'
                                        '\nTime:${PostItems[index]['Timestamp'].toDate().toString()}'
                                        '\nImage_Url:${PostItems[index]['ImageUrl']}',
                                  );
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
