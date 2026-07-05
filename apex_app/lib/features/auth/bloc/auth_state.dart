import 'package:equatable/equatable.dart';

import '../../../core/models/client.dart';

enum AuthStatus { initial, phoneInput, otpSent, authenticated, loading, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? phone;
  final String? errorMessage;
  final Client? client;

  const AuthState({
    this.status = AuthStatus.initial,
    this.phone,
    this.errorMessage,
    this.client,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? phone,
    String? errorMessage,
    Client? client,
  }) {
    return AuthState(
      status: status ?? this.status,
      phone: phone ?? this.phone,
      errorMessage: errorMessage,
      client: client ?? this.client,
    );
  }

  @override
  List<Object?> get props => [status, phone, errorMessage, client];
}
