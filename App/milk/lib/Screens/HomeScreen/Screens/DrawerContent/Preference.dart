import 'package:flutter/material.dart';

class Preference extends StatefulWidget {
  @override
  State<Preference> createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  @override
  String _deliveryOption = 'Ring Door Bell';

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(35, 35, 0, 0),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                cardVeiw("Ring Door Bell", "prf1.png"),
                cardVeiw("Drop At The Door", "prf2.png"),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                cardVeiw("In Hand Delivery", "prf3.png"),
                cardVeiw("Keep In The Bag", "prf4.png"),
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
            Container(
              child: Center(
                child: FlatButton(
                  onPressed: () {
                    print(_deliveryOption);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  color: Colors.orange[300],
                ),
              ),
            )
          ],
        ),
      ),
    );
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
            setState(() {
              _deliveryOption = title;
            });
          },
        ),
      ),
    );
  }
}
