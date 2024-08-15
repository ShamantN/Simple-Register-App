// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstfiremusic/home_screen.dart';
import 'package:firstfiremusic/instructions.dart';
import 'package:firstfiremusic/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailFocusNode = FocusNode();
  final pwdFocusNode = FocusNode();
  final userFocusNode = FocusNode();
  String email = "";
  String userName = "";
  String password = "";
  final authInst = FirebaseAuth.instance;
  final dbInstance = FirebaseFirestore.instance;
  bool showPassword = true;
  bool doneLoading = false;
  bool onSuccess = false;
  bool onError = false;
  bool pwdError = false;
  bool onEmail = false;
  bool onPwd = false;
  bool onUsername = false;
  String errorMessage = "";
  String successMessage = "";
  String pwdErrorMessage = "";
  File? _image;

  @override
  Widget build(BuildContext context) {
    Future<void> _pickImage(ImageSource source) async {
      final pickedFile = await ImagePicker().pickImage(source: source);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    }

    Future uploadImage() async {
      if (_image == null) return;

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$fileName');

      UploadTask uploadTask = storageReference.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('images').add({
        'url': downloadURL,
        'uploaded_at': Timestamp.now(),
      });

      setState(() {
        _image = null;
      });
    }

    void removeKeyboard() {
      FocusScope.of(context).unfocus();
    }

    return VideoBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
                color: Colors.grey.shade900,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.indigoAccent,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      padding: EdgeInsets.only(left: 30),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Instructions()));
                      },
                      child: Text(
                        "ABOUT",
                        style: TextStyle(
                            fontFamily: 'Helvetica',
                            fontSize: 15,
                            color: Colors.white70),
                      ),
                    )
                  ];
                })
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Padding(
            padding: EdgeInsets.only(left: 140),
            child: onSuccess
                ? Text("Continue",
                    style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent))
                : Text(
                    "Sign Up",
                    style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigoAccent),
                  ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: GestureDetector(
                  onDoubleTap: () {
                    _pickImage(ImageSource.camera);
                    HapticFeedback.vibrate();
                  },
                  onLongPress: () {
                    _pickImage(ImageSource.gallery);
                    HapticFeedback.vibrate();
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[900],
                    radius: 60,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.indigoAccent,
                          )
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: TextField(
                  focusNode: emailFocusNode,
                  style:
                      TextStyle(color: Colors.white70, fontFamily: 'Helvetica'),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.white70,
                  onChanged: (enteredEmail) {
                    email = enteredEmail;
                  },
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(pwdFocusNode);
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.mail,
                        color: Colors.cyan,
                      ),
                      hintText: "E-mail ID",
                      hintStyle: TextStyle(
                          fontFamily: 'Helvetica',
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              if (onError)
                Text(
                  errorMessage,
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 9),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: TextField(
                  focusNode: pwdFocusNode,
                  style:
                      TextStyle(color: Colors.white70, fontFamily: 'Helvetica'),
                  obscureText: showPassword,
                  onChanged: (enteredPwd) {
                    password = enteredPwd;
                  },
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(userFocusNode);
                  },
                  cursorColor: Colors.white70,
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                          child: showPassword
                              ? Icon(
                                  Icons.visibility,
                                  color: Colors.cyan,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Colors.cyan,
                                )),
                      hintText: "Password",
                      hintStyle: TextStyle(
                          fontFamily: 'Helvetica',
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              if (pwdError)
                Text(
                  pwdErrorMessage,
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 9),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: TextField(
                  focusNode: userFocusNode,
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Helvetica',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.white70,
                  onChanged: (enteredName) {
                    userName = enteredName;
                  },
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.person,
                        color: Colors.cyan,
                      ),
                      hintText: "Username",
                      hintStyle: TextStyle(
                          fontFamily: 'Helvetica',
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              if (onSuccess)
                Text(
                  successMessage,
                  style: TextStyle(
                      fontFamily: 'Helvetica',
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 9),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 52, top: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: RawMaterialButton(
                      onPressed: () async {
                        HapticFeedback.heavyImpact();
                        removeKeyboard();
                        if (onSuccess) {
                          uploadImage();
                        }

                        try {
                          setState(() {
                            doneLoading = true;
                          });
                          await authInst.createUserWithEmailAndPassword(
                              email: email, password: password);
                          successMessage = "Account created successfully!";
                          onSuccess = true;
                          onError = false;
                          pwdError = false;
                        } on FirebaseAuthException catch (error) {
                          if (error.code == 'email-already-in-use') {
                            errorMessage =
                                "This email is already in use by another account.";
                          } else if (error.code == 'weak-password') {
                            pwdErrorMessage =
                                "The password must be at least 6 characters.";
                            pwdError = true;
                          }
                          onSuccess = false;
                          onError = true;
                          onEmail = true;
                        }
                        setState(() {
                          doneLoading = false;
                        });

                        if (authInst.currentUser != null) {
                          dbInstance
                              .collection("users")
                              .doc(authInst.currentUser?.uid)
                              .set({
                            "E-mail Address": email.toString(),
                            "Password": password.toString(),
                            "Username": userName.toString()
                          });
                        }
                      },
                      fillColor: Colors.indigoAccent,
                      child: Icon(Icons.done_all_sharp)),
                ),
              ),
              if (doneLoading)
                LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.indigoAccent, size: 30),
            ],
          ),
        ),
        floatingActionButton: onSuccess
            ? FloatingActionButton(
                backgroundColor: Colors.indigoAccent,
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
