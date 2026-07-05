import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/otp_widget.dart';
import '../widgets/phone_input_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case AuthStatus.initial:
            case AuthStatus.phoneInput:
              return PhoneInputWidget(
                isLoading: false,
                onSubmit: (phone) {
                  context.read<AuthBloc>().add(SendOtp(phone));
                },
              );
            case AuthStatus.loading:
              // если код уже отправлен — не перекидываем на ввод номера
              if (state.phone != null) {
                return OtpWidget(
                  phone: state.phone!,
                  isLoading: true,
                  errorMessage: null,
                  onSubmit: (code) {
                    context.read<AuthBloc>().add(VerifyOtp(
                          phone: state.phone!,
                          code: code,
                        ));
                  },
                  onResend: () =>
                      context.read<AuthBloc>().add(SendOtp(state.phone!)),
                );
              }
              return PhoneInputWidget(
                isLoading: true,
                onSubmit: (phone) {
                  context.read<AuthBloc>().add(SendOtp(phone));
                },
              );
            case AuthStatus.otpSent:
              return OtpWidget(
                phone: state.phone ?? '',
                isLoading: false,
                errorMessage: state.errorMessage,
                onSubmit: (code) {
                  context.read<AuthBloc>().add(VerifyOtp(
                        phone: state.phone ?? '',
                        code: code,
                      ));
                },
                onResend: () {
                  if (state.phone != null) {
                    context.read<AuthBloc>().add(SendOtp(state.phone!));
                  }
                },
              );
            case AuthStatus.authenticated:
              // после успешной аутентификации экран сам закроется через main
              return const SizedBox.shrink();
            case AuthStatus.error:
              // ошибка показывается через SnackBar, возвращаемся к вводу номера
              return PhoneInputWidget(
                onSubmit: (phone) {
                  context.read<AuthBloc>().add(SendOtp(phone));
                },
              );
          }
        },
      ),
    );
  }
}
