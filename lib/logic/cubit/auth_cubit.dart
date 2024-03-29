import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit({required this.authRepository}) : super(UnAuthenticated());

  Future<void> signInRequested(String email, String password) async {
    emit(Loading());
    try {
      await authRepository.signIn(email: email, password: password);
      emit(Authenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> signUpRequested(String email, String password) async {
    emit(Loading());
    try {
      await authRepository.signUp(email: email, password: password);
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(UnAuthenticated());
    }
  }

  Future<void> signOutRequested() async {
    emit(Loading());
    await authRepository.signOut();
    emit(UnAuthenticated());
  }

  Future<void> updateDisplayName(String displayName) async {
    await authRepository.updateDisplayName(displayName);
  }

  Future<void> updatePassword(String password, String oldPassword) async {
    await authRepository.updatePassword(password, oldPassword);
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
  }

  Future<void> addCoins(int coins, String purposeText) async {
    try {
      await authRepository.addCoins(coins, purposeText);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> subtractCoins(int coins, String purposeText) async {
    try {
      await authRepository.subtractCoins(coins, purposeText);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await authRepository.forgotPassword(email);
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
