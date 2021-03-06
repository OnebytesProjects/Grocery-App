import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ReferalProvider with ChangeNotifier {
  bool exist = false;
  String referalid= '';

  Future<DocumentSnapshot> getReferalDetails(title) async {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('referal').doc(title).get();

    if (document.exists) {
      exist = true;
    }
    else{
      exist = false;
    }
    return document;
  }

}
