import 'package:deliveryapp/HomeScreen/Pending.dart';
import 'package:deliveryapp/HomeScreen/pendingOrder.dart';
import 'package:deliveryapp/HomeScreen/pickedupOrder.dart';
import 'package:deliveryapp/Login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'package:tabbar/tabbar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'homescreen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define a controller for TabBar and TabBarViews
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          // Use ShiftingTabBar instead of appBar
          appBar: ShiftingTabBar(
            color: Colors.grey,
            tabs: <ShiftingTab>[
              ShiftingTab(
                icon: const Icon(Icons.shopping_bag_outlined),
                text: 'Pending Orders',
              ),
              ShiftingTab(
                icon: const Icon(Icons.airport_shuttle),
                text: 'To Be Delivered',
              ),
            ],
          ),
          body: const TabBarView(
            children: <Widget>[
              Pending(),
              PickedupOrder(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacementNamed(context, Login.id);
              });
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.exit_to_app),
          ),
        ),
      ),
    );
  }
}