import 'dart:html';

import 'package:admin/Services/Firebase_Services.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as db;



class CategorycreateWidget extends StatefulWidget {
  const CategorycreateWidget({Key? key}) : super(key: key);

  @override
  _CategorycreateWidgetState createState() => _CategorycreateWidgetState();
}

class _CategorycreateWidgetState extends State<CategorycreateWidget> {

  FirebaseServices _services = FirebaseServices();
  var _fileNameTextController = TextEditingController();
  var _categoryNameTextController = TextEditingController();
  bool _visible = false;
  bool _imageSelected = true;
  late String _url;

  @override
  Widget build(BuildContext context) {

    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 30,
                      child: TextField(
                        controller: _categoryNameTextController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1)),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'No category Name given',
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.only(left: 20)),
                      ),
                    ),
                    AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                          width: 200,
                          height: 30,
                          child: TextField(
                            controller: _fileNameTextController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1)),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'No Image Selected',
                                border: OutlineInputBorder(),
                                contentPadding:
                                EdgeInsets.only(left: 20)),
                          )),
                    ),
                    FlatButton(
                      child: Text(
                        "Upload Image",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        uploadStorage();
                      },
                      color: Colors.black54,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AbsorbPointer(
                        absorbing: _imageSelected,
                        child: FlatButton(
                            onPressed: () {
                              if(_categoryNameTextController.text.isEmpty){
                                _services.showMyDialog(
                                  context: context,
                                  title: 'Add New Category',
                                  message: 'New Category Name not given',
                                );
                              }else{
                                progressDialog.show();
                                _services
                                    .uploadCategoryImageToDb(_url, _categoryNameTextController.text)
                                    .then((downloadUrl) {
                                  if (downloadUrl != null) {
                                    progressDialog.dismiss();
                                    _services.showMyDialog(
                                        title: 'New Category',
                                        message: "Saved New Category Successfully",
                                        context: context);
                                  }
                                });
                                _categoryNameTextController.clear();
                                _fileNameTextController.clear();
                              }

                            },
                            child: Text("Save New Category ",
                                style:
                                TextStyle(color: Colors.white)),
                            color: _imageSelected
                                ? Colors.black12
                                : Colors.black54))
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Visibility(
              visible: _visible ? false : true,
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      _visible = true;
                    });
                  },
                  child: Text("Add New Category",
                      style: TextStyle(color: Colors.white)),
                  color: Colors.black54),
            )
          ],
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
    final path = 'CategoryImage/$dateTime';
    uploadImage(onSelected: (file) {
      if (file != null) {
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected = false;
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
