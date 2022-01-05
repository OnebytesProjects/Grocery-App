import 'package:admin/Services/Firebase_Services.dart';
import 'package:admin/Services/sidebar.dart';
import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../Notification/notification_screen.dart';
import 'package:admin/Screens/Ad/AdWidget.dart';
import 'package:firebase/firebase.dart';
import 'dart:html';
import 'package:firebase/firebase.dart' as db;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AdScreen extends StatefulWidget {
  static const String id = 'Ad-screen';
  const AdScreen({Key? key}) : super(key: key);

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {

  SidebarWidget _sideBar = SidebarWidget();
  var _fileNameTextController = TextEditingController();
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  bool _imageSelected = true;
  late String _url;
  bool _enable = false;


  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(
        context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    SidebarWidget _sideBar = SidebarWidget();

    return AdminScaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text('Ad Screen' ,style: TextStyle(color: Colors.white),),
      ),
      sideBar: _sideBar.sideBarmenus(context,NotificationScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Ad-Screen',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text("Add/Delete Advertisment"),
              Divider(
                thickness: 5,
              ),
              AdWidget(),
              Divider(
                thickness: 5,
              ),
              Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: _visible,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AbsorbPointer(
                                absorbing: true,
                                child: SizedBox(
                                    width: 300,
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
                                          hintText: 'No Ad Selected',
                                          border: OutlineInputBorder(),
                                          contentPadding:
                                          EdgeInsets.only(left: 20)),
                                    )),
                              ),
                              FlatButton(
                                child: Text(
                                  "Upload Ad",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  EasyLoading.show(status: 'Please Wait');
                                  uploadStorage(context);
                                },
                                color: Colors.black54,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Visibility(
                                visible: _enable,
                                child: AbsorbPointer(
                                    absorbing: _imageSelected,
                                    child: FlatButton(
                                        onPressed: () {
                                          progressDialog.show();
                                          _services
                                              .uploadAdImageToDb(_url)
                                              .then((downloadUrl) {
                                            if (downloadUrl != null) {
                                              progressDialog.dismiss();
                                              _services.showMyDialog(
                                                  title: 'New Ad Image',
                                                  message: "Savd Successfully",
                                                  context: context);
                                              _fileNameTextController.clear();
                                            }
                                          });
                                          setState(() {
                                            _enable = false;
                                            _visible = false;
                                          });
                                        },
                                        child: Text("Save Image",
                                            style:
                                            TextStyle(color: Colors.white)),
                                        color: _imageSelected
                                            ? Colors.black12
                                            : Colors.black54)),
                              )
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
                            child: Text("Add Ad",
                                style: TextStyle(color: Colors.white)),
                            color: Colors.black54),
                      )
                    ],
                  ),
                ),
              )
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

  uploadStorage(context) async{
    final dateTime = DateTime.now();
    final path = 'Ad/$dateTime';
    uploadImage(onSelected: (file) async {
      if (file != null) {
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected = false;
          _url = path;
        });
        db.StorageReference ref = db.storage().refFromURL('gs://application-1c3c2.appspot.com').child(path);
        db.UploadTask uploadTask = ref.put(file);

        await uploadTask.future.then((UploadTaskSnapshot snapshot) {
          EasyLoading.dismiss();
          setState(() {
            _enable = true;
          });
        });
      }
    });
  }
}