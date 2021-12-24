import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/HomeScreen/HomeScreen.dart';
import 'package:deliveryapp/services/UpdateAvaliable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          .doc('DeliveryBoyAppVersion')
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
         if(version == documentSnapshot['Version']){
           Navigator.pushReplacementNamed(context, HomeScreen.id);
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
