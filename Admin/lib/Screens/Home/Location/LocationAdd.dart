import 'package:admin/Services/Firebase_Services.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LocationAdd extends StatefulWidget {
  const LocationAdd({Key? key}) : super(key: key);

  @override
  _LocationAddState createState() => _LocationAddState();
}

class _LocationAddState extends State<LocationAdd> {
  final _formKey =GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();

  var _pincode = TextEditingController();
  var _deliverycharge = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Add Pincode"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _pincode,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Pincode';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Pincode',
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                TextFormField(
                  controller: _deliverycharge,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Delivery Charge';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Delivery Charge',
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
                          if(_formKey.currentState!.validate()){
                            EasyLoading.show(status: 'Please wait..');
                            _services.savePincode(
                              setpincode: _pincode.text,
                              deliverycharge: int.parse(_deliverycharge.text),
                            ).then((value) {
                              Navigator.pop(context);
                              EasyLoading.showSuccess('Saved Pincode Successfully');
                            });
                          }
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
}
