

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService{
  CollectionReference order = FirebaseFirestore.instance.collection('orders');
  CollectionReference subscription = FirebaseFirestore.instance.collection('subscription');
  User user = FirebaseAuth.instance.currentUser;

  Future<DocumentReference> saveorder(Map<String,dynamic>data){
    var result = order.add(
      data
    );
    return result;
  }

  Future<DocumentReference> saveSubscription(Map<String,dynamic>data){
    var result = subscription.add(
        data
    );
    return result;
  }

}