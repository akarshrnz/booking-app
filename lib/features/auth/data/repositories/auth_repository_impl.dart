import 'package:dartz/dartz.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:innerspace_booking_app/features/auth/domain/entities/user_entity.dart';
import 'package:innerspace_booking_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> register(
      String email, String password, String name, String phone) async {
    try {
      final user = await remoteDataSource.register(email, password, name, phone);
      if (user != null) {
        return Right(UserEntity(uid: user.uid, email: email, userId: user.uid));
      }
      return Left(ServerFailure(message: "Registration failed"));
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      if (user != null) {
        final data = await remoteDataSource.getUserData(user.uid);
        return Right(UserEntity(
          uid: user.uid,
          email: user.email ?? '',
          userId: data?['userId'] ?? user.uid,
        ));
      }
      return Left(ServerFailure(message: "Login failed"));
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Either<Failure, UserEntity?> getCurrentUser() {
    try {
      final user = remoteDataSource.getCurrentUser();
      if (user != null) {
        return Right(UserEntity(uid: user.uid, email: user.email ?? '', userId: user.uid));
      }
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
