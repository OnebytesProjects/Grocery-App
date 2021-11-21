import 'package:deliveryapp/HomeScreen/pendingMilkOrder.dart';
import 'package:deliveryapp/HomeScreen/pendingOrder.dart';
import 'package:flutter/material.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';

class Pending extends StatefulWidget {
  const Pending({Key? key}) : super(key: key);

  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
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
            color: Colors.blue,
            tabs: <ShiftingTab>[
              ShiftingTab(
                icon: const Icon(Icons.shopping_bag_outlined),
                text: 'Grocery',
              ),
              ShiftingTab(
                icon: const Icon(Icons.airport_shuttle),
                text: 'Milk',
              ),
            ],
          ),
          body: const TabBarView(
            children: <Widget>[
              PendingOrder(),
              PendingMilkOrder(),
            ],
          ),
        ),
      ),
    );
  }
}
