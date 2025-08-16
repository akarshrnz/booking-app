import 'package:dartz/dartz.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/branch/domain/entities/branch.dart';
import 'package:innerspace_booking_app/features/branch/domain/repositories/branch_repository.dart';

class SearchBranches {
  final BranchRepository repository;

  SearchBranches(this.repository);

  Future<Either<Failure, List<Branch>>> call(String query) async {
    return await repository.searchBranches(query);
  }
}