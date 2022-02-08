import 'package:admin/Screens/Deliveryboy/Add_Deliveryboy.dart';
import 'package:admin/Screens/Deliveryboy/UpdateDeliveryboy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Services/Firebase_Services.dart';

class Deliveryboyscreen extends StatefulWidget {
  const Deliveryboyscreen({Key? key}) : super(key: key);

  @override
  _DeliveryboyscreenState createState() => _DeliveryboyscreenState();
}

class _DeliveryboyscreenState extends State<Deliveryboyscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Deliveryboy'),
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
                          'Add Delivery boy',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddDeliveryboy()));
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
                        'Name',
                      ),
                      Text(
                        'Email',
                      ),
                      Text(
                        'Password',
                      ),
                      Text(
                        'Mobile',
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
                 child: DeliveryBList(),
              )
            ],
          )),
    );
  }
  Widget DeliveryBList() {
    FirebaseServices _services = FirebaseServices();

    return Container(
        child: StreamBuilder(
          stream: _services.deliveryboy.snapshots(),
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
                                    data['email'],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    data['password'],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    data['mobile'],
                                  ),
                                ),
                                popUpButton(data,context),
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
  Widget popUpButton(data,BuildContext context){
    FirebaseServices _services = FirebaseServices();
    return PopupMenuButton<String>(
        onSelected: (String value){
          if(value == 'edit'){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateDeliiveryboy(
                      name:  data['name'],
                      email: data['email'],
                      password: data['password'],
                      mobile: data['mobile'],

                    )));
          }
          if(value == 'delete'){
            _services.deleteDeliveryMan(id: data['email']);
          }
        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Preview/Edit'),
            ),),
          const PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete_outlined),
              title: Text('Delete Deliveryman'),
            ),),
        ]);
  }
}
