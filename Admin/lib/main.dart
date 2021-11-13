// @dart=2.9
import 'package:admin/Screens/Home/HomeScreen.dart';
import 'package:admin/Screens/Category/category_screen.dart';
import 'package:admin/Screens/Banner/manage_banners.dart';
import 'package:admin/Screens/Notification/notification_screen.dart';
import 'package:admin/Screens/Vendor/vendor%20service/product_provider.dart';
import 'package:admin/Screens/Vendor/vendor_products/add_new_product.dart';
import 'package:admin/Screens/Vendor/vendor_screen.dart';
import 'package:admin/Screens/Login/LoginScreen.dart';
import 'package:admin/Screens/Login/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() {
  Provider.debugCheckInvalidValueType=null;
  runApp( MultiProvider(
    providers: [
      Provider(create: (_)=>ProductProvider()),
    ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff444444),
      ),
      builder: EasyLoading.init(),
      routes: {
        HomeScreen.id:(context)=>HomeScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        BannerScreen.id:(context)=>BannerScreen(),
        CategoryScreen.id:(context)=>CategoryScreen(),
        NotificationScreen.id:(context)=>NotificationScreen(),
        VendorScreen.id:(context)=>VendorScreen(),
        AddNewProduct.id:(context)=>AddNewProduct(),
      },
    );
  }
}
