

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService{
  CollectionReference order = FirebaseFirestore.instance.collection('orders');
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  CollectionReference subscription = FirebaseFirestore.instance.collection('subscription');
  User? user = FirebaseAuth.instance.currentUser;

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

  Future<void>deleteCart()async{
    final result = await cart.doc(user?.uid).collection('products').get().then((snapshot){
      for(DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
  }

  Future<void>checkData()async{
    final snapshot = await cart.doc(user?.uid).collection('products').get();
    if(snapshot.docs.length==0){
      cart.doc(user?.uid).delete();
    }
  }

}