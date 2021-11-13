

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService{
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User user = FirebaseAuth.instance.currentUser;

  Future<void>addToCart({data, qty, volume,checkbox,total}){
    cart.doc(user.uid).set({
      'user':user.uid,
    });
    return cart.doc(user.uid).collection('products').add({
      'productName' : data['productName'],
      'productid' : data['productid'],
      'productImage': data['productImage'],
      'productVolume' : volume,
      'sellingPrice' : data['sellingPrice'],
      'qty' : qty,
      'checkbox':checkbox,
      'total':total,
    });
  }

  Future<void> updateCartqty({docId, qty,total})async{
    // Create a reference to the document the transaction will use
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid).collection('products').doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("Product does not exist in Cart!");
      }

      // Perform an update on the document
      transaction.update(documentReference, {'qty': qty,'total':total});

      // Return the new count
      return qty;
    })
        .then((value) => print("Cart qty updated"))
        .catchError((error) => print("Failed to update cart: $error"));
  }

  Future<void> deleteCart()async{
    cart.doc(user.uid).delete();
  }


  Future<void> removeFromCart({docId})async{
    cart.doc(user.uid).collection('products').doc(docId).delete();
  }
}