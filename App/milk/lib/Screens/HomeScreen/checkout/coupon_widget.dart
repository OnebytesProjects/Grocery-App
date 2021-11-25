import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:milk/providers/coupon_provider.dart';
import 'package:provider/provider.dart';

class CoupunWidget extends StatefulWidget {
  const CoupunWidget({Key? key}) : super(key: key);

  @override
  _CoupunWidgetState createState() => _CoupunWidgetState();
}

class _CoupunWidgetState extends State<CoupunWidget> {
  var _couponText = TextEditingController();

  Color color = Colors.grey;
  bool _enable = false;

  @override
  Widget build(BuildContext context) {
    var _coupon = Provider.of<CouponProvider>(context);
    return Container(
      height: 40,
      child: Row(children: [
        Expanded(child: SizedBox(
          height: 38,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom:BorderSide(width: 2.0, color: Colors.black45),
              ),
            ),
            child: TextFormField(
              controller: _couponText,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter Coupon Code'
              ),
              onChanged: (String value){
                if(value.length>3){
                  if(value.isNotEmpty){
                    setState(() {
                      color=Colors.green;
                      _enable = true;
                    });
                  }
                }else{
                  setState(() {
                    color = Colors.grey;
                    _enable = false;
                    _coupon.discountrate = 0;
                  });
                }
              },
            ),
          ),
        )),
        AbsorbPointer(
          absorbing: _enable?false:true,
          child: OutlineButton(borderSide: BorderSide(color: color),onPressed: (){
            _coupon.getCouponDetails(_couponText.text).then((value) {
              if(value.data()==null || _coupon.expired == true){
                _coupon.discountrate = 0;
                _couponText.clear();
                EasyLoading.dismiss();
                showDialog('Invalid or Expired');
                setState(() {
                  color = Colors.grey;
                  _enable = false;
                });
              }
            });
          },child: Text('Apply'),),
        )
      ],),
    );
  }
  showDialog(message){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        title: Text('Coupon'),
        content: Text('The entered coupon is $message'),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Ok'))
        ],
      );
    });
  }
}
