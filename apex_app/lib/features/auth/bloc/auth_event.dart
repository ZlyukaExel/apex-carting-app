import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SendOtp extends AuthEvent {
  final String phone;
  const SendOtp(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyOtp extends AuthEvent {
  final String phone;
  final String code;
  const VerifyOtp({required this.phone, required this.code});

  @override
  List<Object?> get props => [phone, code];
}

class ResetAuth extends AuthEvent {}

class Logout extends AuthEvent {}
