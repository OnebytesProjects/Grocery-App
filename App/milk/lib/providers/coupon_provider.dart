

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier{
  late bool expired;
  late DocumentSnapshot document;
  double discountrate = 0.0;

  Future<DocumentSnapshot> getCouponDetails(title)async{
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('coupons').doc(title).get();

    if(document.exists){
      CheckExpiry(document);
    }
    return document;
  }

  CheckExpiry(DocumentSnapshot document){
    DateTime date = document.data()['Expiry'].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if(dateDiff <0){
      this.expired = true;
      notifyListeners();
    }
    else{
      this.document = document;
      this.expired = false;
      this.discountrate = document.data()['discountRate'];
      notifyListeners();
    }
  }
}