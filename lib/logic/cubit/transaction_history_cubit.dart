import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:surveymonkey_prototype/data/models/transaction_history_model.dart';
import 'package:surveymonkey_prototype/data/repositories/transaction_history_repository.dart';
import 'package:surveymonkey_prototype/logic/cubit/question_cubit.dart';

part 'transaction_history_state.dart';

class TransactionHistoryCubit extends Cubit<TransactionHistoryState> {
  final TransactionHistoryRepository transactionHistoryRepository;
  TransactionHistoryCubit(this.transactionHistoryRepository)
      : super(TransactionHistoryLoading());

  Future<void> transactionHistoryRequested() async {
    emit(TransactionHistoryLoading());
    try {
      emit(TransactionHistoryLoaded(
          await transactionHistoryRepository.getTransactionHistory()));
    } on Exception catch (e) {
      emit(TransactionHistoryError(e.toString()));
      emit(TransactionHistoryLoading());
    }
  }
}
