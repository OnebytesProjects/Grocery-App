import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:milk/models/product_model.dart';
import 'package:milk/services/cart_services.dart';
import 'package:video_player/video_player.dart';

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
  String subscriptionType = '';
  int _qty = 0;
  late String _docId;
  String volume = 'nil';
  String vip = '';
  double chosenPrice = 0.0;
  bool _chosenprice = false;
  var total;

  CartService _cart = CartService();
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;

  static List<Product> product = [];

  late VideoPlayerController videocontroller;

  @override
  void initState() {
    //videoplayer
    videocontroller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      })
      ..setLooping(true)
      ..initialize().then((_) => videocontroller.play());
    super.initState();
  }

  @override
  void dispose() {
    videocontroller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    //check vip
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) =>
    {this.vip = documentSnapshot['vip']});

    setState(() {
      if (_qty > 0 || volume != 'nil' || subscriptionType != '') {
        _cartbutton = true;
      }
      if (_qty == 0 || volume == 'nil' || subscriptionType == '') {
        _cartbutton = false;
      }
    });
    return SingleChildScrollView(
      child: Container(
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
              child: Text('asd'),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Container(
                  child: Column(
                    children: [
                      Container(
                        height: 240,
                        width: double.infinity,
                        child: Card(
                          child: Center(
                            child: Image.network('https://media.wired.com/photos/5b45021f3808c83da3503cc7/master/w_1600,c_limit/tumblr_inline_mjx5ioXh8l1qz4rgp.gif'),
                          ),
                        ),
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
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Container(
                                child: Center(
                                  child: Text(
                                    "Volume",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
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
                                                  });
                                                  if (value == false) {
                                                    setState(() {
                                                      volume = 'nil';
                                                      chosenPrice = 0.0;
                                                    });
                                                  }
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
                                                  });
                                                  if (value == false) {
                                                    setState(() {
                                                      volume = 'nil';
                                                      chosenPrice = 0.0;
                                                    });
                                                  }
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
                                        Container(
                                          child: Row(
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
                                                    });
                                                    if (value == false) {
                                                      setState(() {
                                                        volume = 'nil';
                                                        chosenPrice = 0.0;
                                                      });
                                                    }
                                                  }),
                                              Text(
                                                  "${data['v2']} - ₹ ${data['p2']}")
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: Row(
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
                                                    });
                                                    if (value == false) {
                                                      setState(() {
                                                        volume = 'nil';
                                                        chosenPrice = 0.0;
                                                      });
                                                    }
                                                  }),
                                              Text(
                                                  "${data['v4']} - ₹ ${data['p4']}")
                                            ],
                                          ),
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
                        child: Container(
                          height: 80,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text('Subscription',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Container(
                                height: 50,
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
                                                isChecked1sub = value!;
                                                isChecked2sub = false;
                                                subscriptionType = 'Monthly';
                                              });
                                              if (value == false) {
                                                setState(() {
                                                  subscriptionType = '';
                                                });
                                              }
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
                                                isChecked1sub = false;
                                                isChecked2sub = value!;
                                                subscriptionType = 'Yearly';
                                              });
                                              if (value == false) {
                                                setState(() {
                                                  subscriptionType = '';
                                                });
                                              }
                                            }),
                                        Text("Yearly")
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
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
                                              if (_chosenprice) {
                                                total = _qty * chosenPrice;
                                              } else {
                                                total =
                                                    _qty * data['sellingPrice'];
                                              }
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
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 8,
                                                bottom: 8),
                                            child: Text(_qty.toString()),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (_qty >= 0) {
                                              setState(() {
                                                _qty += 1;
                                              });
                                              if (_chosenprice) {
                                                total = _qty * chosenPrice;
                                              } else {
                                                total =
                                                    _qty * data['sellingPrice'];
                                              }
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
                              //SizedBox(height: 2,),
                              vip =='Yes'?Container(child: Text('Already Subscribed.'),):Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
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
                                            print('added to cart');
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
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

// Column(
// children: [
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// width: double.infinity,
// padding: EdgeInsets.all(8),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Padding(
// padding: EdgeInsets.only(top: 8, bottom: 80),
// //child: ExpandableText(data['productDescription'],expandText:'View More',collapseText: 'View Less',maxLines: 2,),
// child: ExpandableText('description',expandText:'View More',collapseText: 'View Less',maxLines: 2,),
// ),
// ],
// ),
// ),
// ),
//
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Text.rich(
// TextSpan(
// text: 'Order By ', // default text style
// children: <TextSpan>[
// TextSpan(text: todaydate, style: TextStyle(fontWeight: FontWeight.bold)),
// TextSpan(text: ' today & get the delivery by ',),
// TextSpan(text: tomorrowdate+' .', style: TextStyle(fontWeight: FontWeight.bold)),
// ],
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// height: 150,
// width: double.infinity,
// color: Colors.white,
// child: Column(
// children: [
// Container(
// child: Center(child: Text(
// "Volume",
// style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
// ),),
// ),
// Container(
// height: 120,
// padding: EdgeInsets.only(left: 20, right: 50),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// Checkbox(
// checkColor: Colors.white,
// fillColor: MaterialStateProperty.resolveWith(getColor),
// value: isChecked1,
// onChanged: (value) {
// setState(() {
// isChecked1 = value!;
// isChecked2 = false;
// isChecked3 = false;
// isChecked4 = false;
// //volume = data['v1'];
// volume = 'a';
// //chosenPrice = double.parse(data['p1']);
// });
// if(value == false){
// setState(() {
// volume = 'nil';
// chosenPrice = 0.0;
// });
// }
// }),
// //Text("${data['v1']} - ₹ ${data['p1']}")
// ],
// ),
// SizedBox(
// height: 10,
// ),
// Row(
// children: [
// Checkbox(
// checkColor: Colors.white,
// fillColor: MaterialStateProperty.resolveWith(getColor),
// value: isChecked2,
// onChanged: (bool? value) {
// setState(() {
// isChecked1 = false;
// isChecked2 = value!;
// isChecked3 = false;
// isChecked4 = false;
// // volume = data['v3'];
// volume = 'a';
// // chosenPrice = double.parse(data['p3']);
// });
// if(value == false){
// setState(() {
// volume = 'nil';
// chosenPrice = 0.0;
// });
// }
// }),
// //Text("${data['v3']} - ₹ ${data['p3']}")
// ],
// ),
// ],
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Container(
// child: Row(
// children: [
// Checkbox(
// checkColor: Colors.white,
// fillColor: MaterialStateProperty.resolveWith(getColor),
// value: isChecked3,
// onChanged: (bool? value) {
// setState(() {
// isChecked1 = false;
// isChecked2 = false;
// isChecked3 = value!;
// isChecked4 = false;
// // volume = data['v2'];
// volume = 'a';
// // chosenPrice = double.parse(data['p2']);
// });
// if(value == false){
// setState(() {
// volume = 'nil';
// chosenPrice = 0.0;
// });
// }
// }),
// //Text("${data['v2']} - ₹ ${data['p2']}")
// ],
// ),
// ),
// SizedBox(
// height: 10,
// ),
// Container(
// child: Row(
// children: [
// Checkbox(
// checkColor: Colors.white,
// fillColor: MaterialStateProperty.resolveWith(getColor),
// value: isChecked4,
// onChanged: (bool? value) {
// setState(() {
// isChecked1 = false;
// isChecked2 = false;
// isChecked3 = false;
// isChecked4 = value!;
// // volume = data['v4'];
// volume = 'a';
// // chosenPrice = double.parse(data['p4']);
// });
// if(value == false){
// setState(() {
// volume = 'nil';
// chosenPrice = 0.0;
// });
// }
// }),
// //Text("${data['v4']} - ₹ ${data['p4']}")
// ],
// ),
// ),
// ],
// )
// ],
// ),
// ),
// ],
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// height: 80,
// width: double.infinity,
// color: Colors.white,
// child: Column(
// children: [
// Text('Subscription',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
// Container(
// height: 50,
// padding: EdgeInsets.only(left: 20, right: 50),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// Row(
// children: [
// Checkbox(
// checkColor: Colors.white,
// fillColor: MaterialStateProperty.resolveWith(getColor),
// value: isChecked1sub,
// onChanged: (value) {
// setState(() {
// isChecked1sub = value!;
// isChecked2sub = false;
// subscriptionType = 'Monthly';
// });
// if(value == false){
// setState(() {
// subscriptionType = '';
// });
// }
// }),
// Text("Monthly")
// ],
// ),
// Row(
// children: [
// Checkbox(
// checkColor: Colors.white,
// fillColor: MaterialStateProperty.resolveWith(getColor),
// value: isChecked2sub,
// onChanged: (value) {
// setState(() {
// isChecked1sub = false;
// isChecked2sub = value!;
// subscriptionType = 'Yearly';
// });
// if(value == false){
// setState(() {
// subscriptionType = '';
// });
// }
// }),
// Text("Yearly")
// ],
// ),
// ],
// ),
// ),
// ],
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: Container(
// height: 100,
// width: double.infinity,
// color: Colors.white,
// child: Column(
// children: [
// Container(
// margin: EdgeInsets.only(left: 10, right: 10),
// height: 50,
// child: Padding(
// padding: const EdgeInsets.all(10.0),
// child: FittedBox(
// child: Row(
// children: [
// InkWell(
// onTap: (){
// if(_qty>=1){
// setState(() {
// _qty -=1;
// });
// if(_chosenprice){
// total = _qty * chosenPrice;
// }else{
// //total = _qty * data['sellingPrice'];
// }
// }
// },
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(50),
// border: Border.all(
// color: Colors.orange,
// )),
// child: Padding(
// padding: EdgeInsets.all(8.0),
// child: Icon(Icons.remove),
// ),
// ),
// ),
// Container(
// child: Padding(
// padding:
// EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
// child:Text(_qty.toString()),
// ),
// ),
// InkWell(
// onTap: (){
// if(_qty >= 0){
// setState(() {
// _qty+=1;
// });
// if(_chosenprice){
// total = _qty * chosenPrice;
// }else{
// //total = _qty * data['sellingPrice'];
// }
//
// }
// },
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(50),
// border: Border.all(
// color: Colors.orange,
// )),
// child: Padding(
// padding: EdgeInsets.all(8.0),
// child: Icon(Icons.add),
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [
// RaisedButton(
// onPressed: _cartbutton ? (){
// // EasyLoading.show(status: 'Adding to Cart...');
// // _cart.addToCartSubscription(data: data,volume: volume,qty: _qty,total: total,subscription: subscriptionType).then((value){
// //   EasyLoading.showSuccess('Added to Cart');
// // });
// // print('added to cart');
// }:(){
// showDialog<String>(
// context: context,
// builder: (BuildContext context) => AlertDialog(
// content: const Text('Please select the required details'),
// actions: <Widget>[
// TextButton(
// onPressed: () => Navigator.pop(context, 'OK'),
// child: const Text('OK'),
// ),
// ],
// ),
// );
// },
// color: _cartbutton? Colors.orange[300]:Colors.grey,
// padding: EdgeInsets.symmetric(horizontal: 50),
// elevation: 2,
// child: Text(
// "Add to Cart",
// style: TextStyle(
// fontSize: 14, letterSpacing: 2.2, color: Colors.black),
// ),
// ),
// ],
// )
// ],
// ),
// ),
// )
// ],
//),
