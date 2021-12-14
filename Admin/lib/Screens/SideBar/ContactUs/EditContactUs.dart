import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditContactUS extends StatefulWidget {
  EditContactUS({Key? key}) : super(key: key);

  @override
  _EditContactUSState createState() => _EditContactUSState();
}

class _EditContactUSState extends State<EditContactUS> {
  final _formKey = GlobalKey<FormState>();
  var content = TextEditingController();
  FirebaseServices _services = FirebaseServices();

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('sidebarcontent')
        .doc('ContactUs')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          this.content.text = documentSnapshot['Content'];
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Contact Us'),
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
                    TextFormField(
                      controller: content,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Content';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        labelText: 'Contact Us Content',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                EasyLoading.show(status: 'Please wait..');
                                _services
                                    .updateSideBarContent(
                                        content: content.text,
                                        title: 'ContactUs')
                                    .then((value) {
                                  EasyLoading.showSuccess(
                                      'Updated Successfully');
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
