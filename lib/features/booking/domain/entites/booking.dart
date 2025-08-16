import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Booking {
  final String id;
  final String branchId;
  final String branchName;
  final String userId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double totalPrice;
  final String status; // 'upcoming', 'completed', 'cancelled'

  const Booking({
    required this.id,
    required this.branchId,
    required this.branchName,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });

  Duration get duration {
    final start = DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );
    final end = DateTime(
      date.year,
      date.month,
      date.day,
      endTime.hour,
      endTime.minute,
    );
    return end.difference(start);
  }

  double get hours {
    return duration.inMinutes / 60;
  }
}