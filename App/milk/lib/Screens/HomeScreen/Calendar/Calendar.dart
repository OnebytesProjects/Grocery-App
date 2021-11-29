import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference subscription = FirebaseFirestore.instance.collection('subscription');
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) =>
    {this.vip = documentSnapshot['vip']});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance
        .collection('subscription').where('userId',isEqualTo: _auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        //startdate = (doc['startdate'] as Timestamp).toString();
        enddate = doc['endDate'];
        todayDelivery = DateFormat('yyyy,MM,dd').format(DateTime.parse(doc['DeliveryDate']));
      });
    });


    return vip=='Yes'?Scaffold(
        body: ListView(
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
    )):Container(child: Center(child: Text('Make a Subscription'),),);
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
    User? user = FirebaseAuth.instance.currentUser;

    return DateFormat('yyyy,MM,dd').format(_focusedDay) == todayDelivery ?Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: orderService.subscription.where('userId',isEqualTo: user?.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
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
                                DateFormat('yyyy,MM,dd').format(_focusedDay) == DateFormat('yyyy,MM,dd').format(_today) ? RaisedButton(onPressed: (){
                                  showDialog('Are you Sure?', context,document.id);
                                },child: Text('Skip Todays Delivery'),color: Colors.orange,):Container(),
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
        },
      ),
    ):Container(child: Center(child: Text('No Delivery Today'),),);
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
              'DeliveryDate': DateTime.now().add(Duration(days: 1)).toString(),
              'endDate':DateTime.parse(enddate!).add(Duration(days: 1)).toString(),
            });
          }, child: Text('Ok'))
        ],
      );
    });
  }
}
