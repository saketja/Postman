import 'package:flutter/material.dart';
import 'navbar.dart';
import 'secondpage.dart';
import 'fourthpage.dart';
import 'ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}
class _ThirdPageState extends State<ThirdPage> {
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
                  MaterialPageRoute(builder: (context) => SecondPage()),
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
