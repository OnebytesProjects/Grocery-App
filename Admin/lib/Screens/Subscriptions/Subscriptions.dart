import 'package:admin/Screens/Vendor/vendor%20service/drawer_services.dart';
import 'package:admin/Services/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class Subscription extends StatefulWidget {
  static const String id = 'subscription-screen';

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  DrawerServices _services = DrawerServices();
  SidebarWidget _sideBar = SidebarWidget();

  GlobalKey<SliderMenuContainerState> _key =
  new GlobalKey<SliderMenuContainerState>();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          title: const Text('Subscription' ,style: TextStyle(color: Colors.white),),
        ),
        sideBar: _sideBar.sideBarmenus(context,Subscription.id),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child: Text(
              'Subscription Screen',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
          ),
        ),
    );
  }
}
