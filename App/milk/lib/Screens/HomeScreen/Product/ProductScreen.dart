import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:milk/Screens/HomeScreen/Cart/Cart.dart';
import 'package:milk/Screens/Notifications.dart';
import 'package:milk/models/product_model.dart';
import 'package:milk/services/cart_services.dart';
import 'package:search_page/search_page.dart';

class ProductScreen extends StatefulWidget {
  var pname;
  ProductScreen({this.pname});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool _cartbutton = false;
  bool _itemexist = false;
  int _qty = 0;
  late String _docId;
  late String _checkbox;
  String volume = 'nil';
  var total;

  CartService _cart = CartService();
  User user = FirebaseAuth.instance.currentUser;

  static List<Product> product = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          product.add(Product(
              productName:doc['productName'] ,
              category: doc['category']['mainCategory'],
              image: doc['productImage'],
              snapshot: doc
          ));
        });
      });
    });
    getCartData();
    super.initState();
  }

  getCartData()async{
    final snapshot =await _cart.cart.doc(user.uid).collection('products').get();

  }

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance
        .collection('cart')
    .doc(user.uid).collection('products').where('productName',isEqualTo: widget.pname)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
       if(doc['productName']==widget.pname){
         setState(() {
           _docId = doc.id;
           _itemexist = true;
         });
       }
      });
    });

    setState(() {
      //No product chosen
      if(_qty>0 || volume !='nil'){
        _cartbutton = true;
      }
      if(_qty == 0 || volume =='nil'){
        _cartbutton = false;
      }
      //change in chosen product

    });

    return Scaffold(
      appBar: AppBar(
        title: widget.pname!= null ? Text(widget.pname):Text("productname"),
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage<Product>(
                  onQueryUpdate: (s) => print(s),
                  items: product,
                  searchLabel: 'Search Product',
                  suggestion: Center(
                    child: Text('Filter Product by name or Category'),
                  ),
                  failure: Center(
                    child: Text('No Product found :('),
                  ),
                  filter: (products) => [
                    products.productName,
                    products.category,
                  ],
                  builder: (products) => InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductScreen(pname: products.productName,)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:BorderSide(width: 2.0, color: Colors.black45),
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 80,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 90,
                            child: Image.network(products.image),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            products.productName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => Notifications(),
            ),
          ),

          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cart()),
              );
            },
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 2),
         child: ProductDetails(productname: widget.pname),
      ),
    );

  }
  Widget ProductDetails({productname}){
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
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('products').where('productName',isEqualTo:productname).snapshots();

    return StreamBuilder(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 150,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 150,
                                width: 150,
                                child: Image.network(data['productImage']),
                              ),
                              Container(
                                height: 150,
                                padding: EdgeInsets.only(left: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      data['productName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 20),
                                    ),
                                    Text(
                                      data['brandName'],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '₹'+data['sellingPrice'].toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '₹'+data['ComparedPrice'].toString(),
                                          style: TextStyle(
                                              decoration: TextDecoration.lineThrough),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 80),
                                  child: ExpandableText(data['productDescription'],expandText:'View More',collapseText: 'View Less',maxLines: 2,),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 3,
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Order By ', // default text style
                            children: <TextSpan>[
                              TextSpan(text: todaydate, style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' today & get the delivery by ',),
                              TextSpan(text: tomorrowdate+' .', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Volume",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 120,
                          padding: EdgeInsets.only(left: 20, right: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColor),
                                            value: isChecked1,
                                            onChanged: (value) {
                                              setState(() {
                                                isChecked1 = value!;
                                                isChecked2 = false;
                                                isChecked3 = false;
                                                isChecked4 = false;
                                                volume = data['v1'];
                                                _checkbox = 'isChecked1';
                                              });
                                              if(value == false){
                                                setState(() {
                                                  volume = 'nil';
                                                  _checkbox = 'nil';
                                                });
                                              }
                                            }),
                                        Text(data['v1'])
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
                                            fillColor: MaterialStateProperty.resolveWith(getColor),
                                            value: isChecked2,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked1 = false;
                                                isChecked2 = value!;
                                                isChecked3 = false;
                                                isChecked4 = false;
                                                volume = data['v3'];
                                                _checkbox = 'isChecked2';
                                              });
                                              if(value == false){
                                                setState(() {
                                                  volume = 'nil';
                                                  _checkbox = 'nil';
                                                });
                                              }
                                            }),
                                        Text(data['v3'])
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            checkColor: Colors.white,
                                            fillColor: MaterialStateProperty.resolveWith(getColor),
                                            value: isChecked3,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked1 = false;
                                                isChecked2 = false;
                                                isChecked3 = value!;
                                                isChecked4 = false;
                                                volume = data['v2'];
                                                _checkbox = 'isChecked3';
                                              });
                                              if(value == false){
                                                setState(() {
                                                  volume = 'nil';
                                                  _checkbox = 'nil';
                                                });
                                              }
                                            }),
                                        Text(data['v2'])
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
                                            fillColor: MaterialStateProperty.resolveWith(getColor),
                                            value: isChecked4,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isChecked1 = false;
                                                isChecked2 = false;
                                                isChecked3 = false;
                                                isChecked4 = value!;
                                                volume = data['v4'];
                                                _checkbox = 'isChecked4';
                                              });
                                              if(value == false){
                                                setState(() {
                                                  volume = 'nil';
                                                  _checkbox = 'nil';
                                                });
                                              }
                                            }),
                                        Text(data['v4'])
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
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
                            onTap: (){
                              if(_qty>=1){
                                setState(() {
                                  _qty -=1;
                                });
                                total = _qty * data['sellingPrice'];
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
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
                              padding:
                              EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                              child:Text(_qty.toString()),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              if(_qty >= 0){
                                setState(() {
                                  _qty+=1;
                                });
                                total = _qty * data['sellingPrice'];
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
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
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RaisedButton(
                              onPressed: _cartbutton ? (){
                                EasyLoading.show(status: 'Adding to Cart...');
                                if(_itemexist == true){
                                  //remove
                                  //_cart.removeFromCart(docId: _docId);
                                  _cart.addToCart(data: data,volume: volume,qty: _qty,checkbox: _checkbox,total: total).then((value){
                                    EasyLoading.showSuccess('Added to Cart');
                                  });
                                }if(_itemexist == false){
                                  _cart.addToCart(data: data,volume: volume,qty: _qty,checkbox: _checkbox,total: total).then((value){
                                    EasyLoading.showSuccess('Added to Cart');
                                  });
                                }
                                print('added to cart');
                              }:(){
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    content: const Text('Please enter Volume and Quantity'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              color: _cartbutton? Colors.orange[300]:Colors.grey,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              elevation: 2,
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(
                                    fontSize: 14, letterSpacing: 2.2, color: Colors.black),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                );

              }).toList(),);
          }
          return Center(child: CircularProgressIndicator(),);

        });
  }

}

