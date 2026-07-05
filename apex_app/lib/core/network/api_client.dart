import 'dart:math';

import '../models/client.dart';

class ApiClient {
  final Random _random = Random();

  Future<void> _simulateDelay() async {
    // имитация задержки сети 500–1500 мс
    final delay = Duration(milliseconds: 500 + _random.nextInt(1000));
    await Future.delayed(delay);
  }

  Future<Client> requestOtp(String phone) async {
    await _simulateDelay();
    // заглушка: всегда "отправляем" код 1234
    return Client(id: '', name: '', phone: phone);
  }

  Future<Client> verifyOtp(String phone, String code) async {
    await _simulateDelay();
    if (code != '1234') {
      throw ApiException('Неверный код подтверждения');
    }
    return Client(
      id: 'client_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Гонщик',
      phone: phone,
      accessToken: 'mock_access_token_${_random.nextInt(99999)}',
      refreshToken: 'mock_refresh_token_${_random.nextInt(99999)}',
    );
  }

  Future<List<Map<String, dynamic>>> getSlots({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? trackType,
    String? marshalId,
    bool? onlyAvailable,
  }) async {
    await _simulateDelay();
    // заглушка: возвращаем тестовые слоты
    final now = DateTime.now();
    final slots = <Map<String, dynamic>>[];
    for (var day = 0; day < 7; day++) {
      for (var hour = 10; hour < 20; hour += 2) {
        final start = DateTime(now.year, now.month, now.day + day, hour, 0);
        if (start.isBefore(now)) continue;
        if (dateFrom != null && start.isBefore(dateFrom)) continue;
        if (dateTo != null && start.isAfter(dateTo)) continue;

        final isNovice = _random.nextBool();
        final trackTypeName = isNovice ? 'novice' : 'experienced';
        if (trackType != null && trackTypeName != trackType) continue;

        final freeKarts = _random.nextInt(6);
        if (onlyAvailable == true && freeKarts == 0) continue;

        slots.add({
          'id': 'slot_${start.millisecondsSinceEpoch}',
          'start_at': start.toIso8601String(),
          'track_config': {
            'id': 'track_${isNovice ? 'n' : 'e'}_$day',
            'name': isNovice ? 'Новичковая трасса' : 'Спортивная трасса',
            'description': isNovice
                ? 'Простая трасса для начинающих, 800 м'
                : 'Сложная трасса с крутыми поворотами, 1200 м',
            'type': trackTypeName,
            'capacity_cap': 8,
            'duration_min': 10,
          },
          'marshal': {
            'id': 'marshal_${day % 3 + 1}',
            'name': ['Алексей', 'Дмитрий', 'Сергей'][day % 3],
          },
          'total_karts': 8,
          'free_karts': freeKarts,
          'free_rental_equipment': _random.nextInt(6),
          'price': 1500 + _random.nextInt(1000),
          'rental_price': 500,
          'meeting_point': 'Центральный вход, зона регистрации',
          'status': 'scheduled',
        });
      }
    }
    return slots;
  }

  /// имитация бронирования
  Future<Map<String, dynamic>> createBooking({
    required String slotId,
    required int seatsCount,
    required int rentalCount,
    required String idempotencyKey,
  }) async {
    await _simulateDelay();
    // с вероятностью 10% имитируем ошибку
    if (_random.nextInt(10) == 0) {
      throw ApiException('Ошибка сервера. Попробуйте ещё раз.');
    }
    return {
      'id': 'booking_${DateTime.now().millisecondsSinceEpoch}',
      'slot_id': slotId,
      'seats_count': seatsCount,
      'rental_count': rentalCount,
      'price_total': seatsCount * 1500 + rentalCount * 500,
      'status': 'active',
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
