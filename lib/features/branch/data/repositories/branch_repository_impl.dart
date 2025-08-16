import 'package:dartz/dartz.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/branch/data/datasources/branch_remote_data_source.dart';
import 'package:innerspace_booking_app/features/branch/domain/entities/branch.dart';
import 'package:innerspace_booking_app/features/branch/domain/repositories/branch_repository.dart';

class BranchRepositoryImpl implements BranchRepository {
  final BranchRemoteDataSource remoteDataSource;

  BranchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Branch>>> getBranches() async {
    try {
      final branches = await remoteDataSource.getBranches();
      return Right(branches);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<Branch>>> searchBranches(String query) async {
    try {
      final branches = await remoteDataSource.searchBranches(query);
      return Right(branches);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
