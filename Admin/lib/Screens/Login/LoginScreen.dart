import 'package:admin/Screens/Home/HomeScreen.dart';
import 'package:admin/Services/Firebase_Services.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


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
                gradient: LinearGradient(
                    colors: [Color(0xff444444), Colors.white],
                    stops: [1.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment(0.0, 0.0)),
              ),
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
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
                                    height: 20,
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
                            Row(
                              children: [
                                Expanded(
                                  child: FlatButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        UserCredential usercredentials = await FirebaseAuth.instance.signInAnonymously();
                                        progressDialog.show();
                                        _services.getAdminCredentials().then((value){
                                          value.docs.forEach((doc) {
                                            if(doc.get('username')==_username){
                                              if(doc.get('password')==_password){
                                                if(usercredentials.user!.uid!=null){
                                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>HomeScreen()));
                                                  return;
                                                }else{
                                                  progressDialog.dismiss();
                                                  _services.showMyDialog(
                                                    title: 'Login',
                                                    message: 'Login Failed',
                                                    context:context,
                                                  );
                                                }
                                              }else{
                                                progressDialog.dismiss();
                                                _services.showMyDialog(title: 'Alert',message: 'Invalid Credentials.Please Try Again',context: context);
                                              }
                                            }else{
                                              _services.showMyDialog(title: 'Alert',message: 'Invalid Credentials.Please Try Again',context: context);
                                            }
                                          });
                                        });
                                      }
                                    },
                                    color: Theme.of(context).primaryColor,
                                    child: Text(
                                      'Login',
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


}
