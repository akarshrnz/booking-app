import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  bool get isUpcoming {
    final now = DateTime.now();
    final bookingDateTime = DateTime(
      booking.date.year,
      booking.date.month,
      booking.date.day,
      booking.startTime.hour,
      booking.startTime.minute,
    );
    return bookingDateTime.isAfter(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  booking.branchName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp, // Reduced size for balance
                        color: Colors.black87,
                      ),
                ),
              ),
              Icon(
                Icons.workspace_premium_rounded,
                color: Colors.orangeAccent.withOpacity(0.4),
                size: 22.sp,
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Date
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 14.sp, color: Colors.grey[600]),
              SizedBox(width: 6.w),
              Text(
                DateFormat.yMMMMd().format(booking.date),
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Time
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 14.sp, color: Colors.grey[600]),
              SizedBox(width: 6.w),
              Text(
                '${booking.startTime.format(context)} - ${booking.endTime.format(context)}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isUpcoming)
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'UPCOMING',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              Text(
                '\₹${booking.totalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
