import 'package:admin/Screens/Vendor/vendor%20service/product_provider.dart';
import 'package:admin/Services/Firebase_Services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;
  final String productImage;
  EditViewProduct({required this.productId, required this.productImage});

  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  bool _value = false;

  var _productname = TextEditingController();
  var _brandName = TextEditingController();
  var _sellingPrice = TextEditingController();
  var _comparedPrice = TextEditingController();
  var _productDescription = TextEditingController();
  var _v1 = TextEditingController();
  var _v2 = TextEditingController();
  var _v3 = TextEditingController();
  var _v4 = TextEditingController();
  var _qty = TextEditingController();
  var _minqty = TextEditingController();
  bool _editing = true;

  dynamic data;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        this.data = document.data();
        _productname.text = data['productName'];
        _brandName.text = data['brandName'];
        _sellingPrice.text = data['sellingPrice'].toString();
        _comparedPrice.text = data['ComparedPrice'].toString();
        _productDescription.text = data['productDescription'];
        _v1.text = data['v1'].toString();
        _v2.text = data['v2'].toString();
        _v3.text = data['v3'].toString();
        _v4.text = data['v4'].toString();
        _qty.text = data['qty'].toString();
        _minqty.text = data['min_qty'].toString();
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () {
              setState(() {
                _editing = false;
              });
            },
            child: Text("Edit"),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 2),
            child: AbsorbPointer(
              absorbing: _editing,
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 150,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          //color: Colors.orange,
                          child: Image.network(
                            widget.productImage,
                            scale: 1,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          height: 150,
                          padding: EdgeInsets.only(right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                height: 30,
                                width: 140,
                                child: TextFormField(
                                  controller: _productname,
                                  decoration: InputDecoration(
                                      hintText: 'Product name',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 20,
                                width: 100,
                                child: TextFormField(
                                  controller: _brandName,
                                  decoration: InputDecoration(
                                      hintText: 'Product Brand',
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 50,
                                    child: TextFormField(
                                      controller: _sellingPrice,
                                      decoration: InputDecoration(
                                          hintText: 'MRP',
                                          prefixText: '₹',
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: 20,
                                    width: 50,
                                    child: TextFormField(
                                      controller: _comparedPrice,
                                      decoration: InputDecoration(
                                          hintText: 'MRP',
                                          prefixText: '₹',
                                          hintStyle: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _productDescription,
                              maxLines: 5,
                              maxLength: 500,
                              decoration: InputDecoration(
                                  hintText: 'Description',
                                  hintStyle: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 3,
                  ),
                  Text(
                    "Quantity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 20,
                    width: 50,
                    child: TextFormField(
                      controller: _qty,
                      decoration: InputDecoration(
                        hintText: 'Quantity',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Minimum-Quantity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 20,
                    width: 50,
                    child: TextFormField(
                      controller: _minqty,
                      decoration: InputDecoration(
                        hintText: 'Quantity',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Volume",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 120,
                    padding: EdgeInsets.only(left: 20, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: _value,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = value!;
                                        });
                                      }),
                                  Container(
                                    height: 20,
                                    width: 50,
                                    child: TextFormField(
                                      controller: _v1,
                                      decoration: InputDecoration(
                                          hintText: 'v1',
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: _value,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = value!;
                                        });
                                      }),
                                  Container(
                                    height: 20,
                                    width: 50,
                                    child: TextFormField(
                                      controller: _v2,
                                      decoration: InputDecoration(
                                          hintText: 'v2',
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: _value,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = value!;
                                        });
                                      }),
                                  Container(
                                    height: 20,
                                    width: 50,
                                    child: TextFormField(
                                      controller: _v3,
                                      decoration: InputDecoration(
                                          hintText: 'v3',
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  Checkbox(
                                      value: _value,
                                      onChanged: (value) {
                                        setState(() {
                                          _value = value!;
                                        });
                                      }),
                                  Container(
                                    height: 20,
                                    width: 50,
                                    child: TextFormField(
                                      controller: _v4,
                                      decoration: InputDecoration(
                                          hintText: 'v4',
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        height: 60,
        child: AbsorbPointer(
          absorbing: _editing,
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _editing = true;
                        });
                      },
                      child: Container(
                        color: Colors.black54,
                        child: Center(
                            child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )),
                      ))),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          EasyLoading.show(status: 'Saving...');
                          _provider.updateProductDatatoDb(
                            context: context,
                            productName: _productname.text,
                            brandName: _brandName.text,
                            sellingPrice: double.parse(_sellingPrice.text),
                            comparedPrice: double.parse(_comparedPrice.text),
                            productDescription: _productDescription.text,
                            qty: int.parse(_qty.text),
                            minQty: int.parse(_minqty.text),
                            v1: _v1.text,
                            v2: _v2.text,
                            v3: _v3.text,
                            v4: _v4.text,
                            productid: widget.productId,
                          );
                        }
                      },
                      child: Container(
                        color: Colors.orange[700],
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        )),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
