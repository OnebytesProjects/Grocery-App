import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';
import 'package:milk/Screens/SplashScreen/Onboard.dart';
import 'package:milk/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'welcome';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool _validmobilenumber = false;
    var _phoneNumberController = TextEditingController();

    void BottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter myState) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: auth.error == 'Invalid OTP' ? true : false,
                    child: Container(
                      child: Column(
                        children: [
                          Text(auth.error),
                          SizedBox(height: 3),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text('Enter your mobile number',
                      style: TextStyle(fontSize: 12)),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      prefixText: '+91',
                      labelText: '10 digit number',
                    ),
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    controller: _phoneNumberController,
                    onChanged: (value) {
                      if (value.length == 10) {
                        myState(() {
                          _validmobilenumber = true;
                        });
                      } else {
                        myState(() {
                          _validmobilenumber = false;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: AbsorbPointer(
                        absorbing: _validmobilenumber ? false : true,
                        child: FlatButton(
                            onPressed: () {
                              String number =
                                  "+91${_phoneNumberController.text}";
                              auth.verifyPhone(context, number).then((value) {
                                _phoneNumberController.clear();
                              });
                            },
                            child: Text('Proceed'),
                            color: _validmobilenumber
                                ? Colors.orange[300]
                                : Colors.grey),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(child: OnBoard()),
            SizedBox(
              height: 20,
            ),
            Text("Ready To Order?"),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.orange[300],
              child: Text("Login"),
              onPressed: () {
                BottomSheet(context);
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
