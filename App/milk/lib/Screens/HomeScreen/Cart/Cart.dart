import 'package:cloud_firestore/cloud_firestore.dart';
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
  late double carttotal;
  late double deliverycharge;
  double discount = 0.0;
  bool updating = false;



  @override
  Widget build(BuildContext context) {

    var cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartTotal();

    setState(() {
      carttotal = cartProvider.subTotal;
      deliverycharge = cartProvider.deliverycharge;
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text("Cart"),
          backgroundColor: Colors.grey[800],
        ),
        body: GestureDetector(
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
      bottomSheet: BillDetails(),
    );
  }

  Widget CartCard() {
   CartService _cart = CartService();

   return StreamBuilder<QuerySnapshot>(
       stream: _cart.cart.doc(_cart.user?.uid).collection('products').snapshots(),
       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

         if (snapshot.hasError) {
           return const Text('Something went wrong');
         }

         if(!snapshot.hasData){
           return const Center(child: Text('Cart is Empty. Continue Shopping?'),);
         }
         if(snapshot.hasData){
           return ListView(
             shrinkWrap: true,
             children: snapshot.data!.docs.map((DocumentSnapshot document) {
               Map<String, dynamic> data = document.data()! as Map<String, dynamic>;;

               int cartvalue = data['qty'];

               return Container(
                 decoration: BoxDecoration(
                   border: Border(
                     bottom:BorderSide(width: 2.0, color: Colors.black45),
                   ),
                 ),
                 padding: const EdgeInsets.all(10),
                 width: double.infinity,
                 height: 102,
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
                           '₹'+data['total'].toString(),
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
                                   child: Text('Quantity :${data['qty']} ')
                                 // FittedBox(
                                 //   child: Row(
                                 //     children: [
                                 //       InkWell(
                                 //         onTap: (){
                                 //           _docId = document.id;
                                 //           if(cartvalue>=1){
                                 //             setState(() {
                                 //               cartvalue -=1;
                                 //               updating = true;
                                 //             });
                                 //             if(cartvalue == 0){
                                 //               _cart.removeFromCart(docId: _docId);
                                 //             }
                                 //             var total = cartvalue * data['sellingPrice'];
                                 //             _cart.incproducts(_docId, cartvalue);
                                 //             _cart.updateCartqty(docId: _docId,qty: cartvalue,total: total).then((value){
                                 //               setState(() {
                                 //                 updating = false;
                                 //               });
                                 //             });
                                 //           }
                                 //         },
                                 //         child: Container(
                                 //           decoration: BoxDecoration(
                                 //               borderRadius: BorderRadius.circular(50),
                                 //               border: Border.all(
                                 //                 color: Colors.orange,
                                 //               )),
                                 //           child: Padding(
                                 //             padding: EdgeInsets.all(8.0),
                                 //             child: Icon(Icons.remove),
                                 //           ),
                                 //         ),
                                 //       ),
                                 //       Container(
                                 //         width: 30,
                                 //         child: Center(
                                 //           child: FittedBox(
                                 //             child: Text(cartvalue.toString())
                                 //         //     child: updating?Padding(
                                 //         //   padding: const EdgeInsets.all(8.0),
                                 //         //   child: CircularProgressIndicator(),
                                 //         // ):Text(cartvalue.toString())
                                 //           ,),),
                                 //       ),
                                 //       InkWell(
                                 //         onTap: (){
                                 //           if(cartvalue>=0){
                                 //             setState(() {
                                 //               cartvalue +=1;
                                 //               updating = true;
                                 //             });
                                 //             var total = cartvalue * data['sellingPrice'];
                                 //             _docId = document.id;
                                 //             _cart.updateCartqty(docId: _docId,qty: cartvalue,total: total).then((value){
                                 //               setState(() {
                                 //                 updating = false;
                                 //               });
                                 //             });
                                 //           }
                                 //           print('add');
                                 //         },
                                 //         child: Container(
                                 //           decoration: BoxDecoration(
                                 //               borderRadius: BorderRadius.circular(50),
                                 //               border: Border.all(
                                 //                 color: Colors.orange,
                                 //               )),
                                 //           child: Padding(
                                 //             padding: EdgeInsets.all(8.0),
                                 //             child: Icon(Icons.add),
                                 //           ),
                                 //         ),
                                 //       ),
                                 //     ],
                                 //   ),
                                 // ),
                               ),
                             )),
                         InkWell(
                           onTap: (){
                             _docId = document.id;
                             _cart.removeFromCart(docId: _docId,qty: data['qty'],productid: data['productid']);
                             print(_docId);
                           },
                           child: Container(
                               height: 30,
                               width: 60,
                               color: Colors.orange[300],
                               child: const Center(child: Text('Remove',style: TextStyle(fontSize: 10),),)
                           ),
                         ),
                       ],
                     )
                   ],
                 ),
               );
             }).toList(),
           );
         }
         return const Center(child: Text('Cart is Empty. Continue Shopping?'),);

  });
  }

  Widget BillDetails() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top:BorderSide(width: 2.0, color: Colors.black45),
        ),
      ),
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.all(8),
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
                  const Text("Total Value",style: TextStyle(fontSize: 10,color: Colors.grey),),
                  Text('₹ '+carttotal.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  SizedBox(height: 1,),
                  GestureDetector(
                      onTap: (){
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context){
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView(
                                children: [
                                  Text("Convenience Fee",style: TextStyle(fontSize: 20),),
                                  SizedBox(height: 5,),
                                  Divider(),
                                  Row(
                                    children: [
                                      Text("Lorem Ipsum adgbahjdikaj"),
                                    ],
                                  )

                                ],
                              ),
                            ),
                          );
                        });
                      },
                      child: const Text("Convenience fee",style: TextStyle(fontSize: 10,color: Colors.grey),)),
                ],
              ),
            ),
            Container(
              height: 80,
              width: 180,
              child: RaisedButton(
                onPressed: () {
                  // print("proceed to buy");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Checkout(cartValue: carttotal)),
                  );
                },
                color: Colors.orange[300],
                padding: const EdgeInsets.symmetric(horizontal: 50),
                elevation: 2,
                child: const Text(
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
    );
  }
}
