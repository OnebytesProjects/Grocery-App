import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:milk/models/product_model.dart';
import 'package:milk/services/cart_services.dart';

class MilkDisplay extends StatefulWidget {
  var pname;
  MilkDisplay({this.pname});

  @override
  _MilkDisplayState createState() => _MilkDisplayState();
}

class _MilkDisplayState extends State<MilkDisplay> {
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool _cartbutton = false;
  bool isChecked1sub = false;
  bool isChecked2sub = false;
  bool incdisplay = false;
  bool subdisplay = false;
  String subscriptionType = '';
  int _qty = 0;
  String volume = 'nil';
  String vip = '';
  String gif = '';
  double chosenPrice = 0.0;
  var total;
  var cp;

  CartService _cart = CartService();
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future checksubscription() async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) =>
    {this.vip = documentSnapshot['vip']});
  }

  //check vip
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checksubscription();

    //get milkgif
    FirebaseFirestore.instance
        .collection('milkscreen')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        this.gif = doc['image'];
      });
    });

    setState(() {
      if (_qty > 0 || volume != 'nil' || subscriptionType != '') {
        _cartbutton = true;
      }
      if (_qty == 0 || volume == 'nil' || subscriptionType == '') {
        _cartbutton = false;
      }
    });
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        height: 480,
        child: ProductDetails(),
      ),
    );
  }

  Widget ProductDetails() {
    DateTime now = DateTime.now();
    String todaydate = DateFormat().add_jm().format(now);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    String tomorrowdate = DateFormat('EEE d MMM').format(tomorrow);

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.orange;
    }

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('products')
        .where('productName', isEqualTo: 'Milk')
        .snapshots();

    return StreamBuilder(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('Loading'),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(
                  children: [
                    SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: MilkGif(),
                      // child: Card(
                      //   child: Center(
                      //     child: Image.network(gif),
                      //   ),
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 80),
                              child: ExpandableText(
                                data['productDescription'],
                                expandText: 'View More',
                                collapseText: 'View Less',
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          text: 'Order By ', // default text style
                          children: <TextSpan>[
                            TextSpan(
                                text: todaydate,
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: ' today & get the delivery by ',
                            ),
                            TextSpan(
                                text: tomorrowdate + ' .',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Volume",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Container(
                              height: 120,
                              padding: EdgeInsets.only(left: 20, right: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                              checkColor: Colors.white,
                                              fillColor: MaterialStateProperty
                                                  .resolveWith(getColor),
                                              value: isChecked1,
                                              onChanged: (value) {
                                                setState(() {
                                                  isChecked1 = value!;
                                                  isChecked2 = false;
                                                  isChecked3 = false;
                                                  isChecked4 = false;
                                                  volume = data['v1'];
                                                  chosenPrice = double.parse(
                                                      data['p1']);
                                                  subdisplay = true;
                                                });
                                                if (value == false) {
                                                  setState(() {
                                                    volume = 'nil';
                                                    chosenPrice = 0.0;
                                                    subdisplay = false;
                                                  });
                                                }
                                                //check
                                                setState(() {
                                                  isChecked1sub = false;
                                                  isChecked2sub = false;
                                                  _qty = 0;
                                                });
                                              }),
                                          Text(
                                              "${data['v1']} - ₹ ${data['p1']}")
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                              checkColor: Colors.white,
                                              fillColor: MaterialStateProperty
                                                  .resolveWith(getColor),
                                              value: isChecked2,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isChecked1 = false;
                                                  isChecked2 = value!;
                                                  isChecked3 = false;
                                                  isChecked4 = false;
                                                  volume = data['v3'];
                                                  chosenPrice = double.parse(
                                                      data['p3']);
                                                  subdisplay = true;
                                                });
                                                if (value == false) {
                                                  setState(() {
                                                    volume = 'nil';
                                                    chosenPrice = 0.0;
                                                    subdisplay = false;
                                                  });
                                                }
                                                //check
                                                setState(() {
                                                  isChecked1sub = false;
                                                  isChecked2sub = false;
                                                  _qty = 0;
                                                });
                                              }),
                                          Text(
                                              "${data['v3']} - ₹ ${data['p3']}")
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                              checkColor: Colors.white,
                                              fillColor:
                                                  MaterialStateProperty
                                                      .resolveWith(
                                                          getColor),
                                              value: isChecked3,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isChecked1 = false;
                                                  isChecked2 = false;
                                                  isChecked3 = value!;
                                                  isChecked4 = false;
                                                  volume = data['v2'];
                                                  chosenPrice =
                                                      double.parse(
                                                          data['p2']);
                                                  subdisplay = true;
                                                });
                                                if (value == false) {
                                                  setState(() {
                                                    volume = 'nil';
                                                    chosenPrice = 0.0;
                                                    subdisplay = false;
                                                  });
                                                }
                                                //check
                                                setState(() {
                                                  isChecked1sub = false;
                                                  isChecked2sub = false;
                                                  _qty = 0;
                                                });
                                              }),
                                          Text(
                                              "${data['v2']} - ₹ ${data['p2']}")
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                              checkColor: Colors.white,
                                              fillColor:
                                                  MaterialStateProperty
                                                      .resolveWith(
                                                          getColor),
                                              value: isChecked4,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isChecked1 = false;
                                                  isChecked2 = false;
                                                  isChecked3 = false;
                                                  isChecked4 = value!;
                                                  volume = data['v4'];
                                                  chosenPrice =
                                                      double.parse(
                                                          data['p4']);
                                                  subdisplay = true;
                                                });
                                                if (value == false) {
                                                  setState(() {
                                                    subdisplay = false;
                                                    volume = 'nil';
                                                    chosenPrice = 0.0;
                                                  });
                                                }
                                                //check
                                                setState(() {
                                                  isChecked1sub = false;
                                                  isChecked2sub = false;
                                                  _qty = 0;
                                                });
                                              }),
                                          Text(
                                              "${data['v4']} - ₹ ${data['p4']}")
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 90,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text('Subscription',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            SizedBox(height: 5,),
                            subdisplay ?
                            Container(
                              height: 60,
                              padding: EdgeInsets.only(left: 20, right: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                          checkColor: Colors.white,
                                          fillColor: MaterialStateProperty
                                              .resolveWith(getColor),
                                          value: isChecked1sub,
                                          onChanged: (value) {
                                            setState(() {
                                              cp = chosenPrice;
                                              isChecked1sub = value!;
                                              isChecked2sub = false;
                                              subscriptionType = 'Monthly';
                                              cp = cp * 30;
                                              incdisplay = true;
                                            });
                                            if (value == false) {
                                              setState(() {
                                                subscriptionType = '';
                                                cp = 0;
                                                incdisplay = false;
                                              });
                                            }
                                            //check
                                            setState(() {
                                              _qty = 0;
                                              total = 0;
                                            });
                                            print(total);
                                            print(chosenPrice);
                                          }),
                                      Text("Monthly")
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                          checkColor: Colors.white,
                                          fillColor: MaterialStateProperty
                                              .resolveWith(getColor),
                                          value: isChecked2sub,
                                          onChanged: (value) {
                                            setState(() {
                                              cp = chosenPrice;
                                              isChecked1sub = false;
                                              isChecked2sub = value!;
                                              subscriptionType = 'Yearly';
                                              incdisplay = true;
                                              cp = cp * 365;
                                            });
                                            if (value == false) {
                                              setState(() {
                                                subscriptionType = '';
                                                incdisplay = false;
                                              });
                                            }
                                            //check
                                            setState(() {
                                              _qty = 0;
                                              total = 0;
                                            });
                                            print(total);
                                            print(chosenPrice);
                                          }),
                                      Text("Yearly")
                                    ],
                                  ),
                                ],
                              ),
                            ):Text('Select Volume'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Visibility(
                              visible: incdisplay,
                              child: Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (_qty >= 1) {
                                              setState(() {
                                                _qty -= 1;
                                              });

                                              total = _qty * cp;
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                  color: Colors.orange,
                                                )),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.remove),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 8,
                                              bottom: 8),
                                          child: Text(_qty.toString()),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (_qty >= 0) {
                                              setState(() {
                                                _qty += 1;
                                              });
                                              total = _qty * cp;
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                  color: Colors.orange,
                                                )),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.add),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            //SizedBox(height: 2,),
                            vip =='Yes'?Container(
                              width: double.infinity,
                              child: RaisedButton(
                              onPressed: (){
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        content: const Text(
                                            'Please Contact us to cancel the Subscription.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(
                                                    context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              child: Text('Already Subscribed. Cancel Subscription?'),),)
                                :Container(
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: _cartbutton
                                    ? () {
                                        EasyLoading.show(
                                            status: 'Adding to Cart...');
                                        _cart
                                            .addToCartSubscription(
                                                data: data,
                                                volume: volume,
                                                qty: _qty,
                                                total: total,
                                                subscription:
                                                    subscriptionType)
                                            .then((value) {
                                          EasyLoading.showSuccess(
                                              'Added to Cart');
                                        });
                                        setState(() {
                                          isChecked1 = false;
                                          isChecked2 = false;
                                          isChecked3 = false;
                                          isChecked4 = false;
                                          _cartbutton = false;
                                          isChecked1sub = false;
                                          isChecked2sub = false;
                                          subscriptionType = '';
                                          _qty = 0;
                                          volume = 'nil';
                                        });
                                      }
                                    : () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            content: const Text(
                                                'Please select the required details'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(
                                                        context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                color: _cartbutton
                                    ? Colors.orange[300]
                                    : Colors.grey,
                                padding:
                                    EdgeInsets.symmetric(horizontal: 50),
                                elevation: 2,
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }).toList(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
  MilkGif(){
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('milkscreen').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }

        return ListView(
            physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Card(
              child: Center(
                child: Image.network(data['image'],fit: BoxFit.fill,),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
