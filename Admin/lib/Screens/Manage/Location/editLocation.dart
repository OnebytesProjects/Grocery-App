import 'package:admin/Services/Firebase_Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditLocation extends StatefulWidget {
  String code;
  String charge;
  var dataid;
  EditLocation({required this.code, required this.charge,required this.dataid});

  @override
  State<EditLocation> createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
  final _formKey =GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();

  var _pincode = TextEditingController();
  var _deliverycharge = TextEditingController();

  @override
  void initState() {
    this._pincode.text = widget.code;
    this._deliverycharge.text = widget.charge;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Edit  Pincode"),
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
                            _services.updatePincode(
                              code: _pincode.text,
                              charge: int.parse(_deliverycharge.text),
                              data: widget.dataid
                            ).then((value) {
                              Navigator.pop(context);
                              EasyLoading.showSuccess('Updated Pincode Successfully');
                            });
                          }
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

