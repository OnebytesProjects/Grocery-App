import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';
import 'package:milk/services/order_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/cart_services.dart';

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
    User? user = FirebaseAuth.instance.currentUser;

    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacementNamed(context, MainScreen.id);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: StreamBuilder<QuerySnapshot>(
          stream: orderService.order.where('userId',isEqualTo: user?.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if(!snapshot.hasData){
              return Center(child: Text('No orders placed.Continue Shopping'),);
            }

            if(snapshot.hasData){
              return ListView(
                reverse: true,
                shrinkWrap: true,
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
                          title: Text(data['orderStatus'],
                            style: TextStyle(fontSize: 12,color: statusColor(data['orderStatus']),fontWeight: FontWeight.bold),),
                          subtitle: Text('On ${DateFormat.yMMMd().format(DateTime.parse(data['timestamp']))}',
                            style: TextStyle(fontSize: 12),),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Amount : ??? ${data['total']}',
                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                              Text('Payment Type : ${data['payment']}',
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
                                        child: Image.network(data['products'][index]['productImage']),
                                      ),
                                      title: Text(data['products'][index]['productName']),
                                      subtitle: Text('Quantity: ${data['products'][index]['qty'].toString()}   Price:??? ${data['products'][index]['sellingPrice'].toString()} Quantity: ${data['products'][index]['productVolume'].toString()}',
                                        style: TextStyle(fontSize: 12,color: Colors.grey),),
                                    ),
                                  ],
                                );
                              },
                              itemCount: data['products'].length,
                            ),
                            data['orderStatus'] =='Pending'?RaisedButton(onPressed: (){
                              showDialog('Are you Sure?', context,document.id,data);
                            },child: Text('Cancel Order'),color: Colors.orange,):Container(),
                          ],),
                        Divider(height: 3,),
                        tasks(data['orderStatus'], document, document.id,data['deliverBoy']['name'],data['deliverBoy']['phone'],data,context),
                        Divider(height: 3,),
                      ],
                    ),
                  );
                }).toList(),
              );
            }

            return Center(child: Text('No orders placed.Continue Shopping'),);

          },
        ),
      ),
    );
  }

  showDialog(message,context,docid,data){
    CartService _cart = CartService();
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
            //update inventory
            UpdateInventory(data);
          }, child: Text('Ok'))
        ],
      );
    });
  }

  UpdateInventory(data){
    CollectionReference products = FirebaseFirestore.instance.collection('products');
    for (var s in data['products']){
      //updateInventory
      FirebaseFirestore.instance
          .collection('products')
          .doc(s['productid'])
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          products.doc(s['productid']).update({
            'Inventory_max_qty': documentSnapshot['Inventory_max_qty'] + s['qty'],
          });
        }
      });
    }
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
  tasks(data,document,documentId,name,number,docdata,context){
    if(data == 'Accepted'){
      return Container();
    }
    if(data == 'Pending'){
      return Container();
    }if(data == 'Delivery Man Assigned'){
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Container(color: Colors.grey,),
        ),
        title: Text(name),
        subtitle: Text(number),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: (){
              launch('tel:${number}');
            }, icon: Icon(Icons.call))
          ],
        ),
      );
    }
    if(data == 'On The Way'){
      return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Container(color: Colors.grey,),
        ),
        title: Text(name),
        subtitle: Text(number),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: (){
              launch('tel:${number}');
            }, icon: Icon(Icons.call))
          ],
        ),
      );
    }
    if(data == 'Delivered'){
      return Container();
    }
    if(data == 'Cancelled'){
      return Container();
    }
  }

}
