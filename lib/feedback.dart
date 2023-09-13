import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ChatScreen.dart';

class feedback extends StatefulWidget {
  const feedback({super.key});

  @override
  State<feedback> createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {

  TextEditingController feedback=TextEditingController();
  double rating=0.0;

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
                'Feedback Page',
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
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              width: double.infinity,
              color: Color(0xFF113962),
              height: 200,
              child: TextField(
                controller: feedback,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily:'Poppins-Regular',
                ),
                decoration:InputDecoration (
                  hintText: 'Write a Feedback',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newrating) {
                setState(() {
                  rating=newrating;
                });
              },
            ),
            TextButton(
                onPressed: () async{
                  String feedbackText = feedback.text;
                  FirebaseFirestore firestore=FirebaseFirestore.instance;
                  FirebaseAuth auth = FirebaseAuth.instance;
                  User?user=auth.currentUser;
                  if (user != null) {
                    String userEmail = user.email ?? "";
                    Map<String, dynamic> data = {
                      "UserEmail": userEmail,
                      "Feedback": feedbackText,
                      "Rating": rating,
                    };
                    try {
                      await firestore.collection("Feedback").add(data);
                      feedback.clear();
                      setState(() {
                        rating = 0.0; // Reset the rating after submission
                      });
                    }catch (e) {
                      print("Error adding document: $e");
                    }
                  }
                },
                child:Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF0D9393),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily:'Poppins-Regular',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
