import 'package:deliveryapp/HomeScreen/HomeScreen.dart';
import 'package:deliveryapp/services/auth_provider.dart';
import 'package:deliveryapp/services/firebase_serice.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const String id = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseService _service = FirebaseService();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  bool _visible = false;
  late String email;
  late String password;
  bool _loading = false;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('LOGIN',style: TextStyle(fontFamily: 'Anton',fontSize: 30),),
                            SizedBox(width: 20,),
                            Container(
                              height: 100,width: 100,
                                child: Image.asset('images/splscrn.jpg')),
                          ],
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _emailTextController,
                          validator: (value){
                            if(value!.isEmpty){
                              return 'Enter Email';
                            }
                            final bool _isValid=
                                EmailValidator.validate(_emailTextController.text);
                            if(!_isValid){
                              return 'Invalid Email Format';
                            }
                            setState(() {
                              email = value;
                            });
                            return null;
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,width: 2),
                              ),
                            focusColor: Theme.of(context).primaryColor,
                            )
                          ),
                        SizedBox(height: 20,),
                        TextFormField(
                            controller: _passwordTextController,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Enter Password';
                              }
                              if(value.length<6){
                                return 'Minimum 6 characters';
                              }
                              setState(() {
                                password = value;
                              });
                              return null;
                            },
                            obscureText: _visible == false ? true : false,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _visible ? Icon(Icons.visibility):Icon(Icons.visibility_off),
                                onPressed: (){
                                  setState(() {
                                    _visible = !_visible;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(),
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Password',
                              prefixIcon: Icon(Icons.vpn_key_outlined),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,width: 2),
                              ),
                              focusColor: Theme.of(context).primaryColor,
                            )
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              child: _loading?
                                  LinearProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                    backgroundColor: Colors.transparent,
                                    ):
                              Text('Login',
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                onPressed: (){
                                if(_formkey.currentState!.validate()){
                                  EasyLoading.show(status: 'Please wait..');
                                  _service.validateuser(email).then((value){
                                    if(value.exists){
                                      if(value.data()['password'] == password){
                                        _authData.loginVendor(email,password).then((credentials){
                                          if(credentials != null){
                                            EasyLoading.showSuccess('Logged in Successfully').then((value){
                                              Navigator.pushReplacementNamed(context, HomeScreen.id);
                                            });
                                          }else{
                                            EasyLoading.dismiss();
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_authData.error)));
                                          }
                                        });
                                      }else{
                                        EasyLoading.showError('Invalid Password');
                                      }
                                      EasyLoading.dismiss();
                                    }else{
                                      EasyLoading.showError('Invalid Email');
                                    }
                                  });
                                }
                                },
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
        ));
  }
}
