import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/utils/responsive.dart';

class OperatingHoursTable extends StatelessWidget {
  final Map<String, String> operatingHours;

  const OperatingHoursTable({super.key, required this.operatingHours});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Colors.grey[300]!,
        width: ScreenUtil.setWidth(1),
      ),
      children: operatingHours.entries.map((entry) {
        return TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(ScreenUtil.setWidth(8)),
              child: Text(
                entry.key,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil.setWidth(8)),
              child: Text(
                entry.value,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}