import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:innerspace_booking_app/features/booking/data/models/booking_model.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';
import 'package:innerspace_booking_app/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> bookSpace(Booking booking) async {
    try {
      await remoteDataSource.bookSpace(
        BookingModel(
          id: booking.id,
          branchId: booking.branchId,
          branchName: booking.branchName,
          userId: booking.userId,
          date: booking.date,
          startTime: booking.startTime,
          endTime: booking.endTime,
          totalPrice: booking.totalPrice,
          status: booking.status,
        ),
      );
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkBookingAvailability(
    String branchId,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    try {
      final isAvailable = await remoteDataSource.checkBookingAvailability(
        branchId,
        date,
        startTime,
        endTime,
      );
      return Right(isAvailable);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getUserBookings(String userId) async {
    try {
      final bookings = await remoteDataSource.getUserBookings(userId);
      return Right(bookings);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
