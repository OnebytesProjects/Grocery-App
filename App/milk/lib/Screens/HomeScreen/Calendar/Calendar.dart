import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';
import 'package:milk/services/order_service.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // CalendarController _calendarController = CalendarController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _today = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart = DateTime(2021,11,3);
  DateTime? _rangeEnd = DateTime(2021,11,29);
  String? startdate;
  String? enddate;
  String? todayDelivery;
  bool enable = true;
  String vip = '';
  int _qty = 0;
  bool _skipenable = false;
  bool _assigned = false;

  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference subscription = FirebaseFirestore.instance.collection('subscription');
  CollectionReference subscription2 = FirebaseFirestore.instance.collection('Activesubscription');
  @override
  void initState() {


    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    setState(() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) =>
      {vip = documentSnapshot['vip']});


      FirebaseFirestore.instance
          .collection('Activesubscription').where('userId',isEqualTo: _auth.currentUser?.uid)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          //startdate = (doc['startdate'] as Timestamp).toString();
          enddate = doc['endDate'];
          setState(() {
            todayDelivery = DateFormat('yyyy,MM,dd').format(DateTime.parse(doc['DeliveryDate']));
          });
          print(todayDelivery);
        });
      });
    });

    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
      children: [
          calendar(),
          SizedBox(
            height: 5,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                "Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
          cardVeiw("Milk"),
      ],
    ),
        ));
  }

  Widget calendar() {
    return TableCalendar(
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
      ),
      firstDay: DateTime(2020),
      lastDay: DateTime(2050),
      // rangeStartDay: _rangeStart,
      // rangeEndDay: _rangeEnd,
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        // Use `selectedDayPredicate` to determine which day is currently selected.
        // If this returns true, then `day` will be marked as selected.

        // Using `isSameDay` is recommended to disregard
        // the time-part of compared DateTime objects.
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _focusedDay = focusedDay;
      },
    );
  }

  Widget cardVeiw(String title) {
    OrderService orderService = OrderService();
    //User? user = FirebaseAuth.instance.currentUser;

    return DateFormat('yyyy,MM,dd').format(_focusedDay) == todayDelivery ?SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: orderService.subscription2.where('userId',isEqualTo: _auth.currentUser?.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasData){
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 14,
                          child: Icon(CupertinoIcons.square_list,size: 18,
                          ),

                        ),
                        title: Text('Todays Delivery',
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                        subtitle: Text('Ordered On ${DateFormat.yMMMd().format(DateTime.parse(data['timestamp']))}',
                          style: TextStyle(fontSize: 12),),

                      ),
                      ExpansionTile(title: Text('Subscription Details',style: TextStyle(fontSize: 12,color: Colors.black),),
                        subtitle: Text('View subscription Details',style: TextStyle(fontSize: 12,color: Colors.grey)),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context,int index){
                              return Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.network(data['products'][index]['productImage']),
                                    ),
                                    title: Text(data['products'][index]['productName']),
                                    subtitle: Text('Quantity: ${data['products'][index]['qty'].toString()}   Price:₹ ${data['products'][index]['sellingPrice'].toString()}',
                                      style: TextStyle(fontSize: 12,color: Colors.grey),),
                                  ),
                                  DateFormat('yyyy,MM,dd').format(_focusedDay) == DateFormat('yyyy,MM,dd').format(_today) ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Days: '),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (_qty >= 1) {
                                                setState(() {
                                                  _qty -= 1;
                                                });
                                              }
                                              if(_qty == 0){
                                                setState(() {
                                                  _skipenable = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(50),
                                                  border: Border.all(
                                                    color: Colors.orange,
                                                  )),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.remove),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 8,
                                                bottom: 8),
                                            child: Text(_qty.toString()),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (_qty >= 0) {
                                                setState(() {
                                                  _qty += 1;
                                                });
                                              }
                                              if(_qty > 0){
                                                setState(() {
                                                  _skipenable = true;
                                                });
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(50),
                                                  border: Border.all(
                                                    color: Colors.orange,
                                                  )),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(Icons.add),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      RaisedButton(
                                        onPressed: _skipenable?(){
                                        showDialog('Are you sure to skip ${_qty} delivery day?', context,document.id);

                                      }:null,child: Text('Skip Delivery'),
                                        color: _skipenable?Colors.orange:Colors.grey,),
                                    ],
                                  ):Container(),
                                ],
                              );
                            },
                            itemCount: data['products'].length,
                          )
                        ],),
                      Divider(height: 3,)
                    ],
                  ),
                );
              }).toList(),
            );
          }
          return Center(child: Text('No Delivery Today'),);
        },
      ),
    ):Center(child: Text('Select Delivery Date'),);
  }


  showDialog(message,context,docid){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        content: Text('$message'),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          FlatButton(onPressed: (){
            Navigator.pop(context);
            //SkipOrder
            subscription.doc(docid)
                .update({
              'DeliveryDate': DateTime.now().add(Duration(days: _qty)).toString(),
              'endDate':DateTime.parse(enddate!).add(Duration(days: _qty)).toString(),
            });
            subscription2.doc(docid)
                .update({
              'DeliveryDate': DateTime.now().add(Duration(days: _qty)).toString(),
              'endDate':DateTime.parse(enddate!).add(Duration(days: _qty)).toString(),
            });
            EasyLoading.showSuccess('Skipped Todays Delivery');
            Navigator.pushReplacementNamed(context, MainScreen.id);
          }, child: Text('Ok'))
        ],
      );
    });
  }
}

//doc id to userid