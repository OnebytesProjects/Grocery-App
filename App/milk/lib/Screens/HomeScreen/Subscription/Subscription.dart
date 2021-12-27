import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk/services/order_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Subscription extends StatefulWidget {
  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  String vip = '';
  CollectionReference subscription = FirebaseFirestore.instance.collection('subscription');
  CollectionReference subscription2 = FirebaseFirestore.instance.collection('Activesubscription');
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');


  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) =>
    {vip = documentSnapshot['vip']});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    OrderService orderService = OrderService();
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<QuerySnapshot>(
        stream: orderService.subscription.where('userId',isEqualTo: user?.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if(snapshot.hasData){
            return ListView(
              shrinkWrap: true,
              reverse: true,
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
                        title: Text(data['orderStatus'],
                          style: TextStyle(fontSize: 12,color: statusColor(data['orderStatus']),fontWeight: FontWeight.bold),),
                        subtitle: Text('Ordered On ${DateFormat.yMMMd().format(DateTime.parse(data['timestamp']))}',
                          style: TextStyle(fontSize: 12),),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Amount : ₹ ${data['total']}',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                            Text('Payment Type : ${data['payment']}',
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      data['orderStatus']=='SubScription Started'?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Subscription Start date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(DateFormat.yMMMd().format(DateTime.parse(data['startdate']))),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text('Subscription End date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(DateFormat.yMMMd().format(DateTime.parse(data['endDate']))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ):Container(),
                      data['orderStatus']=='SubScription Ended'?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Subscription Start date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(DateFormat.yMMMd().format(DateTime.parse(data['startdate']))),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Text('Subscription End date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(DateFormat.yMMMd().format(DateTime.parse(data['endDate']))),
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
                              return Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.network(data['products'][index]['productImage']),
                                    ),
                                    title: Text(data['products'][index]['productName']),
                                    subtitle: Text('Quantity: ${data['products'][index]['qty'].toString()}   Price:₹ ${data['products'][index]['sellingPrice'].toString()}  Period:₹ ${data['products'][index]['subscription'].toString()}',
                                      style: TextStyle(fontSize: 12,color: Colors.grey),),
                                  ),
                                  data['orderStatus'] =='Pending'?RaisedButton(onPressed: (){
                                    showDialog('Are you Sure?', context,document.id);
                                  },child: Text('Cancel Subscription'),color: Colors.orange,):Container(),
                                ],
                              );
                            },
                            itemCount: data['products'].length,
                          )
                        ],),
                      Divider(height: 3,),
                      tasks(data['orderStatus'], document, document.id,data['deliverBoy']['name'],data['deliverBoy']['phone'],data,context,data['deliveryboystatus']),
                      Divider(height: 10,),
                    ],
                  ),
                );
              }).toList(),
            );
          }

          return Center(child: Text('No subscription placed.Continue Shopping'),);
        },
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
    if(data == 'Cancelled'){
      return Colors.orange;
    }
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
            subscription.doc(docid)
                .update({'orderStatus': 'Cancelled'});
            //update active subs
            subscription2.doc(docid).delete();
            //user subscription cancel
            users.doc(_auth.currentUser?.uid)
                .update({'vip': 'no'});
          }, child: Text('Ok'))
        ],
      );
    });
  }
  tasks(data,document,documentId,name,number,docdata,context,dbstatus){
    if(data == 'SubScription Ended'){
      return Container();
    }
    if(data == 'Pending'){
      return Container();
    }if(data == 'SubScription Started'){
      if(dbstatus == 'Assigned'){
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
      }else{
        return Container();
      }
    }
    if(data == 'Cancelled'){
      return Container();
    }
  }
}

