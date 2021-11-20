import 'package:admin/Screens/Vendor/vendor%20orders/deliveryboy_list.dart';
import 'package:admin/Services/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorsOrders extends StatefulWidget {
  const VendorsOrders({Key? key}) : super(key: key);

  @override
  State<VendorsOrders> createState() => _VendorsOrdersState();
}

class _VendorsOrdersState extends State<VendorsOrders> {
  OrderService orderService = OrderService();


  void _launchURL(number) async =>
      await canLaunch(number) ? await launch(number) : throw 'Could not call to $number';


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
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

                      tasks(data['orderStatus'], document, document.id,data['deliverBoy']['name'],data['deliverBoy']['phone'],data,context),
                      //checking
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
            orderService.updateOrderStatus(documentId, status).then((value) {
              EasyLoading.showSuccess("Updated Successfully");
            });
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
      return Colors.red;
    }
    if(data == 'On The Way'){
      return Colors.purple[900];
    }
    if(data == 'Delivered'){
      return Colors.green;
    }
    if(data == 'Delivery Man Assigned'){
      return Colors.blue;
    }
  }

  tasks(data,document,documentId,name,number,docdata,context){
    if(data == 'Accepted'){
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
                  return DeliveryBoyList(document);
                });
              }, child: Text('Assign Delivery Boy'),color: Colors.orange,)),
            ),
          ],
        ),
      );
    }
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
                showMyDialog("Accept Order",'Accepted',documentId);
              }, child: Text('Accept'),color: Colors.green,)),
            ),
          ],
        ),
      );
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
              _launchURL('tel:${number}');
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
              _launchURL('tel:${number}');
            }, icon: Icon(Icons.call))
          ],
        ),
      );
    }
    if(data == 'Delivered'){
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
              _launchURL('tel:${number}');
            }, icon: Icon(Icons.call))
          ],
        ),
      );
    }
  }

}
