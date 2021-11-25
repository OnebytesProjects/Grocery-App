import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService{
  CollectionReference product = FirebaseFirestore.instance.collection('products');
  CollectionReference order = FirebaseFirestore.instance.collection('orders');
  CollectionReference subscription = FirebaseFirestore.instance.collection('subscription');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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