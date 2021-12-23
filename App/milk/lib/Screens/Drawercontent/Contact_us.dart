import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String address = '';
  String number = '';
  String whatsapp = '';
  String email = '';
  String deliveryboyname = '';
  String deliveryboynumber = '';

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('sidebarcontent')
        .doc('ContactUs')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          address = documentSnapshot['Address'];
          number = documentSnapshot['Number'];
          whatsapp = documentSnapshot['Whatsapp'];
          email = documentSnapshot['Email'];
        });
      }
    });
    FirebaseFirestore.instance
        .collection('deliveryBoy')
        .doc('DeliveryMan')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          deliveryboyname = documentSnapshot['name'];
          deliveryboynumber = documentSnapshot['mobile'].toString();
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: 400,
                    width: double.infinity,
                    color: Colors.grey[800],
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Contact Us',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: 125,
                          height: 125,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage("images/splscrn.png"),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: Icon(Icons.location_on_outlined,color: Colors.white,),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(address,style: TextStyle(fontSize: 15,color: Colors.white),),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Support',style: TextStyle(fontSize: 15,color: Colors.white),),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(onPressed: (){
                              launch('tel:${number}');
                            },child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(Icons.phone),
                                  SizedBox(height: 5,),
                                  Text('Call'),
                                ],
                              ),
                            ),),
                            RaisedButton(onPressed: (){
                              //launchWhatsApp(phone: 9486062525);
                              //openwhatsapp();
                              launch('whatsapp://send?phone=${whatsapp}&text=hello');
                            },child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(Icons.message),
                                  SizedBox(height: 5,),
                                  Text('Whatsapp'),
                                ],
                              ),
                            ),),
                            RaisedButton(onPressed: (){
                              launch('mailto:${email}?subject= &body= ');
                            },child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Icon(Icons.email),
                                  SizedBox(height: 5,),
                                  Text('Email'),
                                ],
                              ),
                            ),),
                          ],
                        )

                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('MilkMan Details',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey)
                  ),
                  width: double.infinity,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage("images/profile.jpg"),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(deliveryboyname),
                            Text(deliveryboynumber),
                          ],
                        ),
                        IconButton(onPressed: (){
                          launch('tel:${deliveryboynumber}');
                        }, icon: Icon(Icons.call))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

