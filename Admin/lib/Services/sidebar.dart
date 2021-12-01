import 'package:admin/Screens/Home/HomeScreen.dart';
import 'package:admin/Screens/Category/category_screen.dart';
import 'package:admin/Screens/Banner/manage_banners.dart';
import 'package:admin/Screens/MilkScreen/MilkScreen.dart';
import 'package:admin/Screens/Notification/notification_screen.dart';
import 'package:admin/Screens/Vendor/vendor_screen.dart';
import 'package:admin/Screens/Login/LoginScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class SidebarWidget {
  sideBarmenus(context, selectedRoutes) {
    return SideBar(
      items: const [
        MenuItem(
          title: 'Dashboard',
          route: HomeScreen.id,
          icon: Icons.dashboard,
        ),
        MenuItem(
          title: 'Banners',
          route: BannerScreen.id,
          icon: CupertinoIcons.photo,
        ),
        MenuItem(
          title: 'Categories',
          route: CategoryScreen.id,
          icon: Icons.category,
        ),
        MenuItem(
          title: 'Milk Screen',
          route: MilkScreen.id,
          icon: Icons.category,
        ),
        MenuItem(
          title: 'Vendor',
          route: VendorScreen.id,
          icon: CupertinoIcons.shopping_cart,
        ),
        MenuItem(
          title: 'Send Notification',
          route: NotificationScreen.id,
          icon: Icons.notifications,
        ),
        MenuItem(
          title: 'Exit',
          route: LoginScreen.id,
          icon: Icons.exit_to_app,
        ),
      ],
      selectedRoute: selectedRoutes,
      onSelected: (item) {
        Navigator.of(context).pushNamed(item.route);
      },
      header: Container(
        height: 50,
        width: double.infinity,
        color: Color(0xff444444),
        child: Center(
          child: Text(
            'MENU',
            style: TextStyle(
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
      footer: Container(
        height: 60,
        width: double.infinity,
        color: Color(0xff444444),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage('images/ob.jpeg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Text(
                  "Developed By OneBytes",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}