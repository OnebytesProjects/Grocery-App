import 'package:admin/Screens/Notification/SendNotificationwidget.dart';
import 'package:admin/Services/notificationservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  NotifiationService _services = NotifiationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: DisplayNotifications(),
    );
  }
  DisplayNotifications(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.grey[400],
      child: Padding(
        padding: EdgeInsets.all(10),
        child:StreamBuilder<QuerySnapshot>(
          stream: _services.notifications.doc('Admin').collection('notifications').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(data['content']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){

                          DeleteNotification(document.id);
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        )
      ),
    );
  }
  DeleteNotification(docId){
    _services.notifications.doc('Admin').collection('notifications').doc(docId).delete();
  }
}
