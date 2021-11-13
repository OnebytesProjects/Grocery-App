import 'package:admin/Screens/Vendor/vendor%20service/drawer_menu_widget.dart';
import 'package:admin/Screens/Vendor/vendor%20service/drawer_services.dart';
import 'package:admin/Services/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class VendorScreen extends StatefulWidget {
  static const String id = 'vendor-screen';

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {

  DrawerServices _services = DrawerServices();
  SidebarWidget _sideBar = SidebarWidget();

  GlobalKey<SliderMenuContainerState> _key =
  new GlobalKey<SliderMenuContainerState>();
  late String title;

  @override
  void initState() {
    title = "Products";
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text('Vendor' ,style: TextStyle(color: Colors.white),),
      ),
      sideBar: _sideBar.sideBarmenus(context,VendorScreen.id),
      body: SliderMenuContainer(
          appBarColor: Colors.white,
          key: _key,
          sliderMenuOpenSize: 200,
          title: Text(
            'Vendor Screen',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              _key.currentState!.closeDrawer();
              setState(() {
                this.title = title;
              });
            },
          ),
          sliderMain: _services.drawerScreen(title)),
    );
  }
}
