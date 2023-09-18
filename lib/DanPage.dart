import 'package:flutter/material.dart';
import 'navbar.dart';
import 'Lendpage.dart';
import 'BorrowPage.dart';
import 'LanPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'ChatScreen.dart';

class DanPage extends StatefulWidget {
  DanPage({super.key});

  @override
  State<DanPage> createState() => _DanPageState();
}

class _DanPageState extends State<DanPage> {
  TextEditingController ItemTitle = new TextEditingController();

  TextEditingController ItemDescription = new TextEditingController();

  File? imageFile;

  _openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      if (await image.length() > 1024 * 1024) {
        // Image size is greater than 1MB, show a message or handle accordingly
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Image Size Too Large"),
              content: Text(
                  "Please select an image that is less than 1MB in size."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
      else {
        setState(() {
          imageFile = image; // Set the imageFile variable
        });
      }
    }
    else {
    }
  }

  _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      if (await image.length() > 1024 * 1024) {
        // Image size is greater than 1MB, show a message or handle accordingly
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Image Size Too Large"),
              content: Text(
                  "Please select an image that is less than 1MB in size."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
      else {
        setState(() {
          imageFile = image; // Set the imageFile variable
        });
      }
    }
    else {
    }
  }

  var option=['Sale','Rent','Required'];

  var _current='Sale';

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
                'Post A Request',
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
            label: 'Lend',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: (){

              },
              child: Image(
                image: AssetImage('assets/pos1.png'),
              ),
            ),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BorrowPage()),
                );
              },
              child: Image(
                image: AssetImage('assets/bor2.png'),
              ),
            ),
            label: 'Borrow',
          ),
        ],
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(40.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Color(0xFF113962),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LanPage()),
                          );
                        },
                        child:Text(
                          'लेन',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontFamily: 'Poppins-Regular'
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: (){

                        },
                        child:Text(
                          'देन',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0,
                              fontFamily: 'Poppins-Regular'
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10,10,10,5),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF0A2647),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    controller: ItemTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily:'Poppins-Regular',
                    ),
                    decoration:InputDecoration (
                      hintText: 'Item Title (Keep it short).....',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10.0,10,10,5),
                  padding: EdgeInsets.fromLTRB(20.0,20,20,50),
                  decoration: BoxDecoration(
                    color: Color(0xFF0A2647),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    controller: ItemDescription,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily:'Poppins-Regular',
                    ),
                    decoration:InputDecoration (
                      hintText: 'Item Description.....',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text(
                        'Post the item for:',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily:'Poppins-Regular',
                        ),
                      ),
                      SizedBox(width:20),
                      DropdownButton<String>(
                        borderRadius:BorderRadius.circular(20),
                        dropdownColor: Color(0xFF113962),
                        items: option.map((String dropDownStringItem){
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (String? newValueSelected){
                          setState((){
                            this._current=newValueSelected!;
                          });
                        },
                        value: _current,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily:'Poppins-Regular',
                        ),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(30.0,0,30,10),
                    padding: EdgeInsets.fromLTRB(20.0,20,20,50),
                    decoration: BoxDecoration(
                      color: Color(0xFF0A2647),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Upload your Image',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontFamily:'Poppins-Regular',
                          ),
                        ),
                        Text(
                          'Maximum 1 MB image size allowed',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.white,
                            fontFamily:'Poppins-Regular',
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: imageFile != null
                              ? Image.file(
                            imageFile!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                              :Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                width: 50,
                                height:50,
                                child: IconButton(
                                  onPressed: (){
                                    _openGallery();
                                  },
                                  icon:Image(
                                    image:AssetImage('assets/cloud.png'),
                                    width: 50,
                                    height:50,
                                  ),
                                ),
                              ),
                              Text(
                                'Select image to upload',
                                style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.white,
                                  fontFamily:'Poppins-Regular',
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.white,
                                  fontFamily:'Poppins-Regular',
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0,0),
                                width: 50.0,
                                height: 50.0,
                                child: IconButton(
                                  onPressed: (){
                                    _openCamera();
                                  },
                                  icon:ClipOval(
                                    child: Container(
                                      color: Color(0xFFFBB400),
                                      child: Image(
                                        image: AssetImage('assets/camera.png'),
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height:10),
                        TextButton(
                          onPressed: () async {
                            FirebaseFirestore firestore = FirebaseFirestore.instance;
                            FirebaseAuth auth = FirebaseAuth.instance;
                            User?user=auth.currentUser;
                            if (user != null) {
                              String userEmail = user.email ?? "";
                              Map<String, dynamic> data = {
                                "ItemTitle": ItemTitle.text,
                                "ItemDescription": ItemDescription.text,
                                "UserEmail": userEmail,
                                "SelectedDropdownoption":_current,
                                "Timestamp": FieldValue.serverTimestamp(),
                              };
                              try {
                                if (imageFile != null) {
                                  final firebase_storage
                                      .Reference storageReference =
                                  firebase_storage.FirebaseStorage.instance
                                      .ref()
                                      .child('images/${DateTime
                                      .now()
                                      .millisecondsSinceEpoch}.jpg');
                                  await storageReference.putFile(imageFile!);
                                  String imageUrl = await storageReference
                                      .getDownloadURL();
                                  data["ImageUrl"] = imageUrl;
                                }
                                await firestore.collection("lend").add(
                                    data);
                                await firestore.collection("post").add(
                                    data);

                                ItemTitle.clear();
                                ItemDescription.clear();
                                imageFile = null;
                                setState(() {
                                  _current = 'Sale';
                                });
                              } catch (e) {
                                print("Error adding document: $e");
                              }
                            }
                          },
                          child:Container(
                            padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF0D9393),
                            ),
                            child: Text(
                              'POST',
                              style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.white,
                                fontFamily:'Poppins-Regular',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
