

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{
  CollectionReference dman = FirebaseFirestore.instance.collection('deliveryBoy');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference subscription = FirebaseFirestore.instance.collection('subscription');

  Future<DocumentSnapshot>validateuser(id)async{
    DocumentSnapshot result = await dman.doc(id).get();
    return result;
  }
}