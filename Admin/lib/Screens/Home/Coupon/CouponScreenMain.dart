import 'package:admin/Screens/Home/Coupon/CouponScreen.dart';
import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'EditCoupon.dart';

class CouponScreenMain extends StatefulWidget {
  @override
  State<CouponScreenMain> createState() => _CouponScreenMainState();
}

class _CouponScreenMainState extends State<CouponScreenMain> {
  String defaultscreen = '1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Coupon'),
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
      ),
            body: Container(
                child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Add New Coupons',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CouponScreen()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 3,
                ),
                Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Title',
                        ),
                        Text(
                          'DiscountRate',
                        ),
                        Text(
                          'Description',
                        ),
                        Text(
                          'Status',
                        ),
                        Text(
                          'Expiry Date',
                        ),
                        Text(
                          'Options',
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 3,
                ),
                Container(
                  child: CouponList(),
                )
              ],
            )),
          );
  }

  Widget CouponList() {
    FirebaseServices _services = FirebaseServices();

    return Container(
        child: StreamBuilder(
      stream: _services.coupons.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          return Expanded(
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                var date = data['Expiry'];
                var expiry = DateFormat.yMMMd().add_jm().format(date.toDate());
                return Container(
                  height: 80,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                data['title'],
                              ),
                            ),
                            Container(
                              child: Text(
                                '₹ '+data['discountRate'].toString(),
                              ),
                            ),
                            Container(
                              child: Text(
                                data['details'],
                              ),
                            ),
                            Container(
                              child: Text(
                                data['active'].toString() == 'true'? 'Active':'Inactive',
                              ),
                            ),
                            Container(
                              child: Text(
                                expiry.toString(),
                              ),
                            ),
                            popUpButton(data,context,expiry),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
  Widget popUpButton(data,BuildContext context,expiry){
    FirebaseServices _services = FirebaseServices();
    return PopupMenuButton<String>(
        onSelected: (String value){
          if(value == 'edit'){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditCoupon(
                      title:  data['title'],
                      discount: data['discountRate'].toString(),
                      coupondetail: data['details'],
                      expdate: expiry.toString(),
                      status: data['active'],
                    )));
          }
          if(value == 'delete'){
            _services.deleteCoupon(id: data['title']);
          }
        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Preview/Edit'),
            ),),
          const PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete_outlined),
              title: Text('Delete Product'),
            ),),
        ]);
  }
}
