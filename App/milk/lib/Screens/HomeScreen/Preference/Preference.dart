import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';

class Preference extends StatefulWidget {
  @override
  State<Preference> createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  String _deliveryOption = 'Ring Door Bell';

  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) =>
            {this._deliveryOption = documentSnapshot['preference']});

    return WillPopScope(
        onWillPop: ()async{
      Navigator.pushReplacementNamed(context, MainScreen.id);
      return true;
    },
    child:Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(35, 35, 0, 0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                cardVeiw("Ring Door Bell", "prf1.jpg"),
                cardVeiw("Drop At The Door", "prf2.jpg"),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                cardVeiw("In Hand Delivery", "prf3.jpg"),
                cardVeiw("Keep In The Bag", "prf4.jpg"),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "Delivery Mode:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _deliveryOption,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ));
  }

  Widget cardVeiw(String title, String image) {
    return Card(
      child: Container(
        width: 150,
        height: 130,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 5),
            )
          ],
          image: DecorationImage(
            image: AssetImage("images/$image"),
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
          ),
        ),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            users
                .doc(_auth.currentUser?.uid)
                .update({'preference': title});

            setState(() {
              _deliveryOption = title;
            });
          },
        ),
      ),
    );
  }
}
