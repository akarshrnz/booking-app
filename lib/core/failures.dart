// Abstract failure class that all other failures will extend
abstract class Failure {
  final String message;

  const Failure({required this.message});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error occurred'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network error occurred'});
}

class InvalidInputFailure extends Failure {
  const InvalidInputFailure({super.message = 'Invalid input'});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Unauthorized access'});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message = 'Resource not found'});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({super.message = 'Request timed out'});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'Unexpected error occurred'});
}

// Specific feature failures
class BookingFailure extends Failure {
  const BookingFailure({super.message = 'Booking error occurred'});
}

class BranchFailure extends Failure {
  const BranchFailure({super.message = 'Branch error occurred'});
}

class MapFailure extends Failure {
  const MapFailure({super.message = 'Map error occurred'});
}

class NotificationFailure extends Failure {
  const NotificationFailure({super.message = 'Notification error occurred'});
}
class Exception extends Failure {
  final String? msg;
  const Exception({this.msg,super.message = 'Something went wrong'});
}