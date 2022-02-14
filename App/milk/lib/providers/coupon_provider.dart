

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier{
  late bool expired;
  late DocumentSnapshot document;
  int discountrate = 0;
  bool type = false;

  Future<DocumentSnapshot> getCouponDetails(title)async{
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('coupons').doc(title).get();

    if(document.exists){
      CheckExpiry(document);
    }
    return document;
  }

  CheckExpiry(DocumentSnapshot document){
    DateTime date = document['Expiry'].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if(dateDiff < 0){

      expired = true;
      notifyListeners();
    }
    else{
      document = document;
      expired = false;
      discountrate = document['discountRate'];
      type = document['type'];
      notifyListeners();
    }
  }
}