import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService{
  CollectionReference order = FirebaseFirestore.instance.collection('orders');

  Future<void>updateOrderStatus(documentId,status){
    var result = order.doc(documentId).update({
      'orderStatus' : status,
      'timestamp': DateTime.now().toString()
    });
    return result;
  }


}