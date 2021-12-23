import 'package:flutter/material.dart';

class UpdateAvailable extends StatelessWidget {
  static const String id = 'updatescreen';
  const UpdateAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Please Update Your App to continue."),),
    );
  }
}
