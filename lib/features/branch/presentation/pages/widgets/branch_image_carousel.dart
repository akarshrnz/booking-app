import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:innerspace_booking_app/core/utils/responsive.dart';

class BranchImageCarousel extends StatelessWidget {
  final List<String> imageUrls;

  const BranchImageCarousel({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: ScreenUtil.setHeight(200),
        autoPlay: true,
        aspectRatio: 16 / 9,
        viewportFraction: 1.0,
      ),
      items: imageUrls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: ScreenUtil.setWidth(4)),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: NetworkImage(url),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}