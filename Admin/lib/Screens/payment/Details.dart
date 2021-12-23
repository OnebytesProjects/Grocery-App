import 'package:admin/Services/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  OrderService orderService = OrderService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: orderService.order.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if(!snapshot.hasData){
                return Center(child: Text('No orders placed.'),);
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
                              child: Icon(CupertinoIcons.profile_circled,size: 18,
                                color: Colors.grey,)
                          ),
                          title: Text(data['name'],
                            style: TextStyle(fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),),
                          subtitle: Text(' ${data['address']}\n${data['number']}\nOn ${DateFormat.yMMMd().format(DateTime.parse(data['timestamp']))}',
                            style: TextStyle(fontSize: 12),),
                          trailing: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Amount : \₹ ${data['total']}',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                  Text('Payment Type : ${data['payment']}',
                                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              IconButton(onPressed: (){
                                launch('tel:${data['number']}');
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
                                  subtitle: Text('Quantity: ${data['products'][index]['qty'].toString()}   Price:₹ ${data['products'][index]['sellingPrice'].toString()} Volume: ${data['products'][index]['productVolume'].toString()}',
                                    style: TextStyle(fontSize: 12,color: Colors.grey),),
                                );
                              },
                              itemCount: data['products'].length,
                            )
                          ],),
                        Divider(height: 3,),
                        //checking
                        Divider(height: 15,thickness: 5,),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

}
