import 'package:admin/Services/Firebase_Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UpdateInventory extends StatefulWidget {

  String title;
  String minqty;
  String maxqty;
  var dataid;

  UpdateInventory(
      {required this.title,
        required this.minqty,
        required this.maxqty,
        required this.dataid,});

  @override
  _UpdateInventoryState createState() => _UpdateInventoryState();
}

class _UpdateInventoryState extends State<UpdateInventory> {
  final _formKey =GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  var titleText = TextEditingController();
  var minqtyText = TextEditingController();
  var maxqtyText = TextEditingController();

  @override
  void initState() {
    this.titleText.text = widget.title;
    this.minqtyText.text = widget.minqty.toString();
    this.maxqtyText.text = widget.maxqty.toString();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Inventory'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Container(
            height: 250,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Product Name: ',style: TextStyle(fontWeight: FontWeight.bold),),
                        Text('${widget.title}'),
                      ],
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      controller: minqtyText,
                      keyboardType: TextInputType.number,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter Min Quantity';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        labelText: 'Min Quantity',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextFormField(
                      controller: maxqtyText,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter Max Quantity';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        labelText: 'Max Quantity',
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
                                _services.updateInventory(
                                  data: widget.dataid,
                                  minqty: int.parse(minqtyText.text),
                                  maxqty: int.parse(maxqtyText.text),
                                ).then((value) {
                                  EasyLoading.showSuccess('Updated coupon Successfully');
                                  Navigator.pop(context);
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
        ),
      ),
    );
  }
}

