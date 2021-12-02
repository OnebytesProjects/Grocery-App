import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milk/providers/notificationProvider.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var _notificationProvider = Provider.of<NotificationProvider>(context);
    return SizedBox(
      child: AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          height: 100,
          width: 50,
          child: StreamBuilder<QuerySnapshot>(
            stream: users.doc(_auth.currentUser?.uid).collection('notifications').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              _notificationProvider.getsize();
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if(!snapshot.hasData){
                return Center(child: Text('No Notifications'),);
              }

              if(snapshot.hasData){
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:BorderSide(width: 2.0, color: Colors.black45),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(data['content']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: (){
                              DeleteNotification(_auth.currentUser?.uid,document.id);
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }

              return Center(child: Text('No Notifications'),);

            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  DeleteNotification(userId,docId){
    users.doc(userId).collection('notifications').doc(docId).delete();
  }


}
