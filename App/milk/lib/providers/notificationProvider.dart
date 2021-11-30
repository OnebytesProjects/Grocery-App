import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier{
  int size = 0;

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth _auth = FirebaseAuth.instance;


  Future<double> getsize() async{
    var notification = 0.0;
    QuerySnapshot snapshot = await users.doc(_auth.currentUser?.uid).collection('notifications').get();
    if(snapshot == null){
      size = 0;
    }
    snapshot.docs.forEach((doc) {
      size = snapshot.size;
      notifyListeners();
    });
    return notification;
    }
}