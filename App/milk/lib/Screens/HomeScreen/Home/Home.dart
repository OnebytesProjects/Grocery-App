import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:milk/Screens/HomeScreen/ProductList/ProductList.dart';
import 'package:milk/services/product_service.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  var _productList = '0';
  //Stream function
  late Stream slides;
  Future<Stream> _queryDb() async => slides = FirebaseFirestore.instance
      .collection('slider')
      .snapshots()
      .map((list) => list.docs.map((doc) => doc.data()));

  late AnimationController _animationController;
  late Animation<double> _nextPage;
  int _currentPage = 0;
  final PageController _pcontroller = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    _queryDb();

    //Start at the controller and set the time to switch pages
    _animationController =
    new AnimationController(vsync: this, duration: Duration(seconds: 5));
    _nextPage = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reset(); //Reset the controller
        final int page = 4; //Number of pages in your PageView
        if (_currentPage < page) {
          _currentPage++;
          _pcontroller.animateToPage(_currentPage,
              duration: Duration(milliseconds: 300), curve: Curves.easeInSine);
        } else {
          _currentPage = 0;
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    //_pcontroller.dispose();
    super.dispose();
  }
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    _animationController.forward(); //Start controller with widget
    //print(_nextPage.value);

    return WillPopScope(
      onWillPop: ()async{
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBackPressed = DateTime.now();

        if(isExitWarning){
          final message = 'Press Back Again To Exit.';
          Fluttertoast.showToast(msg: message,fontSize: 18);
          return false;
        }else{
          Fluttertoast.cancel();
          return true;
        }

      },
      child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //carousel
                  Container(
                    width: double.infinity,
                    height: 175,
                    child: CarouselView(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //categories
                  Container(width: double.infinity,
                      height: 130,
                      child: Category()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Products",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //products
                  Container(width: double.infinity,
                      height: 480,
                      child: ProductList(
                        condition: _productList,
                      )),
                ],
              ),
            ),
          )),
    );
  }

  //Carousel
  Widget CarouselView() {
    return StreamBuilder(
      stream: slides,
      builder: (context, AsyncSnapshot snap) {
        List slideList = snap.data.toList();
        if (snap.hasError) {
          return Text("snap.error");
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return PageView.builder(
            controller: _pcontroller,
            scrollDirection: Axis.horizontal,
            itemCount: slideList.length,
            itemBuilder: (context, int index) {
              return _buildCarousel(slideList[index]);
            });
      },
    );
  }

  _buildCarousel(Map data) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(data['image']),
          )),
    );
  }

  //Categories

  Widget Category() {
    //final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
    ProductService _services = ProductService();
    return FutureBuilder(
        future: _services.category.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Container(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      print(document['name']);
                      setState(() {
                        this._productList = document['name'];
                      });
                    },
                    child: Container(
                      width: 110,
                      //color: Colors.orange,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right:BorderSide(width: 2.0, color: Colors.black45),
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                        width: 100.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 80,
                              //color: Colors.green,
                              child: Image.network(document['image']),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            document['name']=='0'?Text('Milk'):
                            Text(document['name'])
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

}
