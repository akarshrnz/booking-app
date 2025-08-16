import 'package:dartz/dartz.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/branch/domain/entities/branch.dart';

abstract class BranchRepository {
  Future<Either<Failure, List<Branch>>> getBranches();
  Future<Either<Failure, List<Branch>>> searchBranches(String query);
}