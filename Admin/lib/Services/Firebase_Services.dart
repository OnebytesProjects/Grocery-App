import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference banners = FirebaseFirestore.instance.collection('slider');
  CollectionReference milkscreen = FirebaseFirestore.instance.collection('milkscreen');
  CollectionReference category =
  FirebaseFirestore.instance.collection('category');
  CollectionReference products =
  FirebaseFirestore.instance.collection('products');
  CollectionReference deliveryboy =
  FirebaseFirestore.instance.collection('deliveryBoy');
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference order = FirebaseFirestore.instance.collection('orders');
  CollectionReference coupons = FirebaseFirestore.instance.collection('coupons');
  CollectionReference pincode = FirebaseFirestore.instance.collection('pincode');
  CollectionReference subscription = FirebaseFirestore.instance.collection('subscription');


  Future<QuerySnapshot> getAdminCredentials() {
    var result = FirebaseFirestore.instance.collection('Admin').get();
    return result;
  }

  //Banner
  Future<String> uploadBannerImageToDb(url) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      firestore.collection('slider').add({
        'image': downloadUrl,
      });
    }
    return downloadUrl;
  }

  deleteBannerImageFrmDb(id) async {
    firestore.collection('slider').doc(id).delete();
  }

  //Milkscreen
  Future<String> uploadMilkImageToDb(url) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      firestore.collection('milkscreen').add({
        'image': downloadUrl,
      });
    }
    return downloadUrl;
  }

  deleteMilkImageFrmDb(id) async {
    firestore.collection('milkscreen').doc(id).delete();
  }

  //category

  Future<String> uploadCategoryImageToDb(url, catName) async {

    String downloadUrl = await storage.ref(url).getDownloadURL();
    print('Url:${url},Catname${catName},Download Url 1:${downloadUrl}');
    category.doc(catName).set({
      'image': downloadUrl,
      'name': catName,
    });
    return downloadUrl;
  }

  deleteCategoryFrmDb(id) async {
    firestore.collection('category').doc(id).delete();
  }

  //Product settings
  Future<void> publishProduct({id}) {
    return products
        .doc(id)
        .update({
      'published': true,
    });
  }

  Future<void> unPublishProduct({id}) {
    return products
        .doc(id)
        .update({
      'published': false,
    });
  }

  Future<void> deleteProduct({id}) {
    return products
        .doc(id)
        .delete();
  }

  //services
  Future<void> confirmDeleteDialog({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteBannerImageFrmDb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmDeleteMilk({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteMilkImageFrmDb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmDeleteCategory({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                print(id);
                deleteCategoryFrmDb(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog({title, message, context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void>selectDeliveryMan(orderId,name,number,orderstatus){
    var result = order.doc(orderId).update({
      'deliverBoy':{
        'name' : name,
        'phone' : number,
      },
      'orderStatus': orderstatus,
    });
    return result;
  }

  Future<void>selectDeliveryManForSubscription(orderId,name,number){
    var result = subscription.doc(orderId).update({
      'deliverBoy':{
        'name' : name,
        'phone' : number,
      },
      'deliveryboystatus':'Assigned',
    });
    return result;
  }

  Future<void>saveCoupon({title,discountRate,expiry,details,active}) async {
    return coupons.doc(title).set({
      'title' : title,
      'discountRate' : discountRate,
      'Expiry' : expiry,
      'details' : details,
      'active' : active,
    });
  }

  Future<void>updateCoupon({title,discountRate,expiry,details,active}) async {
    return coupons.doc(title).update({
      'title' : title,
      'discountRate' : discountRate,
      'Expiry' : expiry,
      'details' : details,
      'active' : active,
    });
  }

  Future<void> deleteCoupon({id}) {
    return coupons
        .doc(id)
        .delete();
  }

  Future<void>savePincode({setpincode,deliverycharge}) async {
    return pincode.doc(setpincode).set({
      'pincode' : setpincode,
      'deliverycharge' : deliverycharge,
    });
  }

  Future<void> deletePincode({id}) {
    return pincode
        .doc(id)
        .delete();
  }

  Future<void>updateInventory({data,minqty,maxqty}) async {
    return products.doc(data).update({
      'Inventory_min_qty' : minqty,
      'Inventory_max_qty' : maxqty,

    });
  }
}
