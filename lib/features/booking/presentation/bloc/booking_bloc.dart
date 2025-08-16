import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';
import 'package:innerspace_booking_app/features/booking/domain/usecases/book_space.dart';
import 'package:innerspace_booking_app/features/booking/domain/usecases/check_booking_availability.dart';
import 'package:innerspace_booking_app/features/booking/domain/usecases/get_user_bookings.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookSpace bookSpace;
  final CheckBookingAvailability checkBookingAvailability;
  final GetUserBookings getUserBookings;
  final FirebaseAuth auth;

  BookingBloc({
    required this.bookSpace,
    required this.checkBookingAvailability,
    required this.getUserBookings,
    required this.auth,
  }) : super(BookingInitial()) {
    on<BookSpaceEvent>(_onBookSpace);
    on<CheckAvailabilityEvent>(_onCheckAvailability);
    on<GetUserBookingsEvent>(_onGetUserBookings);
  }

  Future<void> _onBookSpace(
    BookSpaceEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await bookSpace(event.booking);
    result.fold(
      (failure) => emit(BookingError(message: _mapFailureToMessage(failure))),
      (_) => emit(BookingSuccess()),
    );
  }

  Future<void> _onCheckAvailability(
    CheckAvailabilityEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await checkBookingAvailability(
      event.branchId,
      event.date,
      event.startTime,
      event.endTime,
    );
    result.fold(
      (failure) => emit(BookingError(message: _mapFailureToMessage(failure))),
      (isAvailable) => emit(AvailabilityChecked(isAvailable: isAvailable)),
    );
  }

  Future<void> _onGetUserBookings(
    GetUserBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final userId = auth.currentUser?.uid ?? '';
    final result = await getUserBookings(userId);
    result.fold(
      (failure) => emit(BookingError(message: _mapFailureToMessage(failure))),
      (bookings) => emit(BookingsLoaded(bookings: bookings)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : 'A server error occurred. Please try again.';
    } else if (failure is UnexpectedFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : 'An unexpected error occurred.';
    }
    return 'An unknown error occurred.';
  }
}
