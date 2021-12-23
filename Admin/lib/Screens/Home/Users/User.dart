import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
      ),
      body: Container(
          child: Column(
            children: [
              Divider(
                thickness: 3,
              ),
              Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Name',
                      ),
                      Text(
                        'Mobile Number',
                      ),
                      Text(
                        'Address',
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 3,
              ),
              Container(
                child: InventoryList(context),
              )
            ],
          )),
    );
  }

  Widget InventoryList(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return Container(
        child: StreamBuilder(
          stream: _services.users.where('NewLocation',isEqualTo: '').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    return Container(
                      height: 80,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Text(
                                    data['name'],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    data['number'].toString(),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    data['address'].toString(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

}
