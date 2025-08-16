import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/utils/responsive.dart';

class AmenitiesChip extends StatelessWidget {
  final String amenity;

  const AmenitiesChip({super.key, required this.amenity});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(amenity),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        fontSize: ScreenUtil.setSp(12),
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}