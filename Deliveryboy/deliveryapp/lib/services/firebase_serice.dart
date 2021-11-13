

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{
  CollectionReference dman = FirebaseFirestore.instance.collection('deliveryBoy');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');


}