

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService{
  CollectionReference order = FirebaseFirestore.instance.collection('orders');

  Future<DocumentReference> saveorder(Map<String,dynamic>data){
    var result = order.add(
      data
    );
    return result;
  }
}