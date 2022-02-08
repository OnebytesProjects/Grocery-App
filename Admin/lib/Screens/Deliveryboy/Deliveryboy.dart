import 'package:admin/Screens/Deliveryboy/Deliveryboyscreen.dart';
import 'package:admin/Services/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class Deliveryboy extends StatefulWidget {
  const Deliveryboy({Key? key}) : super(key: key);
  static const String id = 'Deliveryboy-Screen';
  @override
  _DeliveryboyState createState() => _DeliveryboyState();

}

class _DeliveryboyState extends State<Deliveryboy> {
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
      sideBar: _sideBar.sideBarmenus(context,Deliveryboy.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Delivery Boy',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Divider(thickness: 3,),
              Container(
                height: 500,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    child: Deliveryboyscreen(),
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
