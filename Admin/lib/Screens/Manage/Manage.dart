import 'package:admin/Screens/Manage/Coupon/CouponScreenMain.dart';
import 'package:admin/Screens/Manage/Inventory/Inventory.dart';
import 'package:admin/Screens/Manage/Location/LocationMain.dart';
import 'package:admin/Services/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../Notification/notification_screen.dart';

class Manage extends StatelessWidget {
  static const String id = 'manage-screen';
  const Manage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SidebarWidget _sideBar = SidebarWidget();

    return AdminScaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text('Manage' ,style: TextStyle(color: Colors.white),),
      ),
      sideBar: _sideBar.sideBarmenus(context,NotificationScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Manage',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Divider(thickness: 5,),
              Container(
                height: 450,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: Inventory(),
                  ),
                ),
              ),
              Divider(thickness: 3,),
              Container(
                height: 450,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: CouponScreenMain(),
                  ),
                ),
              ),
              Divider(thickness: 3,),
              Container(
                height: 450,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: LocationScreenMain(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}