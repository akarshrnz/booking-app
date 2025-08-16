
import 'package:dartz/dartz.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/booking/domain/entites/booking.dart';
import 'package:innerspace_booking_app/features/booking/domain/repositories/booking_repository.dart';

class BookSpace {
  final BookingRepository repository;

  BookSpace(this.repository);

  Future<Either<Failure, void>> call(Booking booking) async {
    return await repository.bookSpace(booking);
  }
}