import 'package:flutter/material.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'MyPosts.dart';
import 'feedback.dart';
import 'Donate.dart';
import 'Develop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  var count;
  var count2;
  String? userEmail;

  Future<void> logout(BuildContext context) async{
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (error) {
      print("Logout Error: $error");
    }
  }
  Future<void> getUserEmail() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          userEmail = user.email;
        });
      }
    } catch (e) {
      print("Error fetching user email: $e");
    }
  }

  Future<void> getBorrowCount() async{
    try{
      CollectionReference borrowCollection=FirebaseFirestore.instance.collection('borrow');
      borrowCollection.snapshots().listen((QuerySnapshot querySnapshot) {
        setState(() {
          count = querySnapshot.docs.length; // Update count when data changes
        });
      });
    }
    catch(e){
      print("Error fetching borrow count");
    }
  }
  Future<void> getLendCount() async{
    try{
      CollectionReference lendCollection=FirebaseFirestore.instance.collection('lend');
      lendCollection.snapshots().listen((QuerySnapshot querySnapshot) {
        setState(() {
          count2 = querySnapshot.docs.length; // Update count2 when data changes
        });
      });
    }
    catch(e){
      print("Error fetching lend count");
    }
  }
  @override
  void initState(){
    super.initState();
    getBorrowCount();
    getLendCount();
    getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF0A2647),
      child: ListView(
        padding: EdgeInsets.fromLTRB(20,40, 0, 0),
        children: [
          Text(
            'Hi',
            style: TextStyle(
              fontFamily:'Poppins-Regular',
              fontSize: 30.0,
              color: Colors.white,
            ),
          ),
          Text(
            '$userEmail!',
            style: TextStyle(
              fontFamily:'Poppins-Regular',
              fontSize: 20.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height:20),
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children:[
                  CircularPercentIndicator(
                    radius: 100.0, // Adjust the size as needed
                    lineWidth: 10.0, // Adjust the thickness of the circle
                    percent: count != null ? count / (count+count2) : 0.0, // Adjust maxCount as needed
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Color(0xFFA74FFF), // Change the background color
                    progressColor: Color(0xFFFA00FF), // Change the foreground color
                    center: ClipOval(
                      child: Image(
                        image: AssetImage('assets/image9.png'),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '$count2 देन',
                    style: TextStyle(
                      color: Color(0xFFA74FFF),
                      fontSize: 20,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                  Text(
                    '$count लेन',
                    style: TextStyle(
                      color: Color(0xFFFA00FF),
                      fontSize: 20,
                      fontFamily: 'Poppins-Regular',
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50),
          Row(
            children: [
              Container(
                width: 25.0,
                height: 25.0,
                child: Image(
                  image: AssetImage('assets/img.png'),
                ),
              ),
              SizedBox(width: 10.0),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPosts()),
                  );
                },
                child: Text(
                  'My Posts',
                  style: TextStyle(
                    fontFamily:'Poppins-Regular',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 25.0,
                height: 25.0,
                child: Image(
                  image: AssetImage('assets/img2.png'),
                ),
              ),
              SizedBox(width: 10.0),
              TextButton(
                onPressed: (){

                },
                child: Text(
                  'Bookmarked Posts',
                  style: TextStyle(
                    fontFamily:'Poppins-Regular',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 25.0,
                height: 25.0,
                child: Image(
                  image: AssetImage('assets/img4.png'),
                ),
              ),
              SizedBox(width: 10.0),
              TextButton(
                onPressed: (){

                },
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily:'Poppins-Regular',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 25.0,
                height: 25.0,
                child: Image(
                  image: AssetImage('assets/img1.png'),
                ),
              ),
              SizedBox(width: 10.0),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => feedback()),
                  );
                },
                child: Text(
                  'Feedback',
                  style: TextStyle(
                    fontFamily:'Poppins-Regular',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 25.0,
                height: 25.0,
                child: Image(
                  image: AssetImage('assets/img3.png'),
                ),
              ),
              SizedBox(width: 10.0),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Donate()),
                  );
                },
                child: Text(
                  'Donate',
                  style: TextStyle(
                    fontFamily:'Poppins-Regular',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 25.0,
                height: 25.0,
                child: Image(
                  image: AssetImage('assets/img5.png'),
                ),
              ),
              SizedBox(width: 10.0),
              TextButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Developer()),
                  );
                },
                child: Text(
                  'Developers',
                  style: TextStyle(
                    fontFamily:'Poppins-Regular',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 25.0,
                height: 25.0,
                child: Image(
                  image: AssetImage('assets/img6.png'),
                ),
              ),
              SizedBox(width: 10.0),
              TextButton(
                onPressed: (){
                  logout(context);
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily:'Poppins-Regular',
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Divider(
              color: Colors.white,
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
