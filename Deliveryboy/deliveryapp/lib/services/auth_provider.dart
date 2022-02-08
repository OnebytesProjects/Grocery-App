
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier{
  String error = '';

  Future<UserCredential> loginVendor(email,password)async{
    notifyListeners();
    UserCredential userCredential;

      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

    return userCredential;
  }
}