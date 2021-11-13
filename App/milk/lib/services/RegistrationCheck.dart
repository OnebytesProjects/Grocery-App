import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';
import 'package:milk/Screens/HomeScreen/Profile/Profile.dart';
import 'package:milk/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RegistrationCheck extends StatefulWidget {
  const RegistrationCheck({Key? key}) : super(key: key);

  @override
  _RegistrationCheckState createState() => _RegistrationCheckState();
}

class _RegistrationCheckState extends State<RegistrationCheck> {
  bool registered = false;
  String _username = '';
  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    userDetails.getUserDetails();

    _username = userDetails.snapshot.data()['name'];

    if (_username == "null") {
      print("username null");
      print(_username);
    } else {
      print("username not null");
      registered = true;
    }

    return Scaffold(
      body: registered ? MainScreen() : Profile(),
    );
  }
}
