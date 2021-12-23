import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String selectedCategory = 'Not selected';
  String selectedSubCategory = 'Not selected';
  String categoryImage = '';
  File? image;
  String pickError = '';
  //late String shopName;
  late String productUrl;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  selectCategory(mainCategory, categoryImage) {
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  Future getProductImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedfile = await picker.getImage(source: ImageSource.gallery);
    if (pickedfile != null) {
      this.image = File(pickedfile.path);
      notifyListeners();
    } else {
      this.pickError = 'No Image Selected';
      print('No image Selected');
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context, title, content}) {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // getShopName(shopName){
  //   this.shopName  = shopName;
  //   notifyListeners();
  // }

  //upload product image

  Future<String> uploadproductImageToDb(url) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      firestore.collection('productsUrl').add({
        'image': downloadUrl,
      });
    }
    this.productUrl = downloadUrl;
    return downloadUrl;
  }

  //product data to firestore

  Future<void>? saveProductDatatoDb(
      {productName,
      brandName,
      sellingPrice,
      comparedPrice,
      productDescription,
      productQuantity,
      v1,
      v2,
      v3,
      v4,
      p1,
      p2,
      p3,
      p4,
      maxqty,
      minQty,
      context}) {
    var timeStamp = DateTime.now().microsecondsSinceEpoch;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(timeStamp.toString()).set({
        'productName': productName,
        'brandName': brandName,
        'sellingPrice': sellingPrice,
        'ProductQuantity': productQuantity,
        'ComparedPrice': comparedPrice,
        'productDescription': productDescription,
        'category': {
          'mainCategory': this.selectedCategory,
          'subCategory': this.selectedSubCategory,
          'categoryImage': this.categoryImage
        },
        'v1': v1,
        'v2': v2,
        'v3': v3,
        'v4': v4,
        'p1': p1,
        'p2': p2,
        'p3': p3,
        'p4': p4,
        'published': false,
        'Inventory_max_qty': maxqty,
        'Inventory_min_qty': minQty,
        'productid': timeStamp.toString(),
        'productImage': this.productUrl,
      });
      this.alertDialog(
          context: context,
          title: 'Save Data',
          content: 'Product Saved Successfully');
    } catch (e) {
      this.alertDialog(
          context: context, title: 'Save Data', content: '${e.toString()}');
    }
    return null;
  }

  Future<String>? updateProductDatatoDb(
      {productName,
      brandName,
      sellingPrice,
      comparedPrice,
      productQuantity,
      productDescription,
      v1,
      v2,
      v3,
      v4,
        p1,
        p2,
        p3,
        p4,
      productid,
      context}) {
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(productid).update({
        'productName': productName,
        'brandName': brandName,
        'sellingPrice': sellingPrice,
        'ComparedPrice': comparedPrice,
        'ProductQuantity': productQuantity,
        'productDescription': productDescription,
        'v1': v1,
        'v2': v2,
        'v3': v3,
        'v4': v4,
        'p1': p1,
        'p2': p2,
        'p3': p3,
        'p4': p4,

        'productId': productid,
      });
      this.alertDialog(
          context: context,
          title: 'Save Data',
          content: 'Product Saved Successfully');
      EasyLoading.dismiss();
    } catch (e) {
      this.alertDialog(
          context: context, title: 'Save Data', content: '${e.toString()}');
    }
  }
}
