import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChatRoom.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchemail = new TextEditingController();
  List<String> searchResults = [];

  Future<void> searchUsers(String useremail) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where("email", isGreaterThanOrEqualTo: useremail)
          .where("email", isLessThan: useremail + 'z')
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        List<String> results = userSnapshot.docs
            .map((doc) => doc.get('email').toString())
            .toList();
        setState(() {
          searchResults = results;
        });
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    } catch (e) {
      print('Error fetching user email: $e');
      setState(() {
        searchResults.clear();
      });
    }
  }

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
                'Search Screen',
                style: TextStyle(
                  fontFamily: 'Poppins-Regular',
                  fontSize: 30.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0xFF2C74B3),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchemail,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        searchUsers(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Email Id....',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            searchResults[index],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(10),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatRoom(userEmail: searchResults[index]),
                                  ),
                                );
                                setState(() {
                                  searchemail.clear();
                                });
                              },
                              child: Text(
                                'Message',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
