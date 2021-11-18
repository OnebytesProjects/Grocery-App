import 'dart:html';

import 'package:admin/Screens/Home/Inventory/updateInventory.dart';
import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  var docid ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Inventory'),
        backgroundColor: Colors.black87,
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
                        'Product',
                      ),
                      Text(
                        'Min Qantity',
                      ),
                      Text(
                        'Max Quantity',
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
          stream: _services.products.snapshots(),
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
                    docid = document.id;
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
                                    data['productName'],
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    data['Inventory_min_qty'].toString(),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    data['Inventory_max_qty'].toString(),
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
    return PopupMenuButton<String>(
        onSelected: (String value){
          if(value == 'update'){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateInventory(
                      title:  data['productName'],
                      minqty: data['Inventory_min_qty'],
                      maxqty: data['Inventory_max_qty'],
                      dataid: docid,
                    )));
          }
        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem(
            value: 'update',
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Update Inventory'),
            ),),
        ]);
  }
}
