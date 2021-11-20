import 'package:admin/Screens/Vendor/productP_UP/PublishedProducts.dart';
import 'package:admin/Screens/Vendor/productP_UP/UnpublishedProducts.dart';
import 'package:admin/Screens/Vendor/vendor_products/add_new_product.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';

class VendorProduct extends StatelessWidget {
  const VendorProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Products'),
        ),
        body: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton.icon(onPressed: (){
                      Navigator.pushNamed(context, AddNewProduct.id);
                    }, icon: Icon(Icons.add), label: Text("Add Product"),color: Colors.orange[700],)
                  ],
                ),
              ),
            ),
            TabBar(tabs: [
              Tab(child: Text('Published',style: TextStyle(color: Colors.black54),),),
              Tab(child: Text('UnPublished',style: TextStyle(color: Colors.black54),),),
            ]),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  PublishedProducts(),
                  UnpublishedProducts(),
                ]),
              ),
            )
          ],
        )
      ),
    );
  }
}
