import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';

class CancelationRefund extends StatelessWidget {
  const CancelationRefund({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacementNamed(context, MainScreen.id);
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                        height: 195,
                        width: double.infinity,
                        child: FittedBox(
                          child: Image.asset('images/2.jpg'),
                          fit: BoxFit.fill,
                        )
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text('Cancellation and Refund',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('1.	Cancellation of orders: Once ordered, Cancellation can be done only within the given time. Late cancellation are charged for penalty.',
                    style: TextStyle(fontSize: 15),),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('2.	Cancellation of subscription: If you want to cancel the subscription you can get the guidelines from our team.',
                    style: TextStyle(fontSize: 15),),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('3.	Refund policy: You can the refund amount through the same mode you paid (NOTE : terms and condition applied )',
                    style: TextStyle(fontSize: 15),),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Content() {
    CollectionReference sidebarcontent =
    FirebaseFirestore.instance.collection('sidebarcontent');
    return StreamBuilder<QuerySnapshot>(
      stream: sidebarcontent.where('type', isEqualTo: 'Cancellation').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return Container(
              child: Text(data['Content']),
            );
          }).toList(),
        );
      },
    );
  }
}
