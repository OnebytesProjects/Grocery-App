import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:milk/providers/referal_provider.dart';
import 'package:provider/provider.dart';

class CheckReferalId extends StatefulWidget {
  const CheckReferalId({Key? key}) : super(key: key);

  @override
  _CheckReferalIdState createState() => _CheckReferalIdState();
}

class _CheckReferalIdState extends State<CheckReferalId> {
  var referalText = TextEditingController();

  Color color = Colors.grey;
  bool _enable = false;

  @override
  Widget build(BuildContext context) {
    var _referal = Provider.of<ReferalProvider>(context);
    return SizedBox(
      height: 40,
      child: Row(children: [
        Expanded(child: SizedBox(
          height: 38,
          child: TextField(
            controller: referalText,
            decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Enter Referal Code'
            ),
            onChanged: (String value){
              if(value.length==6){
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
                  _referal.exist = false;
                });
              }
            },
          ),
        )),
        AbsorbPointer(
          absorbing: _enable?false:true,
          child: OutlineButton(borderSide: BorderSide(color: color),onPressed: (){
            _referal.getReferalDetails(referalText.text).then((value) {
              if(_referal.exist == true){
                showDialog('Referal Applied Successfully');
                _referal.referalid = referalText.text;
              }
              if(_referal.exist == false){
                referalText.clear();
                showDialog('Invalid ReferalCode');
                setState(() {
                  color = Colors.grey;
                  _enable = false;
                });
              }
            });
          },child: const Text('Apply'),),
        )
      ],),
    );
  }
  showDialog(message){
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        content: Text('$message'),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text('Ok'))
        ],
      );
    });
  }
}