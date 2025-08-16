part of 'branch_bloc.dart';

abstract class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object> get props => [];
}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<Branch> branches;

  const BranchLoaded({required this.branches});

  @override
  List<Object> get props => [branches];
}

class BranchError extends BranchState {
  final String message;

  const BranchError({required this.message});

  @override
  List<Object> get props => [message];
}