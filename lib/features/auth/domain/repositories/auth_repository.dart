import 'package:dartz/dartz.dart';
import 'package:innerspace_booking_app/core/failures.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> register(
    String email,
    String password,
    String name,
    String phone,
  );

  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  );

  Future<Either<Failure, void>> logout();

  Either<Failure, UserEntity?> getCurrentUser();
}