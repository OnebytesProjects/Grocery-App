import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';

class TermsofUse extends StatelessWidget {
  const TermsofUse({Key? key}) : super(key: key);

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
                Text('Terms of Use',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('1. Cleaning bottles: Milk delivered in the bottles should be regularly washed atleast once either with normal or warm water in order to avoid any pathogenic contamination before sterilization process by our team.',
                    style: TextStyle(fontSize: 15),),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('2. Breakage of bottles: Incase of any damage or breakage to bottles kindly inform the same either via the app or in person to the delivery man for bottles record and kindly pay the breakage amount of RS.40 via the same mode within a stipulated time period of 2-3 days.',
                    style: TextStyle(fontSize: 15),),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('3. Ordering Timings:  Milk should be ordered only within the stipulated time period given. Delayed orders are not accepted. ( NOTE: Milk if needed in the morning should be informed the previous night) ',
                    style: TextStyle(fontSize: 15),),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('4. Groceries timing and transaction :Groceries should be ordered within the stipulated time period given. Delayed orders are not accepted. (NOTE: Groceries if needed in the morning should be informed the previous night) . The bill amount of groceries should want to be transfer during the order is conformed !',
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
      stream: sidebarcontent.where('type', isEqualTo: 'TermsOfUse').snapshots(),
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

