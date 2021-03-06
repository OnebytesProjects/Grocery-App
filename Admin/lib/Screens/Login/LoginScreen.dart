import 'package:admin/Screens/Home/HomeScreen.dart';
import 'package:admin/Screens/Login/reset.dart';
import 'package:admin/Services/Firebase_Services.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
  static const String id = 'LoginScreen';
}

class _LoginScreenState extends State<LoginScreen> {



  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  late String _username ;
  late String _password ;



  @override
  Widget build(BuildContext context) {

    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

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
                image: DecorationImage(
                  image: AssetImage("images/2.jpg"),
                  fit: BoxFit.fill
                )
              ),
              child: Center(
                child: Container(
                  width: 450,
                  height: 400,
                  child: Card(
                    elevation: 6,
                    shape: Border.all(color: Colors.white, width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(
                                    'Admin Console',
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
                                        _username = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'UserName',
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
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Enter Password';
                                      }
                                      if (value.length < 6) {
                                        return 'Minimum 6 characters';
                                      }
                                      setState(() {
                                        _password = value;
                                      });
                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Minimum 6 Characters',
                                      prefixIcon: Icon(Icons.vpn_key_sharp),
                                      hintText: 'Password',
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
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    child: FlatButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          //email login
                                          EasyLoading.show(status: 'Please Wait');
                                          Login();
                                        }
                                      },
                                      color: Theme.of(context).primaryColor,
                                      child: Text(
                                        'Login',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            InkWell(
                              onTap:(){
                                Navigator.pushNamed(context, Reset.id);
                              },
                              child: Text("Forgot Password",style: TextStyle(color: Colors.grey),),
                            )
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
  Future Login() async{
    UserCredential userCredential;
    try {
       userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _username.trim(),
        password: _password.trim(),
      );
       if(userCredential.user!.uid!=null){
         Verifyuser(_username.trim());
       }
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError('Check Your Login Details');
    }

  }
  Future<void> Verifyuser(email) async {
    FirebaseFirestore.instance
        .collection('Admin')
        .doc(email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>HomeScreen()));
        EasyLoading.showSuccess("Welcome!");
      }else{
        EasyLoading.showError('Check Your Login Details');
      }
    });
  }

}