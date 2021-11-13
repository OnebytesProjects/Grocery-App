import 'dart:html';

import 'package:admin/Screens/Vendor/vendor%20service/product_provider.dart';
import 'package:admin/Screens/Vendor/vendor_products/category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:firebase/firebase.dart' as db;

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key}) : super(key: key);
  static const String id = 'add_new_product';

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {

  final _formKey = GlobalKey<FormState>();
  List<String> _collection = [
    'a',
    'b',
    'c',
  ];
  late String dropDownValue;

  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  bool _visible = false;
  bool _track = false;

  //File? _image;
  late String _image = 'Select image';
  late String _url;


  late String productName;
  late String brandName;
  late double sellingPrice;
  late double comparedPrice;
  late String productDescription;
  late String volume1;
  late String volume2;
  late String volume3;
  late String volume4;
  late int qty;
  late int minqty;
  var _productNameTextController = TextEditingController();
  var _brandNameTextController = TextEditingController();
  var _sellingPriceTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _productDescriptionTextController = TextEditingController();
  var _v1TextController = TextEditingController();
  var _v2TextController = TextEditingController();
  var _v3TextController = TextEditingController();
  var _v4TextController = TextEditingController();
  var _quantityTextController = TextEditingController();
  var _minquantityTextController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Container(
                          child: Row(
                            children: [Text('Products/Add')],
                          ),
                        ),
                      ),
                      FlatButton.icon(
                        onPressed: () async{
                          if(_formKey.currentState!.validate()){
                            if(_categoryTextController.text.isNotEmpty) {
                              if (_subCategoryTextController.text.isNotEmpty) {
                                if (_image != null) {
                                  EasyLoading.show(status: 'Saving...');

                                  _provider.uploadproductImageToDb(_url).then((
                                      dwurl) {
                                    if (dwurl != null) {
                                      EasyLoading.dismiss();
                                      _provider.saveProductDatatoDb(
                                        context: context,
                                        productName: _productNameTextController.text,
                                        brandName: _brandNameTextController.text,
                                        sellingPrice: double.parse(_sellingPriceTextController.text),
                                        comparedPrice:double.parse(_comparedPriceTextController.text),
                                        productDescription:_productDescriptionTextController.text,
                                        v1:_v1TextController.text,
                                        v2:_v2TextController.text,
                                        v3:_v3TextController.text,
                                        v4:_v4TextController.text,
                                        qty:int.parse(_quantityTextController.text),
                                        minQty:int.parse(_minquantityTextController.text),
                                      );
                                      setState(() {
                                        _formKey.currentState!.reset();
                                        _image = 'Select image';
                                        _productNameTextController.clear();
                                        _brandNameTextController.clear();
                                        _sellingPriceTextController.clear();
                                        _comparedPriceTextController.clear();
                                        _productDescriptionTextController.clear();
                                        _categoryTextController.clear();
                                        _subCategoryTextController.clear();
                                        _v1TextController.clear();
                                        _v2TextController.clear();
                                        _v3TextController.clear();
                                        _v4TextController.clear();
                                        _quantityTextController.clear();
                                        _minquantityTextController.clear();
                                        _visible = false;
                                        _track = false;

                                      });
                                    } else {
                                      _provider.alertDialog(context: context,
                                          title: 'Image Upload',
                                          content: 'Upload Failed');
                                    }
                                  });
                                }
                              }
                            }
                          }else{
                            _provider.alertDialog(context :context, title: 'Save' , content:'Save Failed');
                          }
                        },
                        icon: Icon(Icons.add),
                        label: Text("Save"),
                        color: Colors.orange[700],
                      )
                    ],
                  ),
                ),
              ),
              TabBar(tabs: [
                Tab(
                  child: Text(
                    'General',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Tab(
                  child: Text(
                    'Inventory',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              ]),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    child: TabBarView(children: [
                      //General
                      ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {

                                      uploadStorage();
                                      // ImagePicker picker = ImagePicker();
                                      // final XFile? pickedfile = await picker.pickImage(source: ImageSource.gallery);
                                      // if(pickedfile != null){
                                      //   setState(() {
                                      //     _image = File(pickedfile.path);
                                      //     //this.image = File(pickedfile.path);
                                      //   });
                                      // }else{
                                      //   print('No image Selected');
                                      // }
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Card(
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          child:Center(child: Text(_image))
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                                Container(padding: EdgeInsets.all(20),
                                    width: double.infinity,
                                    child: Text("Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                                TextFormField(
                                  controller: _productNameTextController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Enter Product name';
                                    }
                                    setState(() {
                                      productName = value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Product Name',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey))),
                                ),
                                TextFormField(
                                  controller: _brandNameTextController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Enter Brand name';
                                    }
                                    setState(() {
                                      brandName = value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Brand',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.grey))),
                                ),
                                TextFormField(
                                  controller: _sellingPriceTextController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Enter selling price';
                                    }
                                    setState(() {
                                      sellingPrice = double.parse(value);
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Price',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey))),
                                ),
                                TextFormField(
                                  controller: _comparedPriceTextController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Enter Compared Price';
                                    }
                                    if(sellingPrice>double.parse(value)){
                                      return 'Compared Price must be higher';
                                    }
                                    setState(() {
                                      comparedPrice = double.parse(value);
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Compared Price',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey))),
                                ),
                                TextFormField(
                                  maxLines: 5,
                                  maxLength: 500,
                                  controller: _productDescriptionTextController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Enter Description';
                                    }
                                    setState(() {
                                      productDescription = value;
                                    });
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'About Product',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.grey))),
                                ),
                                // Container(
                                //   child: Row(
                                //     children: [
                                //       Text("Collection",style: TextStyle(color: Colors.grey),),
                                //       SizedBox(width: 10,),
                                //       DropdownButton<String>(hint: Text("Select Collection"),
                                //           value: dropDownValue,
                                //           icon: Icon(Icons.arrow_downward_rounded),
                                //           onChanged: (value){
                                //         setState(() {
                                //           dropDownValue = value!;
                                //         });
                                //           },
                                //           items: _collection.map<DropdownMenuItem<String>>((String value) {
                                //             return DropdownMenuItem(value:value,child: Text(value));
                                //           }).toList())
                                //     ],
                                //   ),
                                // ),
                                //Category
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Category",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: TextFormField(
                                            controller: _categoryTextController,
                                            validator: (value){
                                              if(value!.isEmpty){
                                                return 'Select Category';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                                hintText: 'Not Selected',
                                                labelStyle:
                                                    TextStyle(color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey))),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return CategoryList();
                                                }).whenComplete(() {
                                              setState(() {
                                                _categoryTextController.text =_provider.selectedCategory;
                                                _visible = true;
                                              });
                                            });
                                          },
                                          icon: Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                                //SubCategory
                                Visibility(
                                  visible: _visible,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Sub-Category",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: AbsorbPointer(
                                            absorbing: true,
                                            child: TextFormField(
                                              validator: (value){
                                                if(value!.isEmpty){
                                                  return 'Select Sub-Category';
                                                }
                                                return null;
                                              },
                                              controller:
                                                  _subCategoryTextController,
                                              decoration: InputDecoration(
                                                  hintText: 'Not Selected',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.grey))),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SubCategoryList();
                                                  }).whenComplete(() {
                                                setState(() {
                                                  _subCategoryTextController
                                                          .text =
                                                      _provider
                                                          .selectedSubCategory;
                                                });
                                              });
                                            },
                                            icon: Icon(Icons.edit))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(padding: EdgeInsets.all(20),
                                    width: double.infinity,
                                    child: Text("Volume",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: TextFormField(
                                        controller: _v1TextController,
                                        validator: (value){
                                          setState(() {
                                            volume1 = value!;
                                          });
                                          return '-';
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Volume 1',
                                            labelStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.grey))),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: TextFormField(
                                        controller: _v2TextController,
                                        validator: (value){
                                          setState(() {
                                            volume2 = value!;
                                          });
                                          return '-';
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Volume 2',
                                            labelStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.grey))),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: TextFormField(
                                        controller: _v3TextController,
                                        validator: (value){
                                          setState(() {
                                            volume3 = value!;
                                          });
                                          return '-';
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Volume 3',
                                            labelStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.grey))),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      width: 100,
                                      child: TextFormField(
                                        controller: _v4TextController,
                                        validator: (value){
                                          setState(() {
                                            volume4 = value!;
                                          });
                                          return '-';
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Volume 4',
                                            labelStyle: TextStyle(color: Colors.grey),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.grey))),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      //Inventory
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            SwitchListTile(
                                title: Text("Track Inventory"),
                                activeColor: Theme.of(context).primaryColor,
                                subtitle: Text(
                                  'Switch ON to track',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                value: _track,
                                onChanged: (selected) {
                                  setState(() {
                                    _track = !_track;
                                  });
                                }),
                            Visibility(
                              visible: _track,
                              child: SizedBox(
                                height: 300,
                                width: double.infinity,
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _quantityTextController,
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return 'Enter Available Quantity';
                                            }
                                            setState(() {
                                              qty = int.parse(value);
                                            });
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: ' Inventory Quantity',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey))),
                                        ),
                                        TextFormField(
                                          controller: _minquantityTextController,
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return 'Enter Minimum Quantity';
                                            }
                                            if(qty<int.parse(value)){
                                              return 'Available Quantity must be higher';
                                            }
                                            setState(() {
                                              minqty = int.parse(value);
                                            });
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              labelText: 'Min Quantity',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void uploadImage({required Function(File file) onSelected}) {
    FileUploadInputElement uploadInput = FileUploadInputElement()
      ..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  void uploadStorage() {
    final dateTime = DateTime.now();
    final path = 'productImage/$dateTime';
    uploadImage(onSelected: (file) {
      if (file != null) {
        setState(() {
          _image = file.name;
          _url = path;
        });
        db
            .storage()
            .refFromURL('gs://application-1c3c2.appspot.com')
            .child(path)
            .put(file);
      }
    });
  }

}
