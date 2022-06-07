import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:surveymonkey_prototype/data/repositories/get_coins_repository.dart';

part 'get_coins_state.dart';

class GetCoinsCubit extends Cubit<GetCoinsState> {
  final GetCoinsRepository getCoinsRepository;
  GetCoinsCubit(this.getCoinsRepository) : super(CoinsNotFetched());

  Future<void> getCoins() async {
    emit(CoinsLoading());
    try {
      int userCoins = await getCoinsRepository.getCoins();
      emit(CoinsFetched(userCoins));
    } catch (e) {
      emit(CoinsFetchError(e.toString()));
      emit(CoinsNotFetched());
    }
  }
}
