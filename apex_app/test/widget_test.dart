import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apex/app.dart';
import 'package:apex/core/network/api_client.dart';

void main() {
  testWidgets('App launches and shows auth screen', (WidgetTester tester) async {
    await tester.pumpWidget(App(apiClient: ApiClient()));
    expect(find.text('Апекс'), findsOneWidget);
  });

  // Баг 1: кнопка Подтвердить не работала без предварительного нажатия
  // "Отправить код повторно", т.к. build() не вызывался при изменении текста
  testWidgets('Bug 1: OTP button enables after entering 4 digits and submits',
      (WidgetTester tester) async {
    await tester.pumpWidget(App(apiClient: ApiClient()));

    // вводим телефон и переходим на экран OTP
    await tester.enterText(find.byType(TextField), '+71234567890');
    await tester.pump();
    await tester.tap(find.text('Получить код'));
    await tester.pump();

    expect(find.text('Введите код'), findsOneWidget);

    // вводим 3 цифры — кнопка должна быть disabled
    await tester.enterText(find.byType(TextField), '123');
    await tester.pump();
    // tap не должен ничего сделать (кнопка disabled)
    await tester.tap(find.widgetWithText(ElevatedButton, 'Подтвердить'));
    await tester.pump();
    // всё ещё на экране OTP — не перешли на главную
    expect(find.text('Введите код'), findsOneWidget);

    // вводим 4-ю цифру — кнопка должна стать активной
    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();

    // теперь кнопка работает
    await tester.tap(find.widgetWithText(ElevatedButton, 'Подтвердить'));
    await tester.pump();

    // успешная аутентификация → главный экран
    expect(find.text('Апекс — заезды'), findsOneWidget);
  });

  // Баг 2: неверный код из SMS перебрасывал на экран ввода номера телефона
  testWidgets('Bug 2: invalid OTP stays on OTP screen, does not redirect to phone',
      (WidgetTester tester) async {
    await tester.pumpWidget(App(apiClient: ApiClient()));

    // вводим телефон и переходим на экран OTP
    await tester.enterText(find.byType(TextField), '+71234567890');
    await tester.pump();
    await tester.tap(find.text('Получить код'));
    await tester.pump();

    expect(find.text('Введите код'), findsOneWidget);

    // вводим неверный код (0000 вместо 1234)
    await tester.enterText(find.byType(TextField), '0000');
    await tester.pump();

    // нажимаем Подтвердить
    await tester.tap(find.widgetWithText(ElevatedButton, 'Подтвердить'));
    await tester.pump();

    // НЕ должны переброситься на экран телефона
    expect(find.text('Введите код'), findsOneWidget);
    expect(find.text('Номер телефона'), findsNothing);
  });

  // Баг 3: overflow в фильтрах (Debug android)
  testWidgets('Bug 3: slot filters render without overflow on narrow screen',
      (WidgetTester tester) async {
    // устанавливаем узкий экран (360dp — типичный android)
    tester.view.physicalSize = const Size(360, 720);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(App(apiClient: ApiClient()));

    // логинимся, чтобы попасть на главный экран со слотами
    await tester.enterText(find.byType(TextField), '+71234567890');
    await tester.pump();
    await tester.tap(find.text('Получить код'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Подтвердить'));
    await tester.pump();

    // проверяем, что фильтры присутствуют без исключений
    expect(find.text('Сегодня'), findsOneWidget);
    expect(find.text('Неделя'), findsOneWidget);
    expect(find.text('Выходные'), findsOneWidget);
    expect(find.text('Все трассы'), findsOneWidget);
    expect(find.text('Только свободные'), findsOneWidget);
    expect(find.text('Применить'), findsOneWidget);

    // проверяем, что не было overflow-ошибок
    expect(tester.takeException(), isNull);

    tester.view.reset();
  });

  // Интеграционный: полный флоу аутентификации
  testWidgets('Full auth flow: phone → OTP → main screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(App(apiClient: ApiClient()));

    // шаг 1 — экран телефона
    expect(find.text('Получить код'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '+71234567890');
    await tester.pump();
    await tester.tap(find.text('Получить код'));
    await tester.pump();

    // шаг 2 — экран OTP
    expect(find.text('Введите код'), findsOneWidget);
    expect(find.text('Отправить код повторно'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Подтвердить'));
    await tester.pump();

    // шаг 3 — главный экран
    expect(find.text('Апекс — заезды'), findsOneWidget);
  });
}
