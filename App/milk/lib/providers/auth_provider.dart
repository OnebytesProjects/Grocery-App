import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';
import 'package:milk/Screens/HomeScreen/UserRegistration/UserRegistration.dart';
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
          final User? user =
              (await _auth.signInWithCredential(credential))
                  .user;

          FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              //check profile created
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, MainScreen.id);
            }
            else{
              //create profile
              Navigator.of(context).pop();
              _createUser(id: user!.uid, number: number);
              Navigator.pushReplacementNamed(context, UserRegistration.id);
            }
          });
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      print(e.code);
    };

    // final smsOtpSend = (String verId, int resendToken) async {
    //   this.VerificationId = verId;
    //   //dialog to enter otp
    //   smsOtpDialog(context, number);
    // };

    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: (String verificationId, int? resendToken) async {
            VerificationId = verificationId;
            smsOtpDialog(context, number);
          },
          codeAutoRetrievalTimeout: (String verId) {
            VerificationId = verId;
          });
    }catch(e){}
  }

  Future<dynamic> smsOtpDialog(BuildContext context, String number) {
    EasyLoading.dismiss();
    return showDialog(
      barrierDismissible: false,
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
            content: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value) {
                smsOtp = value;
              },
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  EasyLoading.show(status:'');
                  try {
                    AuthCredential phoneAuthCredentials =
                        PhoneAuthProvider.credential(
                            verificationId: VerificationId, smsCode: smsOtp);
                    final User? user =
                        (await _auth.signInWithCredential(phoneAuthCredentials))
                            .user;

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        //check profile created
                        Navigator.of(context).pop();
                        Navigator.pushReplacementNamed(context, MainScreen.id);
                      }
                      else{
                        //create profile
                        Navigator.of(context).pop();
                        _createUser(id: user!.uid, number: number);
                        Navigator.pushReplacementNamed(context, UserRegistration.id);
                      }
                    });
                    error = '';
                    // if (user != null) {
                    //   print('User Exist');
                    //   Navigator.of(context).pop();
                    //   //Navigator.pushReplacementNamed(context, MainScreen.id);
                    // } else {
                    //   print('User Does not Exist');
                    //   _createUser(id: user.uid, number: user.phoneNumber);
                    // }
                    EasyLoading.dismiss();
                  } catch (e) {
                    error = 'Invalid OTP';
                    notifyListeners();
                    EasyLoading.dismiss();
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
    var referal = id.substring(0,6);
    _userServices.createUserData({
      'id': id,
      'number': number,
      'name': 'null',
      'profilepic': 'null',
      'gender': 'null',
      'zip': 'null',
      'address': 'null',
      'referal': referal,
      'mail': 'null',
      'refered': 'null',
      'preference': 'Ring Door Bell',
      'pincode':'',
      'vip':'no'
    });

    _userServices.createReferalData({
      'referal': referal,
    },referal);
  }

  Future<DocumentSnapshot> getUserDetails() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get();

    snapshot = result;
    notifyListeners();

    return result;
  }

}
