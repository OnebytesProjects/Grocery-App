import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService{
  CollectionReference order = FirebaseFirestore.instance.collection('orders');
  CollectionReference subs = FirebaseFirestore.instance.collection('subscription');
  Future<void>updateOrderStatus(documentId,status){
    var result = order.doc(documentId).update({
      'orderStatus' : status,
      'timestamp': DateTime.now().toString()
    });
    return result;
  }
  Future<void>updateSubscriptionStatus(documentId,status){
    var result = subs.doc(documentId).update({
      'deliveryboystatus' : status,
      'DeliveryDate': DateTime.now().add(Duration(days: 1)).toString(),
    });
    return result;
  }



}