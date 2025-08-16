import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';
import 'package:innerspace_booking_app/features/booking/domain/repositories/booking_repository.dart';

class CheckBookingAvailability {
  final BookingRepository repository;

  CheckBookingAvailability(this.repository);

  Future<Either<Failure, bool>> call(
    String branchId,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    return await repository.checkBookingAvailability(
      branchId,
      date,
      startTime,
      endTime,
    );
  }
}