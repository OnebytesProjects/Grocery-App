import 'package:cloud_firestore/cloud_firestore.dart';

class NotifiationService{
  CollectionReference notifications = FirebaseFirestore.instance.collection('notifications');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
}