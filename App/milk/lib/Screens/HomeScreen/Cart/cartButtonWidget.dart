import 'package:flutter/material.dart';

class CartButtonWidget extends StatefulWidget {
  const CartButtonWidget({Key? key}) : super(key: key);

  @override
  _CartButtonWidgetState createState() => _CartButtonWidgetState();
}

class _CartButtonWidgetState extends State<CartButtonWidget> {
  int cartvalue = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FittedBox(
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  if(cartvalue>=1){
                    setState(() {
                      cartvalue -=1;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.orange,
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.remove),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                child: Text(cartvalue.toString()),
              ),
              InkWell(
                onTap: (){
                  if(cartvalue>=0){
                    setState(() {
                      cartvalue +=1;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.orange,
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
