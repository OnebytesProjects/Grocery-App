import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Services/Firebase_Services.dart';

class UpdateDeliiveryboy extends StatefulWidget {
  String name;
  String email;
  String password;
  String mobile;

  UpdateDeliiveryboy(
      {required this.name,
        required this.email,
        required this.password,
        required this.mobile,});

  @override
  _UpdateDeliiveryboyState createState() => _UpdateDeliiveryboyState();
}

class _UpdateDeliiveryboyState extends State<UpdateDeliiveryboy> {
  final _formKey =GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var mobile = TextEditingController();

  @override
  void initState() {
    this.name.text = widget.name;
    this.email.text = widget.email;
    this.password.text = widget.password;
    this.mobile.text = widget.mobile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Delivery Boy'),
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
                        onPressed: (){
                          EasyLoading.show(status: 'Please wait..');
                          _services.updateDeliveryboy(
                              name: name.text,
                              email: email.text,
                              password: password.text,
                              mobile: mobile.text,

                          ).then((value) {
                            EasyLoading.showSuccess('Updated Deliveryboy Data Successfully');
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'Update',
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

}
