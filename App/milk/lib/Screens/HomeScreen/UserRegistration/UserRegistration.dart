import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milk/Screens/HomeScreen/Home/Mainscreen.dart';
import 'package:milk/providers/referal_provider.dart';
import 'package:milk/services/user_service.dart';
import 'package:provider/provider.dart';

class UserRegistration extends StatefulWidget {
  static const String id = 'userregistration';

  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {

  String dropdownValueGender = 'Choose Gender';
  String dropdownValue = 'Choose Pincode';

  final List<String> GenderList = <String>[
    'Choose Gender',
    'Male',
    'Female',
    'Not Prefered to say',
  ];

  final List<String> regionList = <String>[
    'Choose Pincode',];

  final _fomrKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserServices _user = UserServices();
  TextEditingController _name = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _pincode = TextEditingController();
  TextEditingController _referral = TextEditingController();
  TextEditingController _email = TextEditingController();
  String unknownloc = '';
  bool unknownlocation = true;

  File? image;
  var profileimgpath = 'images/profile.jpg';

  checkPincode() async{
     unknownloc = 'NewLocation: '+_pincode.text;
    //check pincode
    await FirebaseFirestore.instance
        .collection('pincode')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(_pincode.text == doc['pincode']){
          print('checked');
          setState(() {
            unknownloc = '';
          });
        }
      });
    });

    print('unknown loc : ${unknownloc}');

    return unknownloc;
  }

  updateProfile() async{
    String address = "${_address.text} - ${_pincode.text}";
    if (_fomrKey.currentState!.validate()) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({
        'name': _name.text,
        'gender': dropdownValueGender,
        'address': address,
        'zip': _pincode.text,
        'refered' : _referral.text,
        'mail': _email.text,
        'pincode':_pincode.text,
        'NewLocation': unknownloc,
      });
    }
  }

  @override
  void initState() {
    _user.getUserById(user!.uid).then((value) {
      if (mounted) {
        setState(() {});
      }
    });
    FirebaseFirestore.instance
        .collection('pincode')
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        setState(() {
          regionList.add(doc['pincode']);
        });
      });
    });

    FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: user?.uid)
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        _mobile.text = doc['number'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _referalid = Provider.of<ReferalProvider>(context);
    setState(() {
      _referral.text = _referalid.referalid;
    });

    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _fomrKey,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  color: Colors.grey[800],
                  height: 150,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("images/profile.jpg"))),
                        ),
                        // Positioned(
                        //     bottom: 0,
                        //     right: 0,
                        //     child: Container(
                        //       height: 45,
                        //       width: 45,
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         border: Border.all(
                        //           width: 4,
                        //           color:
                        //               Theme.of(context).scaffoldBackgroundColor,
                        //         ),
                        //         color: Colors.orange[300],
                        //       ),
                        //       child: IconButton(
                        //         onPressed: () {
                        //           showModalBottomSheet(
                        //             context: context,
                        //             builder: ((builder) => bottomSheet()),
                        //           );
                        //         },
                        //         icon: Icon(Icons.edit),
                        //         color: Colors.white,
                        //       ),
                        //     )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            buildTextField(
                                "Full Name", "Your Name", true, _name),
                            buildTextField(
                                "Mobile Number", "number", false, _mobile),
                            //dropdown-gender
                            SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Choose Gender",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        DropDownField(),
                                      ],
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            buildTextField(
                                "Address", "Enter here", true, _address),

                            buildTextField(
                                "Pincode", "Enter here", true, _pincode),
                            //dropdown-pincode
                            // SizedBox(
                            //     width: double.infinity,
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           "Enter Pincode",
                            //           style: TextStyle(
                            //               fontSize: 13, color: Colors.grey),
                            //         ),
                            //         SizedBox(
                            //           height: 10,
                            //         ),
                            //         Row(
                            //           crossAxisAlignment:
                            //           CrossAxisAlignment.center,
                            //           children: [
                            //             DropDownField1(),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                            SizedBox(
                              height: 20,
                            ),
                            buildTextField("Email", "Enter here", true, _email),
                            // CheckReferalId(),
                            // SizedBox(
                            //   height: 35,
                            // ),
                            RaisedButton(
                              onPressed: () {
                                checkPincode().then((value){
                                  updateProfile().then((value) {
                                    EasyLoading.showSuccess('Profile Updated');
                                    Navigator.pushReplacementNamed(
                                        context, MainScreen.id);
                                  });
                                });
                              },
                              color: Colors.orange[300],
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              elevation: 2,
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    )),
              ]),
            ),
          ),
        ),
      ),
    );
  }


  Widget buildTextField(String labelText, String placeholder, bool isenabled,
      TextEditingController _controllerValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: _controllerValue,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter $labelText';
          }
          return null;
        },
        enabled: isenabled,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            )),
      ),
    );
  }

  Widget DropDownField1(){
    return SizedBox(
      width: 300,
      child: DropdownButton<String>(
        value: dropdownValue,
        //icon: const Icon(Icons.arrow_downward,),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
        underline: Container(
          height: 1,
          color: Colors.grey,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: regionList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  Widget DropDownField(){
    return SizedBox(
      width: 300,
      child: DropdownButton<String>(
        value: dropdownValueGender,
        //icon: const Icon(Icons.arrow_downward,),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
        underline: Container(
          height: 1,
          color: Colors.grey,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValueGender = newValue!;
          });
        },
        items: GenderList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget normalChildButton() {
    return SizedBox(
      width: 150,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                child: Text(dropdownValue, overflow: TextOverflow.ellipsis)),
            const SizedBox(
              width: 12,
              height: 17,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
