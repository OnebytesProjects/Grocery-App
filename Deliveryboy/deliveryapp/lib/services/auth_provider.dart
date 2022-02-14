
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier{
  String error = '';

  Future<User?> loginVendor(email,password)async{
    notifyListeners();
    UserCredential userCredential;


    final User? user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      )).user;

    return user;
  }
}