import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../slots/bloc/slots_state.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../widgets/equipment_selector.dart';
import '../widgets/seat_selector.dart';

class BookingScreen extends StatefulWidget {
  final SlotModel slot;
  const BookingScreen({super.key, required this.slot});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(InitBooking(widget.slot));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Бронирование')),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStatus.success) {
            Navigator.of(context).pushReplacementNamed(
              '/booking-confirmation',
              arguments: state,
            );
          }
          if (state.status == BookingStatus.error &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == BookingStatus.initial ||
              state.slot == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final slot = state.slot!;
          final dateFormat = DateFormat('d MMMM, HH:mm');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // информация о слоте
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateFormat.format(slot.startAt.toLocal()),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(slot.trackName,
                            style:
                                Theme.of(context).textTheme.titleMedium),
                        Text(slot.trackDescription,
                            style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 8),
                        Text('Маршал: ${slot.marshalName}'),
                        Text('Свободно: ${slot.freeKarts} картов'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // выбор мест
                SeatSelector(
                  seats: state.seats,
                  maxSeats: state.maxSeats,
                  freeKarts: slot.freeKarts,
                  onChanged: (v) =>
                      context.read<BookingBloc>().add(UpdateSeats(v)),
                ),
                const SizedBox(height: 24),

                // выбор экипировки
                EquipmentSelector(
                  rentalCount: state.rentalCount,
                  maxRental: state.maxRental,
                  pricePerItem: slot.rentalPrice,
                  onChanged: (v) => context
                      .read<BookingBloc>()
                      .add(UpdateRentalCount(v)),
                ),
                const SizedBox(height: 32),

                // итог
                Card(
                  color: Colors.red[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Итого:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium),
                            const SizedBox(height: 4),
                            Text(
                              '${state.seats} мест(а) × ${slot.price} ₽',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            if (state.rentalCount > 0)
                              Text(
                                '${state.rentalCount} комплект(ов) × ${slot.rentalPrice} ₽',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          '${state.priceTotal} ₽',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Оплата производится на месте наличными или переводом.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
                const SizedBox(height: 24),

                // кнопка подтверждения
                ElevatedButton(
                  onPressed: state.status == BookingStatus.submitting
                      ? null
                      : () {
                          context
                              .read<BookingBloc>()
                              .add(const SubmitBooking());
                        },
                  child: state.status == BookingStatus.submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Подтвердить бронирование'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
