import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';
import 'package:milk/services/UpdateAvailable.dart';
import 'WelcomeScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String version = '1.0.0';
  @override
  void initState() {

    Timer(Duration(seconds: 3), () {

      FirebaseFirestore.instance
          .collection('version')
          .doc('SuperMarketAppVersion')
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if(version == documentSnapshot['Version']){
            //Navigator.pushReplacementNamed(context, WelcomeScreen.id);

            FirebaseAuth.instance.authStateChanges().listen((User? user) {
              if (user == null) {
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              } else {
                Navigator.pushReplacementNamed(context, MainScreen.id);
              }
            });
          }else{
            Navigator.pushReplacementNamed(context, UpdateAvailable.id);
          }
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(50),
          child: Image.asset("images/splscrn.png"),
        ),
      ),
      bottomSheet: Container(
        height: 50,
        width: double.infinity,
        child: Center(child: Text('Developed By OneBytes'),),
      ),
    );
  }
}
