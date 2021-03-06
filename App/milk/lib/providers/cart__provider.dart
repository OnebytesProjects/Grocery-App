import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:milk/services/cart_services.dart';

class CartProvider with ChangeNotifier{
  CartService _cart = CartService();
  FirebaseAuth _auth = FirebaseAuth.instance;
  double subTotal = 0.0;
  int cartQty = 0;
  double deliverycharge  = 40;
  late QuerySnapshot snapshot;
  List cartList = [];
  List subscritionList = [];

  Future<double> getCartTotal()async{
    var cartTotal = 0.0;
    List _newList = [];
    QuerySnapshot snapshot = await _cart.cart.doc(_auth.currentUser?.uid).collection('products').get();
    if(snapshot == null){
      return cartTotal;
    }
    snapshot.docs.forEach((doc) {
      if(!_newList.contains(doc.data())){
        _newList.add(doc.data());
        cartList = _newList;
        notifyListeners();
        getSubscriptionDetails();
      }
      cartTotal = cartTotal+doc['total'];
    });
    subTotal = cartTotal;
    cartQty = snapshot.size;
    snapshot = snapshot;
    notifyListeners();
    return cartTotal;
  }
  getSubscriptionDetails()async{
    List _newsubList = [];
    QuerySnapshot snapshot = await _cart.cart.doc(_cart.user?.uid).collection('products').where('productName',isEqualTo: 'Milk').get();

    snapshot.docs.forEach((doc) {
      if(!_newsubList.contains(doc.data())){
        _newsubList.add(doc.data());
        subscritionList = _newsubList;
        notifyListeners();
      }
    });
  }
}