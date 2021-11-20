import 'package:admin/Screens/Vendor/Subscriptions/Subscriptions.dart';
import 'package:admin/Screens/Vendor/vendor%20orders/vendor_orders.dart';
import 'package:admin/Screens/Vendor/vendor_products/vendor_product.dart';
import 'package:flutter/cupertino.dart';

class DrawerServices{

  Widget drawerScreen(title){
    if(title == 'Products'){
      return VendorProduct();
    }
    if(title == 'Orders'){
      return VendorsOrders();
    }
    if(title == 'Subscription'){
      return Subscription();
    }
    return VendorProduct();
  }
}