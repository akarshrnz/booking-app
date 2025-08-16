import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/color_constant.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LocationSelector
    extends
        StatelessWidget {
  const LocationSelector({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_outlined,
            color: gradientOne,
          ),
          const SizedBox(
            width: 6,
          ),
          Stack(
            children: [
              Container(
                height: 1,
                width: 30,
                decoration: const BoxDecoration(),
              ),
              Text(
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: gradientOne,
                ),
                'Kochi',
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
