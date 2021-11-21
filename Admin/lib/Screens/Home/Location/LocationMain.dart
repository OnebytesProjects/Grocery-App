import 'package:admin/Screens/Home/Location/LocationAdd.dart';
import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LocationScreenMain extends StatefulWidget {
  const LocationScreenMain({Key? key}) : super(key: key);

  @override
  _LocationScreenMainState createState() => _LocationScreenMainState();
}

class _LocationScreenMainState extends State<LocationScreenMain> {
  String defaultscreen = '1';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Pincode'),
        backgroundColor: Colors.black87,
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
                          'Add New Pincode',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationAdd()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 3,
              ),
              Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Pincode',
                      ),
                      Text(
                        'Delivery Charge',
                      ),
                      Text(
                        'Options',
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 3,
              ),
              Container(
                child: pincodeList(),
              )
            ],
          )),
    );
  }

  Widget pincodeList() {
    FirebaseServices _services = FirebaseServices();

    return Container(
        child: StreamBuilder(
          stream: _services.pincode.snapshots(),
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
                                    data['pincode'],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    data['deliverycharge'].toString(),
                                  ),
                                ),
                                popUpButton(data),
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
  Widget popUpButton(data){
    FirebaseServices _services = FirebaseServices();
    return PopupMenuButton<String>(
        onSelected: (String value){
          if(value == 'delete'){
            _services.deletePincode(id: data['pincode']);
          }
        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete_outlined),
              title: Text('Delete Pincode'),
            ),),
        ]);
  }
}

