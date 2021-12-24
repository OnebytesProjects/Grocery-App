import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CarouselSliderView extends StatefulWidget {
  const CarouselSliderView({Key? key}) : super(key: key);

  @override
  _CarouselSliderViewState createState() => _CarouselSliderViewState();
}

class _CarouselSliderViewState extends State<CarouselSliderView> {
  final List<String> imagesList = [];
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('slider')
        .get()
        .then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        setState(() {
          imagesList.add(doc['image']);
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
        ),
        items: imagesList
            .map(
              (item) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  width: double.infinity,
            child: Image.network(
                item,
                fit: BoxFit.fill,
            ),
          ),
              ),
        )
            .toList(),
      );
  }
}
