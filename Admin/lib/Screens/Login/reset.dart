import 'package:admin/Screens/Login/LoginScreen.dart';
import 'package:admin/Services/Firebase_Services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Reset extends StatefulWidget {
  const Reset({Key? key}) : super(key: key);
  static const String id = 'Reset';

  @override
  _ResetState createState() => _ResetState();
}

class _ResetState extends State<Reset> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
   String _mail = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(
                child: Text(
                  "Connection error",
                ));
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff444444), Colors.white],
                    stops: [1.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 0.0)),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 250,
                  child: Card(
                    elevation: 6,
                    shape: Border.all(color: Colors.white, width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    'Reset Password',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Username';
                                      }
                                      setState(() {
                                        _mail = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Mail Id',
                                      prefixIcon: Icon(Icons.person),
                                      contentPadding: EdgeInsets.only(
                                          left: 20, right: 20),
                                      border: OutlineInputBorder(),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2)),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: FlatButton(
                                    onPressed: () async {
                                      if(_formKey.currentState!.validate()){
                                        reset(_mail.trim());
                                      }
                                    },
                                    color: Theme.of(context).primaryColor,
                                    child: Text(
                                      'Reset Password',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(child: Text("Loading"),);
        },
      ),
      bottomSheet: Container(
        height: 20,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Text("Developed By OneBytes")
        ),
      )
      ,);
  }


  Future reset(_username) async{

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _username);
      EasyLoading.showSuccess("Check your mail to reset password");
      Navigator.pushReplacementNamed(context, LoginScreen.id);

    } on FirebaseAuthException catch (e) {
      EasyLoading.showError('Check The mail id you enterd');
    }

  }
}
