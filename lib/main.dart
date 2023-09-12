import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'secondpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Home(),
  ),
  );
}
class Home extends StatelessWidget {
  Home({super.key});

  void _handleGoogleSignIn(BuildContext context) async{
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

        final User? user = authResult.user;
        if (user != null) {
          final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

          if (!userSnapshot.exists) {
            final existingUserQuery = await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: user.email)
                .get();

            if (existingUserQuery.docs.isEmpty) {
              await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                'email': user.email,
              });
            }
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondPage()),
          );
        }
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  Future<void> logout(BuildContext context) async{
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      // You can also sign the user out of Firebase, if needed.
      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()), // Replace LoginPage with your actual login page.
      );
    } catch (error) {
      print("Logout Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2647),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0,89.8,0,0),
              child: Image(
                image: AssetImage('assets/app1.png'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 51.4, 0,0),
              child: Text(
                'BORROW',
                style: TextStyle(
                  fontSize:70.37,
                  fontFamily:'EuphoriaScript',
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(image: AssetImage('assets/Vector1.png'),
                  ),
                  Positioned(
                    top: 0,
                    child: Image(
                      image: AssetImage('assets/background.png'),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      color: Colors.black.withOpacity(0),
                      child: Text(
                        'Log in to your Account',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: 'Poppins-Regular'
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 240,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                        color: Color(0xFF0A2647),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                width: 30,
                                height: 30,
                                color: Colors.white,
                                child: Image(
                                  image: AssetImage('assets/google.png'),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            TextButton(
                              onPressed: (){
                                _handleGoogleSignIn(context);
                              },
                              child:Text(
                                'Login with Google',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontFamily: 'Poppins-Regular'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
