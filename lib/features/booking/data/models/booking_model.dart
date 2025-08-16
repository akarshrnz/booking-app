import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required String id,
    required String branchId,
    required String branchName,
    required String userId,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required double totalPrice,
    required String status,
  }) : super(
          id: id,
          branchId: branchId,
          branchName: branchName,
          userId: userId,
          date: date,
          startTime: startTime,
          endTime: endTime,
          totalPrice: totalPrice,
          status: status,
        );

  factory BookingModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    final startTimeParts = (data['startTime'] as String).split(':');
    final endTimeParts = (data['endTime'] as String).split(':');

    return BookingModel(
      id: snap.id,
      branchId: data['branchId'],
      branchName: data['branchName'],
      userId: data['userId'],
      date: (data['date'] as Timestamp).toDate(),
      startTime: TimeOfDay(
        hour: int.parse(startTimeParts[0]),
        minute: int.parse(startTimeParts[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(endTimeParts[0]),
        minute: int.parse(endTimeParts[1]),
      ),
      totalPrice: (data['totalPrice'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'upcoming',
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}