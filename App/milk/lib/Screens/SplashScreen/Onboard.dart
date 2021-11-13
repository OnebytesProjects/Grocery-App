import 'package:flutter/material.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

final _controller = PageController(
  initialPage: 0,
);

List<Widget> _pages = [
  Column(
    children: [
      Expanded(
          child: Container(
        margin: EdgeInsets.all(50),
        child: Image.asset("images/splscrn.png"),
      )),
      Text("Your Content"),
    ],
  )
];

class _OnBoardState extends State<OnBoard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
          ),
        ),
      ],
    );
  }
}
