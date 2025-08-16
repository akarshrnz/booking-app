part of 'booking_bloc.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class BookSpaceEvent extends BookingEvent {
  final Booking booking;

  const BookSpaceEvent(this.booking);

  @override
  List<Object> get props => [booking];
}

class CheckAvailabilityEvent extends BookingEvent {
  final String branchId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const CheckAvailabilityEvent({
    required this.branchId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object> get props => [branchId, date, startTime, endTime];
}

class GetUserBookingsEvent extends BookingEvent {}