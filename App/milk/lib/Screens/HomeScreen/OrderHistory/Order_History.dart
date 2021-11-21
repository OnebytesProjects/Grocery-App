import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk/services/order_service.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  @override
  Widget build(BuildContext context) {

    OrderService orderService = OrderService();
    User user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: orderService.order.where('userId',isEqualTo: user.uid).snapshots(),
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
                    children: [
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
                        subtitle: Text('On ${DateFormat.yMMMd().format(DateTime.parse(document.data()['timestamp']))}',
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
                      ExpansionTile(title: Text('Order Details',style: TextStyle(fontSize: 12,color: Colors.black),),
                      subtitle: Text('View order Details',style: TextStyle(fontSize: 12,color: Colors.grey)),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,int index){
                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.network(document.data()['products'][index]['productImage']),
                                ),
                                title: Text(document.data()['products'][index]['productName']),
                                  subtitle: Text('Quantity: ${document.data()['products'][index]['qty'].toString()}   Price:₹ ${document.data()['products'][index]['sellingPrice'].toString()}',
                                    style: TextStyle(fontSize: 12,color: Colors.grey),),
                              ),
                              document.data()['orderStatus'] !='Cancelled'?RaisedButton(onPressed: (){
                                showDialog('Are you Sure?', context,document.id);
                              },child: Text('Cancel Order'),color: Colors.orange,):Container(),
                            ],
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

  showDialog(message,context,docid){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        content: Text('$message'),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          FlatButton(onPressed: (){
            Navigator.pop(context);
            //changestatus
            orders.doc(docid)
                .update({'orderStatus': 'Cancelled'});
          }, child: Text('Ok'))
        ],
      );
    });
  }

  statusColor(data){
    if(data == 'Accepted'){
      return Colors.orange;
    }
    if(data == 'Cancelled'){
      return Colors.red;
    }
    if(data == 'Pending'){
      return Colors.orange;
    }
    if(data == 'On The Way'){
      return Colors.orange;
    }
    if(data == 'Delivered'){
      return Colors.green;
    }
    if(data == 'Delivery Man Assigned'){
      return Colors.orange;
    }
  }
}
