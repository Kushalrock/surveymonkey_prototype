part of 'transaction_history_cubit.dart';

abstract class TransactionHistoryState extends Equatable {
  const TransactionHistoryState();

  @override
  List<Object> get props => [];
}

class TransactionHistoryLoading extends TransactionHistoryState {}

class TransactionHistoryLoaded extends TransactionHistoryState {
  final List<TransactionHistoryModel> transactionHistoryModel;

  TransactionHistoryLoaded(this.transactionHistoryModel);
  @override
  List<Object> get props => [transactionHistoryModel];
}

class TransactionHistoryError extends TransactionHistoryState {
  final String error;

  // ignore: prefer_const_constructors_in_immutables
  TransactionHistoryError(this.error);
  @override
  List<Object> get props => [error];
}
