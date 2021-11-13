import 'package:admin/Screens/Home/Coupon/CouponScreenMain.dart';
import 'package:admin/Screens/Home/Location/LocationMain.dart';
import 'package:admin/Services/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'Home-Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var defaultscreen = '1';


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
        title: const Text('Dashboard' ,style: TextStyle(color: Colors.white),),
      ),
      sideBar: _sideBar.sideBarmenus(context,HomeScreen.id),
      body: ListView(
        children: [
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
            height: 300,
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
    );
  }
}
