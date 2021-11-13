import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = 'id';
  static const PROFILEPIC = 'profilepic';
  static const NUMBER = 'number';
  static const NAME = 'name';
  static const GENDER = 'gender';
  static const ZIP = 'zip';
  static const ADDRESS = 'address';
  static const REFERRAL = 'referral';
  static const MAIL = 'mail';
  static const MYREFERRAL = 'myreferral';
  static const PREFERENCE = 'prefernce';


  String _id = '';
  String _number = '';
  String _profilepic = '';
  String _name = '';
  String _gender = '';
  String _zip = '';
  String _address = '';
  String _referral = '';
  String _mail = '';
  String _myreferral = '';
  String _preference = '';
  //getter
  String get id => _id;
  String get number => _number;
  String get name => _name;
  String get profilepic => _profilepic;
  String get gender => _gender;
  String get zip => _zip;
  String get address => _address;
  String get referral => _referral;
  String get mail => _mail;
  String get myreferral => _myreferral;
  String get preference => _preference;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()[ID];
    _number = snapshot.data()[NUMBER];
    _name = snapshot.data()[NAME];
    _profilepic = snapshot.data()[PROFILEPIC];
    _gender = snapshot.data()[GENDER];
    _zip = snapshot.data()[ZIP];
    _address = snapshot.data()[ADDRESS];
    _referral = snapshot.data()[REFERRAL];
    _mail = snapshot.data()[MAIL];
    _myreferral = snapshot.data()[MYREFERRAL];
    _preference = snapshot.data()[PREFERENCE];
  }
}
