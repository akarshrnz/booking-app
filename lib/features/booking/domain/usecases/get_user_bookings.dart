import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';
import 'package:innerspace_booking_app/features/booking/domain/repositories/booking_repository.dart';

class GetUserBookings {
  final BookingRepository repository;

  GetUserBookings(this.repository);

  Future<Either<Failure, List<Booking>>> call(String userId) async {
    return await repository.getUserBookings(userId);
  }
}