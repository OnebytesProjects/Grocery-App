

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productName, category,image;
  final DocumentSnapshot snapshot;

  Product({required this.productName, required this.category, required this.image,required this.snapshot});

}