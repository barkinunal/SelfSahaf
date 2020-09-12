import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';


class HomePageCarousel extends StatelessWidget {

  List<Image> bookImages;
 List<AssetImage> localImages=[
          
          AssetImage("images/carousel/kitap1.png",),
          AssetImage("images/carousel/kitap2.jpg"),
          AssetImage("images/carousel/kitap3.jpg"),
          AssetImage("images/carousel/kitap4.jpg"),
          
        ].toList();
          HomePageCarousel({this.bookImages});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: new Carousel(
        autoplayDuration: Duration(seconds: 3),
        dotSize: 3.8,
        dotBgColor: Colors.transparent,
        boxFit: BoxFit.cover,
        images: (bookImages==null)?localImages:bookImages.toList(),
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
      ),
    );
  }
}
