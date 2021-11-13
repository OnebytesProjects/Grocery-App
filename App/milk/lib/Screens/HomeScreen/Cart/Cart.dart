import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/checkout/checkout.dart';
import 'package:milk/providers/cart__provider.dart';
import 'package:milk/services/cart_services.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  late String _docId;
  TextEditingController _coupon = TextEditingController();
  late double carttotal;
  late double deliverycharge;
  double discount = 0.0;
  bool updating = false;



  @override
  Widget build(BuildContext context) {

    var cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartTotal();

    setState(() {
      this.carttotal = cartProvider.subTotal;
      this.deliverycharge = cartProvider.deliverycharge;
    });

    return Scaffold(
        appBar: AppBar(
          title: Text("Cart"),
          backgroundColor: Colors.grey[800],
        ),
        body: Container(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                CartCard(),
              ],
            ),
          ),
        ),
      bottomSheet: BillDetails(),
    );
  }

  Widget CartCard() {
   CartService _cart = CartService();

   return StreamBuilder<QuerySnapshot>(
       stream: _cart.cart.doc(_cart.user.uid).collection('products').snapshots(),
       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

         if (snapshot.hasError) {
           return Text('Something went wrong');
         }

         if(!snapshot.hasData){
           return Center(child: Text('Cart is Empty. Continue Shopping?'),);
         }
         return ListView(
           shrinkWrap: true,
           children: snapshot.data!.docs.map((DocumentSnapshot document) {
             Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

             int cartvalue = data['qty'];

             User user = FirebaseAuth.instance.currentUser;

             FirebaseFirestore.instance
                 .collection('cart')
                 .doc(user.uid).collection('products').where('productName',isEqualTo:data['productName'])
                 .get()
                 .then((QuerySnapshot querySnapshot) {
               querySnapshot.docs.forEach((doc) {
                 if(doc['productName']==data['productName']){
                   _docId = doc.id;
                 }
               });
             });

             return Container(
               child: Container(
                 padding: EdgeInsets.all(10),
                 width: double.infinity,
                 height: 100,
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: <Widget>[
                     Container(
                       height: 100,
                       width: 90,
                       child: Image.network(data['productImage']),
                     ),
                     SizedBox(
                       width: 10,
                     ),
                     Column(
                       children: [
                         Text(
                           data['productName'],
                           style: TextStyle(fontWeight: FontWeight.bold),
                         ),
                         SizedBox(
                           height: 10,
                         ),
                         Text(data['productVolume']),
                         SizedBox(
                           height: 10,
                         ),
                         Text(
                           '₹'+data['sellingPrice'].toString(),
                           style: TextStyle(fontWeight: FontWeight.bold),
                         ),
                       ],
                     ),

                     Column(
                       children: [
                         Container(
                             padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                             child: Container(
                               margin: EdgeInsets.only(left: 10, right: 10),
                               height: 50,
                               child: Padding(
                                 padding: const EdgeInsets.all(10.0),
                                 child: FittedBox(
                                   child: Row(
                                     children: [
                                       InkWell(
                                         onTap: (){
                                           updating = true;
                                           if(cartvalue>=1){
                                             setState(() {
                                               cartvalue -=1;
                                             });
                                             var total = cartvalue * data['sellingPrice'];
                                             _cart.updateCartqty(docId: _docId,qty: cartvalue,total: total).then((value){
                                               setState(() {
                                                 updating = false;
                                               });
                                             });
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
                                           child: Text(cartvalue.toString()),
                                         ),
                                       ),
                                       InkWell(
                                         onTap: (){
                                           updating = true;
                                           if(cartvalue>=0){
                                             setState(() {
                                               cartvalue +=1;
                                             });
                                             var total = cartvalue * data['sellingPrice'];
                                             _cart.updateCartqty(docId: _docId,qty: cartvalue,total: total).then((value){
                                               setState(() {
                                                 updating = false;
                                               });
                                             });
                                           }
                                           print('add');
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
                             )),
                         InkWell(
                           onTap: (){
                             print('product removed');
                             _cart.removeFromCart(docId: _docId);
                           },
                           child: Container(
                               height: 30,
                               width: 60,
                               color: Colors.orange[300],
                               child: Center(child: Text('Remove',style: TextStyle(fontSize: 10),),)
                           ),
                         ),
                       ],
                     )
                   ],
                 ),
               ),
             );
           }).toList(),
         );

  });
  }

  Widget BillDetails() {
    return Container(
      width: double.infinity,
      height: 80,
      padding: EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 80,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Value",style: TextStyle(fontSize: 10,color: Colors.grey),),
                    Text('₹ '+carttotal.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  ],
                ),
              ),
              Container(
                height: 80,
                width: 180,
                child: RaisedButton(
                  onPressed: () {
                    print("proceed to buy");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Checkout(cartValue: carttotal,delivryCharge: deliverycharge,)),
                    );
                  },
                  color: Colors.orange[300],
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 2,
                  child: Text(
                    "Continue",
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
      ),
    );
  }
}
