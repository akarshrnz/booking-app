part of 'branch_bloc.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object> get props => [];
}

class GetAllBranches extends BranchEvent {}

class SearchBranchesEvent extends BranchEvent {
  final String query;

  const SearchBranchesEvent(this.query);

  @override
  List<Object> get props => [query];
}