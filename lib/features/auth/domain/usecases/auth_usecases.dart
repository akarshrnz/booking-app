
import 'package:dartz/dartz.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/auth/domain/repositories/auth_repository.dart';

import '../entities/user_entity.dart';

class AuthUseCases {
  final AuthRepository repository;

  AuthUseCases(this.repository);

  Future<Either<Failure, UserEntity>> register(
    String email,
    String password,
    String name,
    String phone,
  ) {
    return repository.register(email, password, name, phone);
  }

  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) {
    return repository.login(email, password);
  }

  Future<Either<Failure, void>> logout() {
    return repository.logout();
  }

  Either<Failure, UserEntity?> getCurrentUser() {
    return repository.getCurrentUser();
  }
}
