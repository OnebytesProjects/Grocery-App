import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MilkWidget extends StatelessWidget {
  const MilkWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: _services.milkscreen.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          width: double.infinity,
          height: 300,
          child: GridView.count(
            scrollDirection: Axis.vertical,
            crossAxisCount: 3,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Card(
                          elevation: 10,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(data['image'],width: 400,fit: BoxFit.fill,)),
                        ),
                      ),
                      Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: (){
                                _services.confirmDeleteMilk(
                                  context: context,
                                  title: 'Confirm',
                                  message: 'Confirm Deletion?',
                                  id: document.id,
                                );
                              },
                              icon: Icon(Icons.delete,color: Colors.red,),
                            ),
                          ))
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}