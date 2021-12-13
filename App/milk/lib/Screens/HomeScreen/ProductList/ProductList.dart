import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/Product/ProductScreen.dart';
import 'package:milk/Screens/HomeScreen/ProductList/AllProducts.dart';
import 'package:milk/Screens/HomeScreen/ProductList/milkscreen.dart';

class ProductList extends StatefulWidget {
  var condition ;
  ProductList({this.condition});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {


  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('products').where('category.mainCategory',isEqualTo:widget.condition).where('published',isEqualTo:true).snapshots();

    return widget.condition=='0'?MilkDisplay():
    widget.condition=='Z'?AllProducts():
    StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              scrollDirection: Axis.vertical,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:BorderSide(width: 2.0, color: Colors.black45),
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                        width: 90,
                        child: Image.network(data['productImage']),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['productName'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(data['ProductQuantity'].toString()),
                          SizedBox(
                            height: 10,
                          ),
                          Row(children: [
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
                          ]),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(30, 10,0, 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductScreen(pname: data['productName'],)),
                            );
                          },
                          child: Card(
                            color: Colors.orange[300],
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 7, bottom: 7),
                              child: Text(
                                "View",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
