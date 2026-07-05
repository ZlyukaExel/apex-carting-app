import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiClient _apiClient;

  AuthBloc(this._apiClient) : super(const AuthState()) {
    on<SendOtp>(_onSendOtp);
    on<VerifyOtp>(_onVerifyOtp);
    on<ResetAuth>(_onResetAuth);
    on<Logout>(_onLogout);
  }

  Future<void> _onSendOtp(SendOtp event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _apiClient.requestOtp(event.phone);
      emit(state.copyWith(
        status: AuthStatus.otpSent,
        phone: event.phone,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.message,
      ));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final client = await _apiClient.verifyOtp(event.phone, event.code);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        client: client,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.otpSent,
        errorMessage: e.message,
      ));
    }
  }

  void _onResetAuth(ResetAuth event, Emitter<AuthState> emit) {
    emit(const AuthState());
  }

  void _onLogout(Logout event, Emitter<AuthState> emit) {
    emit(const AuthState());
  }
}
