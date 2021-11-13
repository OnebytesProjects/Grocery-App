import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryBoyList extends StatefulWidget {
  DocumentSnapshot document;
  DeliveryBoyList(this.document);

  @override
  State<DeliveryBoyList> createState() => _DeliveryBoyListState();
}

class _DeliveryBoyListState extends State<DeliveryBoyList> {
  FirebaseServices _services = FirebaseServices();

  void _launchURL(number) async =>
      await canLaunch(number) ? await launch(number) : throw 'Could not call to $number';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.black87,
              title: Text('Delivery Man List'),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _services.deliveryboy.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                          return ListTile(
                            onTap: (){
                              EasyLoading.show(status: 'Assigning deliveryBoy');
                              _services.selectDeliveryMan(widget.document.id, data['name'], data['mobile'].toString(),'Delivery Man Assigned').then((value) {
                                EasyLoading.showSuccess('Deliveryman Assigned');
                                Navigator.pop(context);
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Container(color: Colors.grey,),
                            ),
                            title: Text(data['name']),
                            subtitle: Text(data['mobile'].toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: (){
                                  _launchURL('tel:${data['mobile']}');
                                }, icon: Icon(Icons.call))
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator(),);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
