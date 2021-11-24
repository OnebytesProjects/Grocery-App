

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier{
  late bool expired;
  late DocumentSnapshot document;
  int discountrate = 0;

  Future<DocumentSnapshot> getCouponDetails(title)async{
    DocumentSnapshot document = await FirebaseFirestore.instance.collection('coupons').doc(title).get();

    if(document.exists){
      CheckExpiry(document);
      print('Exist');
    }
    return document;
  }

  CheckExpiry(DocumentSnapshot document){
    DateTime date = document['Expiry'].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if(dateDiff < 0){
      print(dateDiff);
      this.expired = true;
      notifyListeners();
    }
    else{
      this.document = document;
      this.expired = false;
      this.discountrate = document['discountRate'];
      notifyListeners();
    }
  }
}