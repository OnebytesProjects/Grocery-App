import 'package:admin/Screens/Vendor/productP_UP/edit_view_product.dart';
import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnpublishedProducts extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Container(
      child: StreamBuilder(
        stream:
            _services.products.where('published', isEqualTo: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: Row(
                                  children: [
                                    Text("Name: ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                    Text(data['productName'],style: TextStyle(fontSize: 15),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: 50,
                              width: 50,
                              color: Colors.white,
                              child: Center(
                                child: Image.network(data['productImage']),
                              ),
                          ),
                          popUpButton(data,context),
                        ],
                      ),
                    ),
                    Divider(thickness: 3,)
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }


  Widget popUpButton(data,BuildContext context){
    FirebaseServices _services = FirebaseServices();

    return PopupMenuButton<String>(
        onSelected: (String value){
          if(value == 'published'){
            _services.publishProduct(id: data['productid']);
          }
          if(value == 'preview/edit'){
            print(value);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditViewProduct(productId: data['productid'],productImage: data['productImage'],)));
          }
          if(value == 'delete'){
            _services.deleteProduct(id: data['productid']);
          }
        },
        itemBuilder: (BuildContext context)=><PopupMenuEntry<String>>[
          const PopupMenuItem(
            value: 'published',
            child: ListTile(
              leading: Icon(Icons.check),
              title: Text('Publish'),
            ),),
          const PopupMenuItem(
            value: 'preview/edit',
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

