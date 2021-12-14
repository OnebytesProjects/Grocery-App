import 'package:admin/Screens/SideBar/Cancelation/EditCancellation.dart';
import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cancelation extends StatefulWidget {
  Cancelation({Key? key}) : super(key: key);

  @override
  _CancelationState createState() => _CancelationState();
}

class _CancelationState extends State<Cancelation> {
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancellation And Refund'),
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      'Edit Content',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCancelation()));
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 3,
          ),
          Text(
            'Content',
          ),
          Divider(
            thickness: 3,
          ),
          Container(
            child: Content(),
          )
        ],
      )),
    );
  }

  Content() {
    return Container(
      height: 250,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: _services.sidebarcontent
            .where('type', isEqualTo: 'Cancellation')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['Content']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
