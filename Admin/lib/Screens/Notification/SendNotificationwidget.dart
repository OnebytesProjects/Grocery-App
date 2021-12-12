import 'package:admin/Services/notificationservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SendNotificaton extends StatefulWidget {
  const SendNotificaton({Key? key}) : super(key: key);

  @override
  _SendNotificatonState createState() => _SendNotificatonState();
}

class _SendNotificatonState extends State<SendNotificaton> {
  final _formKey = GlobalKey<FormState>();
  var notificationcontroller = TextEditingController();
  String notificationData = '';
  NotifiationService _services = NotifiationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Form(
        key: _formKey,
        child: Container(
            height: 75,
            width: double.infinity,
            color: Colors.black87,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: notificationcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Notification';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          labelText: 'Notification',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    FlatButton(
                      color: Colors.orange,
                      child: Text(
                        'Send Notification',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            this.notificationData = notificationcontroller.text;
                          });
                          //update admin
                          _services.notifications.doc('Admin').set({
                            'user':'Admin',
                          });
                          _services.notifications.doc('Admin').collection('notifications').add({
                            'content':notificationData,
                          });

                          //user update
                          FirebaseFirestore.instance
                              .collection('users')
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              UpdateUserNotification(doc['id'].toString(),notificationData);
                            });
                          });
                          EasyLoading.showSuccess('Notification Published');
                          notificationcontroller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
  UpdateUserNotification(userid,data){

    _services.users.doc(userid).collection('notifications').add({
      'content':data,
    });

    // DocumentReference docs =
    // _services.users.doc(userid);
    // docs.update({
    //   'Notification' : FieldValue.arrayUnion([
    //     {'content': data}
    //   ]),
    // });
  }
}
