import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:milk/Screens/HomeScreen/ProductList/ProductList.dart';
import 'package:milk/Screens/HomeScreen/Home/CarouselSlider.dart';
import 'package:milk/services/product_service.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  var _productList = '0';
  bool showAd = true;
  String adimage = '';

  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    //get milkgif
    FirebaseFirestore.instance
        .collection('ad')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        this.adimage = doc['image'];
      });
    });

    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()async{
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBackPressed = DateTime.now();

        if(isExitWarning){
          final message = 'Press Back Again To Exit.';
          Fluttertoast.showToast(msg: message,fontSize: 18);
          return false;
        }else{
          Fluttertoast.cancel();
          return true;
        }

      },
      child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //carousel
                  SizedBox(
                    width: double.infinity,
                    height: 175,
                    child: CarouselSliderView(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //categories
                  SizedBox(width: double.infinity,
                      height: 130,
                      child: Category()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Products",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //products
                  SizedBox(width: double.infinity,
                      height: 480,
                      child: ProductList(
                        condition: _productList,
                      )),
                ],
              ),
            ),
          )),
    );
  }

  //Categories

  Widget Category() {
    //final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
    ProductService _services = ProductService();
    return FutureBuilder(
        future: _services.category.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    setState(() {
                      _productList = document['name'];
                    });
                  },
                  child: SizedBox(
                    width: 110,
                    //color: Colors.orange,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right:BorderSide(width: 2.0, color: Colors.black45),
                        ),
                      ),
                      padding: EdgeInsets.all(5),
                      width: 100.0,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            height: 80,
                            //color: Colors.green,
                            child: Image.network(document['image']),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          document['name']=='0'?Text('Milk'):
                          document['name']=='Z'?Text('All Products'):
                          Text(document['name'])
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }


}
