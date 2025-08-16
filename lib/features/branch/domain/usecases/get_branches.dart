import 'package:dartz/dartz.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/branch/domain/entities/branch.dart';
import 'package:innerspace_booking_app/features/branch/domain/repositories/branch_repository.dart';

class GetBranches {
  final BranchRepository repository;

  GetBranches(this.repository);

  Future<Either<Failure, List<Branch>>> call() async {
    return await repository.getBranches();
  }
}