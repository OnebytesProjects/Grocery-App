import 'package:admin/Screens/Vendor/Subscriptions/deliveryboy.dart';
import 'package:admin/Screens/Vendor/vendor%20orders/deliveryboy_list.dart';
import 'package:admin/Screens/Vendor/vendor%20service/drawer_services.dart';
import 'package:admin/Services/order_service.dart';
import 'package:admin/Services/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Subscription extends StatefulWidget {
  static const String id = 'subscription-screen';

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {

  OrderService orderService = OrderService();

  void _launchURL(number) async =>
      await canLaunch(number) ? await launch(number) : throw 'Could not call to $number';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions'),
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: orderService.subscription.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if(!snapshot.hasData){
              return Center(child: Text('No Subscriptions placed.'),);
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Container(
                  color: Colors.white,
                  child:
                  Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: Icon(CupertinoIcons.square_list,size: 18,
                              color: statusColor(data['orderStatus']),)
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
                      data['orderStatus']!='Pending'?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Subscription Start date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('${DateFormat.yMMMd().format(DateTime.parse(data['startdate']))}'),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text('Subscription End date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('${DateFormat.yMMMd().format(DateTime.parse(data['endDate']))}'),
                                ],
                              ),
                              SizedBox(height: 5,),
                              data['orderStatus']!='SubScription Ended'?Row(
                                children: [
                                  Text('Next Delivery date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('${DateFormat.yMMMd().format(DateTime.parse(data['DeliveryDate']))}'),
                                ],
                              ):Container(),
                              data['orderStatus']!='SubScription Ended'?Row(
                                children: [
                                  Text('DeliveryBoy Status: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(data['deliveryboystatus']),
                                ],
                              ):Container(),
                            ],
                          ),
                        ),
                      ):Container(),
                      Divider(height: 3,),
                      ExpansionTile(title: Text('Subscription Details',style: TextStyle(fontSize: 12,color: Colors.black),),
                        subtitle: Text('View Subscription Details',style: TextStyle(fontSize: 12,color: Colors.grey)),
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
                      tasks(data['orderStatus'], document, document.id,data['deliverBoy']['name'],data['deliverBoy']['phone']),

                      Divider(height: 10,thickness: 3,),

                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
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
            if(status == 'SubScription Ended'){
              orderService.endSubscriptionStatus(documentId, status).then((value) {
                EasyLoading.showSuccess("Subscription Ended");
              });
            }else{
              orderService.updateSubscriptionStatus(documentId, status).then((value) {
                EasyLoading.showSuccess("Updated Successfully");
              });
            }
            Navigator.pop(context);
          }, child: Text('Ok')),
        ],
      );
    });
  }

  statusColor(data){
    if(data == 'Accepted'){
      return Colors.orange[400];
    }
    if(data == 'Pending'){
      return Colors.orange;
    }
    if(data == 'SubScription Started'){
      return Colors.green;
    }
    if(data == 'SubScription Ended'){
      return Colors.red;
    }
  }

  tasks(data,document,documentId,name,number){
    if(data == 'Pending'){
      return Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(child: FlatButton(onPressed: (){
                showMyDialog("Accept Order",'SubScription Started',documentId);
              }, child: Text('Accept'),color: Colors.green,)),
            ),
          ],
        ),
      );
    }
    if(data == 'SubScription Started'){
      return Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(child: FlatButton(onPressed: (){
                showDialog(context: context, builder: (BuildContext context){
                  return DelivermanSub(documentId);
                });
              }, child: Text('Assign Delivery Boy'),color: Colors.orange,)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(child: FlatButton(onPressed: (){
                showMyDialog("End Subscription",'SubScription Ended',documentId);
              }, child: Text('End Subscription'),color: Colors.red,)),
            ),
          ],
        ),
      );
    }

    if(data == 'SubScription Ended'){
      return Container();
    }
  }
}
