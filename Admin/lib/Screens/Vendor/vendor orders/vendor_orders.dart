import 'package:admin/Screens/Vendor/vendor%20orders/AcceptedOrders.dart';
import 'package:admin/Screens/Vendor/vendor%20orders/Cancelled.dart';
import 'package:admin/Screens/Vendor/vendor%20orders/Delivered.dart';
import 'package:admin/Screens/Vendor/vendor%20orders/OutForDelivery.dart';
import 'package:admin/Screens/Vendor/vendor%20orders/PendingOrders.dart';
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


  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Text('Orders'),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              TabBar(tabs: [
                Tab(child: Text('Pending Orders',style: TextStyle(color: Colors.black54),),),
                Tab(child: Text('Accepted Orders',style: TextStyle(color: Colors.black54),),),
                Tab(child: Text('Out-For-Delivery Orders',style: TextStyle(color: Colors.black54),),),
                Tab(child: Text('Delivered Orders',style: TextStyle(color: Colors.black54),),),
                Tab(child: Text('Cancelled Orders',style: TextStyle(color: Colors.black54),),),
              ]),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    PendingOrders(),
                    AcceptedOrders(),
                    OutforDelivery(),
                    Delivered(),
                    CancelledOrders(),

                  ]),
                ),
              )
            ],
          )
      ),
    );
  }
}
