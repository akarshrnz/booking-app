import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/app_constants.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/booking/data/models/booking_model.dart';

abstract class BookingRemoteDataSource {
  Future<void> bookSpace(BookingModel booking);
  Future<bool> checkBookingAvailability(
    String branchId,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  );
  Future<List<BookingModel>> getUserBookings(String userId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  BookingRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<void> bookSpace(BookingModel booking) async {
    try {
      await firestore
          .collection(AppConstants.bookingsCollection)
          .add(booking.toDocument());
    } on FirebaseException catch (e) {
      throw ServerFailure(message: e.message ?? 'Failed to create booking');
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  @override
  Future<bool> checkBookingAvailability(
    String branchId,
    DateTime date,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    try {
      final startTimeStr = '${startTime.hour}:${startTime.minute}';
      final endTimeStr = '${endTime.hour}:${endTime.minute}';

      final snapshot = await firestore
          .collection(AppConstants.bookingsCollection)
          .where('branchId', isEqualTo: branchId)
          .where('date', isEqualTo: Timestamp.fromDate(date))
          .where('status', whereIn: ['upcoming', 'completed'])
          .get();

      for (final doc in snapshot.docs) {
        final booking = BookingModel.fromSnapshot(doc);
        if (_isTimeOverlap(startTime, endTime, booking.startTime, booking.endTime)) {
          return false;
        }
      }
      return true;
    } on FirebaseException catch (e) {
      throw ServerFailure(message: e.message ?? 'Failed to check availability');
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }

  bool _isTimeOverlap(
    TimeOfDay start1,
    TimeOfDay end1,
    TimeOfDay start2,
    TimeOfDay end2,
  ) {
    final start1InMinutes = start1.hour * 60 + start1.minute;
    final end1InMinutes = end1.hour * 60 + end1.minute;
    final start2InMinutes = start2.hour * 60 + start2.minute;
    final end2InMinutes = end2.hour * 60 + end2.minute;

    return start1InMinutes < end2InMinutes && end1InMinutes > start2InMinutes;
  }

  @override
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.bookingsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerFailure(message: e.message ?? 'Failed to fetch bookings');
    } catch (e) {
      throw UnexpectedFailure(message: e.toString());
    }
  }
}
