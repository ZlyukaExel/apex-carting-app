import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bloc/booking_state.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final BookingState bookingState;
  const BookingConfirmationScreen({super.key, required this.bookingState});

  @override
  Widget build(BuildContext context) {
    final slot = bookingState.slot!;
    final dateFormat = DateFormat('d MMMM yyyy, HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Бронирование подтверждено')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                'Заезд забронирован!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _infoRow('Номер брони', '#${bookingState.bookingId ?? '—'}'),
                      const Divider(),
                      _infoRow('Дата и время',
                          dateFormat.format(slot.startAt.toLocal())),
                      const Divider(),
                      _infoRow('Трасса', slot.trackName),
                      const Divider(),
                      _infoRow('Маршал', slot.marshalName),
                      const Divider(),
                      _infoRow('Мест', '${bookingState.seats}'),
                      if (bookingState.rentalCount > 0) ...[
                        const Divider(),
                        _infoRow(
                            'Аренда экип.', '${bookingState.rentalCount}'),
                      ],
                      const Divider(),
                      _infoRow(
                        'К оплате на месте',
                        '${bookingState.priceTotal} ₽',
                        valueStyle: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Оплата на месте наличными или переводом.',
                style: TextStyle(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                    (route) => false,
                  );
                },
                child: const Text('На главную'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
