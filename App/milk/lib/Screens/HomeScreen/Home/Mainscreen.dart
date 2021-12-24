import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:milk/Screens/Drawercontent/Cancelation_and_Refund.dart';
import 'package:milk/Screens/Drawercontent/Terms_of_use.dart';
import 'package:milk/Screens/HomeScreen/Product/ProductScreen.dart';
import 'package:milk/Screens/HomeScreen/Profile/Profile.dart';
import 'package:milk/Screens/Drawercontent/About_us.dart';
import 'package:milk/Screens/HomeScreen/Calendar/Calendar.dart';
import 'package:milk/Screens/HomeScreen/Cart/Cart.dart';
import 'package:milk/Screens/HomeScreen/Home/Home.dart';
import 'package:milk/Screens/HomeScreen/OrderHistory/Order_History.dart';
import 'package:milk/Screens/HomeScreen/Referal/Referal.dart';
import 'package:milk/Screens/HomeScreen/Notification/Notifications.dart';
import 'package:milk/Screens/SplashScreen/WelcomeScreen.dart';
import 'package:milk/models/product_model.dart';
import 'package:milk/Screens/HomeScreen/UserRegistration/UserRegistration.dart';
import 'package:search_page/search_page.dart';
import '../../Drawercontent/Contact_us.dart';
import '../Preference/Preference.dart';
import '../Subscription/Subscription.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'home';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static List<Product> product = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  String Username = '';
  String _notification = '';
  var currentPage = DrawerSection.HOME;
  String _username = '';
  String _appbarname = '';

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          product.add(Product(
              productName: doc['productName'],
              category: doc['category']['mainCategory'],
              image: doc['productImage'],
              snapshot: doc));
        });
      });
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot doc) {
      setState(() {
        Username = doc['name'];
      });
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot doc) {
      setState(() {
        _username = doc['name'];
      });
    });

    //check for notification
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(_auth.currentUser?.uid).collection('notifications').doc()
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     setState(() {
    //       _notification = 'Present';
    //     });
    //   }
    //   else{
    //     _notification = 'Not';
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final Stream<QuerySnapshot> _notificationStream = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(_auth.currentUser?.uid)
    //     .collection('notifications')
    //     .snapshots();
    //
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(_auth.currentUser?.uid)
    //     .collection('notifications')
    //     .doc()
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     print('Notification Document exists on the database');
    //   } else {
    //     print('Notification Document does not exists on the database');
    //   }
    // });

    _appbarname = 'Hi,$_username';

    var container;
    if (currentPage == DrawerSection.HOME) {
      container = Home();
    } else if (currentPage == DrawerSection.CALENDAR) {
      container = Calendar();
    } else if (currentPage == DrawerSection.SUBSCRIPTION) {
      container = Subscription();
    } else if (currentPage == DrawerSection.ORDER_HISTORY) {
      container = OrderHistory();
    } else if (currentPage == DrawerSection.PREFERENCE) {
      container = Preference();
    } else if (currentPage == DrawerSection.REFER_A_FREIND) {
      container = Referal();
    } else if (currentPage == DrawerSection.ABOUT_US) {
      container = AboutUs();
    } else if (currentPage == DrawerSection.CONTACT_US) {
      container = ContactUs();
    } else if (currentPage == DrawerSection.TERMS_OF_USE) {
      container = TermsofUse();
    } else if (currentPage == DrawerSection.CANCELATION_AND_REFUND) {
      container = CancelationRefund();
    } else if (currentPage == DrawerSection.PROFILE) {
      container = Profile();
    }

    return _username == 'null'
        ? UserRegistration()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                elevation: 1.5,
                backgroundColor: Colors.grey[800],
                title: Text(
                  _appbarname,
                  style: TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Image.asset(
                        'images/drawericon.png',
                        height: 25,
                        width: 34,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SearchPage<Product>(
                          // barTheme: ThemeData(primaryColor: Colors.orange[300]),
                          // onQueryUpdate: (s) => print(s),
                          items: product,
                          searchLabel: 'Search Product',
                          suggestion: Center(
                            child: Text('Filter Product by name or Category'),
                          ),
                          failure: Center(
                            child: Text('No Product found :('),
                          ),
                          filter: (products) => [
                            products.productName,
                            products.category,
                          ],
                          builder: (products) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                          pname: products.productName,
                                        )),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 2.0, color: Colors.black45),
                                ),
                              ),
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              height: 80,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 100,
                                    width: 90,
                                    child: Image.network(products.image),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    products.productName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.white,
                    ),
                    // onPressed: () => showDialog<String>(
                    //   context: context,
                    //   builder: (BuildContext context) => Notifications(),
                    // ),
                    onPressed: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>Notifications()));
                    },
                  ),

                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cart()),
                      );
                    },
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              drawer: Drawer(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      DrawerHeader(),
                      DrawerList(),
                    ],
                  ),
                ),
              ),
              body: container,
            ),
          );
  }

  Widget DrawerHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      color: Colors.grey[800],
      child: Center(
        child: Column(
          children: [
            //logo
            SizedBox(
              height: 125,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/splscrn.png"),
                          fit: BoxFit.fill),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //user
            Row(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("images/profile.jpg"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      currentPage = DrawerSection.PROFILE;
                    });
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          _username,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              'Edit Profile',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: null,
                              // () {
                              //   Navigator.pop(context);
                              //   currentPage = DrawerSection.PROFILE;
                              // },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      currentPage = DrawerSection.PROFILE;
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget DrawerList() {
    return Column(
      children: [
        menuItem(1, "HOME", Icons.home,
            currentPage == DrawerSection.HOME ? true : false),
        menuItem(2, "CALENDAR", Icons.calendar_today,
            currentPage == DrawerSection.CALENDAR ? true : false),
        menuItem(3, "SUBSCRIPTION", Icons.autorenew,
            currentPage == DrawerSection.SUBSCRIPTION ? true : false),
        menuItem(4, "ORDER HISTORY", Icons.history_edu_outlined,
            currentPage == DrawerSection.ORDER_HISTORY ? true : false),
        menuItem(5, "PREFERENCE", Icons.settings,
            currentPage == DrawerSection.PREFERENCE ? true : false),
        menuItem(6, "REFER A FREIND", Icons.group_add_outlined,
            currentPage == DrawerSection.REFER_A_FREIND ? true : false),
        Divider(
          thickness: 3,
          indent: 10,
          endIndent: 10,
        ),
        menuItem(7, "ABOUT US", Icons.info,
            currentPage == DrawerSection.ABOUT_US ? true : false),
        menuItem(8, "CONTACT US ", Icons.phone,
            currentPage == DrawerSection.CONTACT_US ? true : false),
        menuItem(9, "TERMS OF USE ", Icons.sticky_note_2_outlined,
            currentPage == DrawerSection.CONTACT_US ? true : false),
        menuItem(10, "CANCELATION AND REFUND", Icons.lock,
            currentPage == DrawerSection.CANCELATION_AND_REFUND ? true : false),
        menuItem(11, "LOGOUT", Icons.logout,
            currentPage == DrawerSection.LOGOUT ? true : false),
        GestureDetector(
          onTap: (){
            launch('https://www.onebytes.in');
          },
          child: Container(
            height: 80,
            width: double.infinity,
            color:  Color(0xff444444),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      //color: Colors.green
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('images/ob.jpeg'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Text(
                      "Developed By OneBytes",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSection.HOME;
              _appbarname = 'Hi,$_username';
            } else if (id == 2) {
              currentPage = DrawerSection.CALENDAR;
              _appbarname = 'Calendar';
            } else if (id == 3) {
              currentPage = DrawerSection.SUBSCRIPTION;
              _appbarname = 'Subscription';
            } else if (id == 4) {
              currentPage = DrawerSection.ORDER_HISTORY;
              _appbarname = 'Order History';
            } else if (id == 5) {
              currentPage = DrawerSection.PREFERENCE;
              _appbarname = 'Preference';
            } else if (id == 6) {
              currentPage = DrawerSection.REFER_A_FREIND;
              _appbarname = 'Refer A Friend';
            } else if (id == 7) {
              currentPage = DrawerSection.ABOUT_US;
              _appbarname = 'About Us';
            } else if (id == 8) {
              currentPage = DrawerSection.CONTACT_US;
              _appbarname = 'Contact Us';
            } else if (id == 9) {
              currentPage = DrawerSection.TERMS_OF_USE;
              _appbarname = 'Terms of Use';
            } else if (id == 10) {
              currentPage = DrawerSection.CANCELATION_AND_REFUND;
              _appbarname = 'Cancelation and Refund';
            } else if (id == 11) {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacementNamed(context, WelcomeScreen.id);
              });
            }
          });
        },
      ),
    );
  }
}

enum DrawerSection {
  PROFILE,
  HOME,
  CALENDAR,
  SUBSCRIPTION,
  ORDER_HISTORY,
  PREFERENCE,
  REFER_A_FREIND,
  ABOUT_US,
  CONTACT_US,
  TERMS_OF_USE,
  CANCELATION_AND_REFUND,
  LOGOUT,
}
