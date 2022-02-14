import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/services/firebase_serice.dart';
import 'package:deliveryapp/services/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PendingMilkOrder extends StatefulWidget {
  const PendingMilkOrder({Key? key}) : super(key: key);

  @override
  _PendingMilkOrderState createState() => _PendingMilkOrderState();
}

class _PendingMilkOrderState extends State<PendingMilkOrder> {
  var name = '';

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('deliveryBoy')
        .doc(_auth.currentUser?.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot["name"];
        });

      }
    });
    super.initState();
  }

  void _launchURL(number) async =>
      await canLaunch(number) ? await launch(number) : throw 'Could not call to $number';

  OrderService orderService = OrderService();
  FirebaseService _service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return
      Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _service.subscription.where('deliverBoy.name',isEqualTo: name).where('deliveryboystatus',isEqualTo: 'Assigned').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if(!snapshot.hasData){
              return Center(child: Text('No orders.'),);
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: Icon(CupertinoIcons.square_list,size: 18,
                              color: statusColor(data['orderStatus'])
                              ,)

                        ),
                        title: Text(data['orderStatus'],
                          style: TextStyle(fontSize: 12,
                              color: statusColor(data['orderStatus']),
                              fontWeight: FontWeight.bold),),
                        subtitle: Text('On ${DateFormat.yMMMd().format(DateTime.parse(data['timestamp']))}',
                          style: TextStyle(fontSize: 12),),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Amount : \₹ ${data['total']}',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                            Text('Payment Type : ${data['payment']}',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      Divider(height: 3,),
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: Icon(CupertinoIcons.profile_circled,size: 18,
                              color: Colors.grey,)
                        ),
                        title: Text(data['name'],
                          style: TextStyle(fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),),
                        subtitle: Text(' ${data['address']}\n${data['number']}',
                          style: TextStyle(fontSize: 12),),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(onPressed: (){
                              _launchURL('tel:${data['number']}');
                            }, icon: Icon(Icons.call))
                          ],
                        ),
                      ),

                      Divider(height: 3,),
                      ExpansionTile(title: Text('Order Details',style: TextStyle(fontSize: 12,color: Colors.black),),
                        subtitle: Text('View order Details',style: TextStyle(fontSize: 12,color: Colors.grey)),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context,int index){
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.network(data['products'][index]['productImage']),
                                ),
                                title: Text(data['products'][index]['productName']),
                                subtitle: Text('Quantity: ${data['products'][index]['qty'].toString()}   Price:₹ ${data['products'][index]['sellingPrice'].toString()}',
                                  style: TextStyle(fontSize: 12,color: Colors.grey),),
                              );
                            },
                            itemCount: data['products'].length,
                          )
                        ],),
                      Divider(height: 3,),
                      tasks(data['orderStatus'], document.id),

                      Divider(height: 10,thickness: 3,),

                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
  }

  showMyDialog(title,status,documentId){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text('Are You sure?'),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          FlatButton(onPressed: (){
            EasyLoading.show(status: 'Updating');
            orderService.updateSubscriptionStatus(documentId, status).then((value) {
              EasyLoading.showSuccess("Updated Successfully");
            });
            Navigator.pop(context);
          }, child: Text('Ok')),
        ],
      );
    });
  }

  statusColor(data){
    if(data == 'SubScription Started'){
      return Colors.blue;
    }
    if(data == 'Order Picked Up'){
      return Colors.pink;
    }
    if(data == 'Delivered'){
      return Colors.green;
    }
  }

  tasks(data,documentId){
    if(data == 'SubScription Started'){
      return Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(onPressed: (){
                showMyDialog("Delivered Order",'Delivered',documentId);
                print('Picked Up');
              }, child: Text('Delivered'),color: Colors.green,),
            ),
          ],
        ),
      );
    }
  }
}
