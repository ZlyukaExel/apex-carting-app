# Баг 2: Неверный код из SMS перебрасывает на экран ввода номера телефона

## Описание
Если пользователь ввёл неверный код подтверждения из SMS, его перебрасывает обратно на экран ввода номера телефона вместо того, чтобы показать ошибку на текущем экране OTP.

## Причина
В `lib/features/auth/bloc/auth_bloc.dart` при ошибке верификации OTP (`VerifyOtp`) метод `_onVerifyOtp` эмитит стейт `AuthStatus.error`:

```dart
on ApiException catch (e) {
  emit(state.copyWith(status: AuthStatus.error, errorMessage: e.message));
}
```

В `lib/features/auth/screens/auth_screen.dart` `builder` функции `BlocConsumer` для стейта `AuthStatus.error` рендерит `PhoneInputWidget` (экран ввода номера), а не `OtpWidget`. Статус `error` не различает, какая операция вызвала ошибку — `SendOtp` или `VerifyOtp`.

Визуально: пользователь вводит код → нажимает "Подтвердить" → `VerifyOtp` → `AuthStatus.error` → `PhoneInputWidget` + SnackBar с ошибкой. Пользователь вылетает на первый экран.

## Решение
В `auth_bloc.dart` при ошибке `VerifyOtp` не переводить стейт в `AuthStatus.error`, а оставаться на `AuthStatus.otpSent` с `errorMessage`. Таким образом `OtpWidget` остаётся на экране и показывает `errorText` в TextField.

Файл: `lib/features/auth/bloc/auth_bloc.dart`
