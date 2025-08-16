import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:innerspace_booking_app/core/failures.dart';
import 'package:innerspace_booking_app/features/branch/domain/entities/branch.dart';
import 'package:innerspace_booking_app/features/branch/domain/usecases/get_branches.dart';
import 'package:innerspace_booking_app/features/branch/domain/usecases/search_branches.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final GetBranches getBranches;
  final SearchBranches searchBranches;

  BranchBloc({
    required this.getBranches,
    required this.searchBranches,
  }) : super(BranchInitial()) {
    on<GetAllBranches>(_onGetAllBranches);
    on<SearchBranchesEvent>(_onSearchBranches);
  }

  Future<void> _onGetAllBranches(
    GetAllBranches event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    final result = await getBranches();
    result.fold(
      (failure) => emit(BranchError(message: _mapFailureToMessage(failure))),
      (branches) => emit(BranchLoaded(branches: branches)),
    );
  }

  Future<void> _onSearchBranches(
    SearchBranchesEvent event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    final result = await searchBranches(event.query);
    result.fold(
      (failure) => emit(BranchError(message: _mapFailureToMessage(failure))),
      (branches) => emit(BranchLoaded(branches: branches)),
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
