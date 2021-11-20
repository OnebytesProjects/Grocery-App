import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  final Function(String)? onItemClick;

  const MenuWidget({Key? key, this.onItemClick}) : super(key: key);

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          sliderItem('Products', Icons.shopping_bag_outlined),
          sliderItem('Orders', Icons.list_alt_outlined),
          sliderItem('Subscription', Icons.book_outlined),
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) => InkWell(
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
          )
        )
      ),
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Icon(icons,color: Colors.black54,size: 18,),
              SizedBox(width: 10,),
              Text(title,style: TextStyle(color: Colors.black54,fontSize: 12),)
            ],
          ),
        ),
      ),
    ),
      onTap: () {
        widget.onItemClick!(title);
      });
}