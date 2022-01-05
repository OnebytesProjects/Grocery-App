import 'package:admin/Screens/Vendor/Subscriptions/ActiveSubs.dart';
import 'package:admin/Screens/Vendor/Subscriptions/InactiveSubs.dart';
import 'package:admin/Screens/Vendor/productP_UP/PublishedProducts.dart';
import 'package:admin/Screens/Vendor/productP_UP/UnpublishedProducts.dart';
import 'package:admin/Screens/Vendor/vendor_products/add_new_product.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

class Subscription extends StatelessWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Text('Subscription'),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              TabBar(tabs: [
                Tab(child: Text('Active Subscription',style: TextStyle(color: Colors.black54),),),
                Tab(child: Text('InActive Subscription',style: TextStyle(color: Colors.black54),),),
              ]),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    ActiveSubscription(),
                    InActiveSubscription(),
                  ]),
                ),
              )
            ],
          )
      ),
    );
  }
}
