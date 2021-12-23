import 'package:admin/Screens/SideBar/AboutUs/AboutUs.dart';
import 'package:admin/Screens/SideBar/Cancelation/Cancellation.dart';
import 'package:admin/Screens/SideBar/ContactUs/ContactUs.dart';
import 'package:admin/Screens/SideBar/ConvenienceFee/Conveniencefee.dart';
import 'package:admin/Screens/SideBar/TermOfUse/Termsofuse.dart';
import 'package:admin/Services/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class SideBarContent extends StatefulWidget {
  static const String id = 'SideBar';

  @override
  _SideBarContentState createState() => _SideBarContentState();
}

class _SideBarContentState extends State<SideBarContent> {
  @override
  Widget build(BuildContext context) {
    SidebarWidget _sideBar = SidebarWidget();
    return AdminScaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'SideBar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sideBar.sideBarmenus(context, SideBarContent.id),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Side Bar Content',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
            Divider(
              thickness: 5,
            ),
            Container(
              height: 450,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: AboutUs(),
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            Container(
              height: 450,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: ContactUs(),
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            Container(
              height: 450,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: TermsOfUse(),
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            Container(
              height: 450,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: Cancelation(),
                ),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            Container(
              height: 450,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: Conveniencefee(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
