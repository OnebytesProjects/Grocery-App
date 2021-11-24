

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CartService{
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  User? user = FirebaseAuth.instance.currentUser;

  Future<void>addToCart({data, qty, volume,total}){
    cart.doc(user?.uid).set({
      'user':user?.uid,
    });
    updateproducts(data['productid'], qty);
    return cart.doc(user?.uid).collection('products').add({
      'productName' : data['productName'],
      'productid' : data['productid'],
      'productImage': data['productImage'],
      'productVolume' : volume,
      'sellingPrice' : data['sellingPrice'],
      'qty' : qty,
      'total':total,
    });
  }

  Future<void>addToCartSubscription({data, qty, volume,total,subscription}){
    cart.doc(user?.uid).set({
      'user':user?.uid,
    });
    updateproducts(data['productid'], qty);
    return cart.doc(user?.uid).collection('products').add({
      'productName' : data['productName'],
      'productid' : data['productid'],
      'productImage': data['productImage'],
      'productVolume' : volume,
      'sellingPrice' : data['sellingPrice'],
      'qty' : qty,
      'total':total,
      'subscription':subscription,
    });

  }

  updateproducts(productid,qty){
    FirebaseFirestore.instance
        .collection('products')
        .doc(productid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        //print('Document data: ${documentSnapshot.data()}');
        products.doc(productid).update({
          'Inventory_max_qty': documentSnapshot['Inventory_max_qty'] - qty,
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  Future<void> updateCartqty({docId, qty,total})async{
    // Create a reference to the document the transaction will use
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user?.uid).collection('products').doc(docId);

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

  Future<void> removeFromCart({docId,qty,productid})async{
    cart.doc(user?.uid).collection('products').doc(docId).delete();

    FirebaseFirestore.instance
        .collection('products')
        .doc(productid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        //print('Document data: ${documentSnapshot.data()}');
        products.doc(productid).update({
          'Inventory_max_qty': documentSnapshot['Inventory_max_qty'] + qty,
        });
      }
    });
  }


}