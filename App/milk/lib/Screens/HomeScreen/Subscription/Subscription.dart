import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk/services/order_service.dart';
import 'package:intl/intl.dart';

class Subscription extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    OrderService orderService = OrderService();
    User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: orderService.subscription.where('userId',isEqualTo: user.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if(!snapshot.hasData){
              return Center(child: Text('No orders placed.Continue Shopping'),);
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 14,
                          child: Icon(CupertinoIcons.square_list,size: 18,
                              color: statusColor(data['orderStatus'])
                          ),

                        ),
                        title: Text(document.data()['orderStatus'],
                          style: TextStyle(fontSize: 12,color: statusColor(data['orderStatus']),fontWeight: FontWeight.bold),),
                        subtitle: Text('Ordered On ${DateFormat.yMMMd().format(DateTime.parse(document.data()['timestamp']))}',
                          style: TextStyle(fontSize: 12),),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Amount : \₹ ${document.data()['total']}',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                            Text('Payment Type : ${document.data()['payment']}',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      data['orderStatus']!='Pending'?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Subscription Start date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('${DateFormat.yMMMd().format(DateTime.parse(document.data()['startdate']))}'),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text('Subscription End date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('${DateFormat.yMMMd().format(DateTime.parse(document.data()['endDate']))}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ):Container(),
                      ExpansionTile(title: Text('Subscription Details',style: TextStyle(fontSize: 12,color: Colors.black),),
                        subtitle: Text('View subscription Details',style: TextStyle(fontSize: 12,color: Colors.grey)),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context,int index){
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.network(document.data()['products'][index]['productImage']),
                                ),
                                title: Text(document.data()['products'][index]['productName']),
                                subtitle: Text('Quantity: ${document.data()['products'][index]['qty'].toString()}   Price:₹ ${document.data()['products'][index]['sellingPrice'].toString()}',
                                  style: TextStyle(fontSize: 12,color: Colors.grey),),
                              );
                            },
                            itemCount: document.data()['products'].length,
                          )
                        ],),
                      Divider(height: 3,)
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
  statusColor(data){
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
}

