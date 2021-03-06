import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService{
  CollectionReference product = FirebaseFirestore.instance.collection('products');
  CollectionReference order = FirebaseFirestore.instance.collection('orders');
  CollectionReference subscription = FirebaseFirestore.instance.collection('subscription');
  CollectionReference subscription2 = FirebaseFirestore.instance.collection('Activesubscription');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String error = '';

  Future<void>updateOrderStatus(documentId,status){
    var result = order.doc(documentId).update({
      'orderStatus' : status,
    });
    return result;
  }
  Future<void>updateSubscriptionStatus(documentId,status){
    //condition to assign delivery date
    var result = subscription.doc(documentId).update({
      'orderStatus' : status,
      'startdate': DateTime.now().toString(),
      'endDate': DateTime.now().add(Duration(days: 30)).toString(),
      'DeliveryDate' : DateTime.now().toString(),
    });
    subscription2.doc(documentId).update({
      'orderStatus' : status,
      'startdate': DateTime.now().toString(),
      'endDate': DateTime.now().add(Duration(days: 30)).toString(),
      'DeliveryDate' : DateTime.now().toString(),
    });
    return result;
  }
  Future<void>endSubscriptionStatus(documentId,status,userid){
    var result = subscription.doc(documentId).update({
      'orderStatus' : status,
      'endDate': DateTime.now().toString(),
      'deliveryboystatus':'',
      'deliverBoy':{
        'name' : '',
        'phone' : '',
      },
      'DeliveryDate' : '',
    });
    //delete
    subscription2.doc(documentId).delete();
    //userdata
    users
        .doc(userid)
        .update({'vip': 'no'});
    return result;
  }

  Future<void>reduceInventoryStock(document,documentId,docdata){
    var result = product.doc(documentId).update({
      'startdate': DateTime.now().toString(),
      'endDate': DateTime.now().add(Duration(days: 30)).toString()
    });
    return result;
  }



}