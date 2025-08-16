import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';

abstract class BookingRepository {
  Future<Either<Failure, void>> bookSpace(Booking booking);
  Future<Either<Failure, bool>> checkBookingAvailability(
    String branchId,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  );
  Future<Either<Failure, List<Booking>>> getUserBookings(String userId);
}