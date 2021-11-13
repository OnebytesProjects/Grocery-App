import 'package:admin/Screens/Category/category_list_widget.dart';
import 'package:admin/Screens/Category/category_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../../Services/sidebar.dart';

class CategoryScreen  extends StatefulWidget {
  static const String id = 'category-screen';

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  SidebarWidget _sideBar = SidebarWidget();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text('Categories' ,style: TextStyle(color: Colors.white),),
      ),
      sideBar: _sideBar.sideBarmenus(context,CategoryScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Add New Categories and Sub Categories'),
              Divider(thickness: 5,),
              CategorycreateWidget(),
              Divider(thickness: 5,),
              CategoryListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
