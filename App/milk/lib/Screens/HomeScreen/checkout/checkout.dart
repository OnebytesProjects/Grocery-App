import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milk/Screens/HomeScreen/Home/Home.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';
import 'package:milk/Screens/HomeScreen/checkout/coupon_widget.dart';
import 'package:milk/providers/cart__provider.dart';
import 'package:milk/providers/coupon_provider.dart';
import 'package:milk/services/cart_services.dart';
import 'package:milk/services/order_service.dart';
import 'package:provider/provider.dart';

enum SingingCharacter { Googlepay, CashOnDelivery }

class Checkout extends StatefulWidget {
  double cartValue;
  Checkout({required this.cartValue,});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  CartService cartService = CartService();
  User user = FirebaseAuth.instance.currentUser;
  OrderService _orderService = OrderService();
  int discountrate = 0;
  double total = 0.0;


  String payment = 'GooglePay';
  SingingCharacter? _paymentmode = SingingCharacter.Googlepay;
  String _address = '';
  String _pincode = '';
  String _deliverymode = '';
  String _name = '';
  String _number = '';
  int delivryCharge = 0;

  @override
  Widget build(BuildContext context) {
    var _coupon = Provider.of<CouponProvider>(context);
    var cartProvider = Provider.of<CartProvider>(context);
    discountrate = _coupon.discountrate;

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          this._address = documentSnapshot.data()['address'];
          this._pincode = documentSnapshot.data()['pincode'];
          this._deliverymode = documentSnapshot.data()['preference'];
          this._name = documentSnapshot.data()['name'];
          this._number = documentSnapshot.data()['number'];
          //name
          //number
          total = (widget.cartValue+delivryCharge)-discountrate;
        });
      }
    });
    FirebaseFirestore.instance
        .collection('pincode')
        .doc(_pincode)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          this.delivryCharge = documentSnapshot.data()['deliverycharge'];
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        backgroundColor: Colors.grey[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Card(
                      child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Bill Details",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CoupunWidget(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [Expanded(child: Text("Cart Value")), Text('₹ '+widget.cartValue.toString())],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("Delivery Charge")),
                            Text('₹ '+delivryCharge.toString())
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("Discount")),
                            Text('- ₹ ' + discountrate.toString())
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [Expanded(child: Text("Total")), Text('₹ '+total.toString())],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        Text(
                          "Delivery Address",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ExpandableText(
                          _address,
                          expandText: 'View More',
                          collapseText: 'View Less',
                          maxLines: 2,
                        ),
                        Divider(),
                        Divider(),
                        Text(
                          "Delivery Mode",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ExpandableText(
                          _deliverymode,
                          expandText: 'View More',
                          collapseText: 'View Less',
                          maxLines: 2,
                        ),
                        Divider(),
                        Text(
                          "Payment Method",
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        ListTile(
                          title: const Text('Google Pay'),
                          leading: Radio<SingingCharacter>(
                            value: SingingCharacter.Googlepay,
                            groupValue: _paymentmode,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _paymentmode = value;
                                this.payment = 'GooglePay';
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Cash On Delivery'),
                          leading: Radio<SingingCharacter>(
                            value: SingingCharacter.CashOnDelivery,
                            groupValue: _paymentmode,
                            onChanged: (SingingCharacter? value) {
                              setState(() {
                                _paymentmode = value;
                                this.payment = 'Cod';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: 50,
                    width: double.infinity,
                    child: InkWell(
                      onTap: (){
                        if(payment == 'GooglePay'){
                          EasyLoading.show(status: 'Placing Order');
                          saveOrder(cartProvider);
                        }
                        if(payment == 'Cod'){
                          EasyLoading.show(status: 'Placing Order');
                          saveOrder(cartProvider);
                        }
                      },
                      child: Container(
                        height: 20,
                        width: 50,
                        color: Colors.orange,
                        child: Center(child: Text("Proceed to Pay"),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  showDialog(code,message){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text('Coupon'),
        content: Text('The Coupon $code is $message'),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Ok'))
        ],
      );
    });
  }
  saveOrder(CartProvider cartProvider){
    if(cartProvider.subExist == 'Yes'){
      _orderService.saveSubscription({
        'products':cartProvider.subscritionList,
        'userId':user.uid,
        'total':total,
        'name':_name,
        'number':_number,
        'address':_address,
        'deliveryMode': _deliverymode,
        'payment':payment,
        'timestamp': DateTime.now().toString(),
        'orderStatus':'Pending',
        'deliverBoy':{
          'name' : '',
          'phone': '',
        },
        'startdate':'',
        'endDate':'',
        'DeliveryDate':'',
        'deliveryboystatus':'',
      });
    }
    _orderService.saveorder({
      'products':cartProvider.cartList,
      'userId':user.uid,
      'total':total,
      'name':_name,
      'number':_number,
      'address':_address,
      'deliveryMode': _deliverymode,
      'payment':payment,
      'timestamp': DateTime.now().toString(),
      'orderStatus':'Pending',
      'deliverBoy':{
        'name' : '',
        'phone': '',
      }
    }).then((value){
      print(user.uid);
      _orderService.deleteCart().then((value) {
        _orderService.checkData().then((value) {
          EasyLoading.showSuccess('OrederPlaced');
          Navigator.pop(context);
          Navigator.pop(context);
        });
      });
    });
  }
}
