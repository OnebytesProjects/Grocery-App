import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async{
      Navigator.pushReplacementNamed(context, MainScreen.id);
      return true;
    },
    child:Scaffold(
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
              Text('About Us',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(' Dairy products play a vital role in  Human life. We begin and end our day with the consumption of Dairy products. Nutrition affects your physical and mental wellness, and following a healthy diet can lead to positive changes in your everyday life.We  aim to ensure your safety and Health by providing farm fresh milk within 3-4 hours of collection and meet your expectations at your doorstep. Milk products like Butter, Ghee, Cheese and Paneer are naturally processed and distributed Manually. Upon ensuring the hygiene measures we provide milk in Bottles which are properly sterilized with Hot water to avoid the presence of microorganisms and Infections that prevents Vomiting and other clinical illness .',
                style: TextStyle(fontSize: 15),),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Glass bottles are Prefered for many other reasons too. It\'s sustainable, Inert, 100% and  infinitely recyclable, reusable and refillable; Also It\'s safe to store food and drinks in and it\'s beautiful, consumers love it. Additionally, Groceries and Fresh Vegetables are supplied at Dawn and Dusk along with distribution of milk to lessen your Burden and save your time with Nil Delivery charge. Progressing upon Generations we are improving every day to fulfill and satisfy consumer  needs. ',
                  style: TextStyle(fontSize: 15),),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,20.0),
                child: Text(' " Great news!!- One & Only offer is arriving soon." Get updated with \'Milke Moo\'.',
                  style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        ),
      ),
    ),);
  }

  Content() {
    CollectionReference sidebarcontent =
    FirebaseFirestore.instance.collection('sidebarcontent');
    return StreamBuilder<QuerySnapshot>(
      stream: sidebarcontent.where('type', isEqualTo: 'AboutUs').snapshots(),
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
