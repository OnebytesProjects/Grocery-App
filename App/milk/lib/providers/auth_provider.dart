import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';
import 'package:milk/services/RegistrationCheck.dart';
import 'package:milk/services/user_service.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOtp = '';
  String VerificationId = '';
  String error = '';
  UserServices _userServices = UserServices();
  late DocumentSnapshot snapshot;

  Future<void> verifyPhone(BuildContext context, String number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      print(e.code);
    };

    final smsOtpSend = (String verId, int resendToken) async {
      this.VerificationId = verId;
      //dialog to enter otp
      smsOtpDialog(context, number);
    };
    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsOtpSend,
          codeAutoRetrievalTimeout: (String verId) {
            this.VerificationId = verId;
          });
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> smsOtpDialog(BuildContext context, String number) {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification Code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter 6 Digt OTP Received',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  try {
                    AuthCredential phoneAuthCredentials =
                        PhoneAuthProvider.credential(
                            verificationId: VerificationId, smsCode: smsOtp);
                    final User user =
                        (await _auth.signInWithCredential(phoneAuthCredentials))
                            .user;

                    if (user != null) {
                      print('User Exist');
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(context, MainScreen.id);
                    } else {
                      print('User Does not Exist');
                      _createUser(id: user.uid, number: user.phoneNumber);
                    }
                  } catch (e) {
                    this.error = 'Invalid OTP';
                    notifyListeners();
                    print(error.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Done"),
              )
            ],
          );
        });
  }

  void _createUser({required String id, required String number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'name': 'null',
      'profilepic': 'null',
      'gender': 'null',
      'zip': 'null',
      'address': 'null',
      'referral': 'null',
      'mail': 'null',
      'myreferral': 'null',
      'preference': 'null',

    });
  }

  Future<DocumentSnapshot>getUserDetails()async{
    var result = await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser.uid).get();

    this.snapshot = result;
    notifyListeners();

    return result;
  }
}
