import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/services/firebase_serice.dart';
import 'package:deliveryapp/services/order_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PickedupOrder extends StatefulWidget {
  const PickedupOrder({Key? key}) : super(key: key);

  @override
  _PickedupOrderState createState() => _PickedupOrderState();
}

class _PickedupOrderState extends State<PickedupOrder> {
  void _launchURL(number) async => await canLaunch(number)
      ? await launch(number)
      : throw 'Could not call to $number';

  OrderService orderService = OrderService();
  FirebaseService _service = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _service.orders
            .where('orderStatus', isEqualTo: 'On The Way')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('No orders.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Container(
                color: Colors.white,
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 14,
                          child: Icon(
                            CupertinoIcons.square_list,
                            size: 18,
                            color: statusColor(data['orderStatus']),
                          )),
                      title: Text(
                        data['orderStatus'],
                        style: TextStyle(
                            fontSize: 12,
                            color: statusColor(data['orderStatus']),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'On ${DateFormat.yMMMd().format(DateTime.parse(data['timestamp']))}',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Amount : \₹ ${data['total']}',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Payment Type : ${data['payment']}',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 3,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 14,
                          child: Icon(
                            CupertinoIcons.profile_circled,
                            size: 18,
                            color: Colors.grey,
                          )),
                      title: Text(
                        data['name'],
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        ' ${data['address']}\n${data['number']}',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                _launchURL('tel:${data['number']}');
                              },
                              icon: Icon(Icons.call))
                        ],
                      ),
                    ),
                    Divider(
                      height: 3,
                    ),
                    ExpansionTile(
                      title: Text(
                        'Order Details',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      subtitle: Text('View order Details',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Image.network(
                                    data['products'][index]['productImage']),
                              ),
                              title:
                                  Text(data['products'][index]['productName']),
                              subtitle: Text(
                                'Quantity: ${data['products'][index]['qty'].toString()}   Price:₹ ${data['products'][index]['sellingPrice'].toString()}',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            );
                          },
                          itemCount: data['products'].length,
                        )
                      ],
                    ),
                    Divider(
                      height: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [Text('Delivery Mode:',style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(data['deliveryMode'])
                        ],
                      ),
                    ),
                    Divider(
                      height: 3,
                    ),
                    tasks(data['orderStatus'], document.id),
                    Divider(
                      height: 10,
                      thickness: 3,
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  showMyDialog(title, status, documentId) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text('Are You sure?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    EasyLoading.show(status: 'Updating');
                    orderService
                        .updateOrderStatus(documentId, status)
                        .then((value) {
                      EasyLoading.showSuccess("Updated Successfully");
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Ok')),
            ],
          );
        });
  }

  statusColor(data) {
    if (data == 'Order Picked Up') {
      return Colors.pink;
    }
  }

  tasks(data, documentId) {
    if (data == 'On The Way') {
      return Container(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                onPressed: () {
              showMyDialog("Delivered Order", 'Delivered', documentId);
                },
                child: Text('Delivered'),
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }
  }
}
