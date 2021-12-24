import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  CollectionReference order = FirebaseFirestore.instance.collection('orders');
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  CollectionReference subscription =
      FirebaseFirestore.instance.collection('subscription');
  CollectionReference subscription2 =
      FirebaseFirestore.instance.collection('Activesubscription');
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveorder(Map<String, dynamic> data) {
    var result = order.doc(data['timestamp']).set(data);
    return result;
  }

  Future<void> saveSubscription(Map<String, dynamic> data) {
    var result = subscription.doc(data['timestamp']).set(data);
    subscription2.doc(data['timestamp']).set(data);
    users.doc(user?.uid).update({'vip': 'Yes'});
    return result;
  }

  Future<void> deleteCart() async {
    cart.doc(user?.uid).collection('products').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<void> checkData() async {
    final snapshot = await cart.doc(user?.uid).collection('products').get();
    if (snapshot.docs.isEmpty) {
      cart.doc(user?.uid).delete();
    }
  }
}
