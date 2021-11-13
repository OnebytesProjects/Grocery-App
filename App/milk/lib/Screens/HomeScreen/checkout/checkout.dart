import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milk/providers/cart__provider.dart';
import 'package:milk/providers/coupon_provider.dart';
import 'package:milk/services/cart_services.dart';
import 'package:milk/services/order_service.dart';
import 'package:provider/provider.dart';

enum SingingCharacter { Googlepay, CashOnDelivery }

class Checkout extends StatefulWidget {
  double cartValue;
  double delivryCharge;
  Checkout({required this.cartValue,required this.delivryCharge,});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  CartService cartService = CartService();
  User user = FirebaseAuth.instance.currentUser;
  OrderService _orderService = OrderService();
  double discountrate = 0.0;
  double total = 0.0;


  String payment = 'GooglePay';
  SingingCharacter? _paymentmode = SingingCharacter.Googlepay;
  String _address = '';
  String _name = '';
  String _number = '';
  var _couponText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _coupon = Provider.of<CouponProvider>(context);
    var cartProvider = Provider.of<CartProvider>(context);

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          this._address = documentSnapshot.data()['address'];
          this._name = documentSnapshot.data()['name'];
          this._number = documentSnapshot.data()['number'];
          //name
          //number
          total = widget.cartValue+widget.delivryCharge;
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
                        Container(
                          height: 40,
                          child: Row(children: [
                            Expanded(child: SizedBox(
                              height: 38,
                              child: TextField(
                                controller: _couponText,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.grey[300],
                                    hintText: 'Enter Coupon Code'
                                ),
                              ),
                            )),
                            OutlineButton(borderSide: BorderSide(color: Colors.grey),onPressed: (){
                              _coupon.getCouponDetails(_couponText.text).then((value) {
                                if(value.data()==null){
                                  //display invalid
                                  showDialog(_couponText.text,'is invalid');
                                  _couponText.clear();
                                }
                                if(_coupon.expired == false){
                                  setState(() {
                                    this.discountrate = _coupon.discountrate;
                                    this.total = total-discountrate;
                                  });
                                  showDialog(_couponText.text,'is applied successfully');
                                }
                              });
                            },child: Text('Apply'),)
                          ],),
                        ),
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
                            Text('₹ '+widget.delivryCharge.toString())
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
    _orderService.saveorder({
      'products':cartProvider.cartList,
      'userId':user.uid,
      'total':total,
      'name':_name,
      'number':_number,
      'address':_address,
      'payment':payment,
      'timestamp': DateTime.now().toString(),
      'orderStatus':'Pending',
      'deliverBoy':{
        'name' : '',
        'phone': '',
      }
    }).then((value){
      cartService.deleteCart().then((value) {
        Navigator.pop(context);
      });
    });
    EasyLoading.showSuccess('OrederPlaced');
  }
}
