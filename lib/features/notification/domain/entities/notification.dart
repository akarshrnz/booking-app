import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
  });

    @override
  List<Object?> get props => [id, title, body, timestamp];
}