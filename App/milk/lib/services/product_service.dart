

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService{
  String _condition = 'Dairy Products';
  CollectionReference category = FirebaseFirestore.instance.collection('category');

}