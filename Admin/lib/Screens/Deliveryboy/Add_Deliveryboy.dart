import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddDeliveryboy extends StatefulWidget {
  const AddDeliveryboy({Key? key}) : super(key: key);

  @override
  _AddDeliveryboyState createState() => _AddDeliveryboyState();
}

class _AddDeliveryboyState extends State<AddDeliveryboy> {
  CollectionReference deliveryboy =FirebaseFirestore.instance.collection('deliveryBoy');
  final _formKey =GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var mobile = TextEditingController();
  String u_name = '';
  String u_mobile = '';
  String u_email = '';
  String u_pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Delivery Boy'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Name';
                    }
                    setState(() {
                      u_name = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Enter Name',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                TextFormField(
                  controller: email,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Email';
                    }
                    setState(() {
                      u_email=value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Enter Email',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Password';
                    }
                    if(value.length<6){
                      return 'Minimum 6 characters';
                    }
                    setState(() {
                      u_pass=value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Enter Password',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                TextFormField(
                  maxLength: 10,
                  controller: mobile,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Number';
                    }
                    setState(() {
                      u_mobile = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    prefixText: '+91',
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Enter Number',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: () async{
                          EasyLoading.show(status: 'Please wait..');
                          signup();
                          saveDetails();
                          Navigator.pop(context);
                          EasyLoading.showSuccess('Deliery boy created Successfully');
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future signup() async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> saveDetails() async {
    return deliveryboy.doc(email.text.trim()).set({
      'name': name.text.trim(),
      'mobile': mobile.text.trim(),
      'email': email.text.trim(),
      'password': password.text.trim(),
    });
  }
}

