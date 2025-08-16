import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/utils/responsive.dart';
import 'package:innerspace_booking_app/features/branch/domain/entities/branch.dart';

class BranchCard extends StatelessWidget {
  final Branch branch;
  final VoidCallback onTap;

  const BranchCard({
    super.key,
    required this.branch,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: ScreenUtil.setHeight(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil.setWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                branch.name,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: ScreenUtil.setHeight(8)),
              Text(
                '${branch.city}, ${branch.location}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: ScreenUtil.setHeight(8)),
              Text(
                '\$${branch.pricePerHour.toStringAsFixed(2)} / hour',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}