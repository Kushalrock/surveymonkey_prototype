part of 'get_coins_cubit.dart';

abstract class GetCoinsState extends Equatable {
  const GetCoinsState();

  @override
  List<Object> get props => [];
}

class CoinsNotFetched extends GetCoinsState {}

class CoinsFetched extends GetCoinsState {
  final int userCoins;
  CoinsFetched(this.userCoins);
  @override
  List<Object> get props => [userCoins];
}

class CoinsLoading extends GetCoinsState {}

class CoinsFetchError extends GetCoinsState {
  final String errorString;
  CoinsFetchError(this.errorString);
  @override
  List<Object> get props => [errorString];
}
