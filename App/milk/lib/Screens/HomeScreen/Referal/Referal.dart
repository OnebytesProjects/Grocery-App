import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:share_plus/share_plus.dart';

class Referal extends StatefulWidget {
  @override
  State<Referal> createState() => _ReferalState();
}

class _ReferalState extends State<Referal> {
  TextEditingController _controller =  TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot)
    {
      _controller.text = documentSnapshot['referal'];
    });


    return Scaffold(
      body: Card(
        shadowColor: Colors.grey,
        margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Container(
          padding: EdgeInsets.all(10),
          height: 200,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Referal Code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _controller,
                        enabled: false,
                      )),
                  IconButton(
                      onPressed: () async {
                        await FlutterClipboard.copy(_controller.text);
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Copied To Clipboard')));
                      },
                      icon: Icon(Icons.content_copy))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: FlatButton(
                    onPressed: () async {
                      await Share.share(_controller.text);
                    },
                    child: Text(
                      "Share",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    color: Colors.orange[300],
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
