import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/slots_bloc.dart';
import '../bloc/slots_event.dart';
import '../bloc/slots_state.dart';
import '../widgets/slot_card.dart';
import '../widgets/slot_filters.dart';

class SlotsScreen extends StatefulWidget {
  const SlotsScreen({super.key});

  @override
  State<SlotsScreen> createState() => _SlotsScreenState();
}

class _SlotsScreenState extends State<SlotsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SlotsBloc>().add(const LoadSlots());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlotsBloc, SlotsState>(
      builder: (context, state) {
        return Column(
          children: [
            // фильтры
            SlotFilters(
              selectedTrackType: state.filterTrackType,
              onlyAvailable: state.filterOnlyAvailable,
              onApply: ({trackType, onlyAvailable, dateFrom, dateTo}) {
                context.read<SlotsBloc>().add(UpdateSlotsFilter(
                      trackType: trackType,
                      onlyAvailable: onlyAvailable,
                      dateFrom: dateFrom,
                      dateTo: dateTo,
                    ));
              },
            ),
            const Divider(height: 1),
            // контент
            Expanded(
              child: _buildContent(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(SlotsState state) {
    if (state.isLoading && state.slots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.slots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(state.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<SlotsBloc>().add(const LoadSlots()),
              child: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (state.slots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Нет доступных заездов',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    // группируем по дням
    final grouped = <String, List<SlotModel>>{};
    for (final slot in state.slots) {
      final dayKey =
          '${slot.startAt.year}-${slot.startAt.month}-${slot.startAt.day}';
      grouped.putIfAbsent(dayKey, () => []).add(slot);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<SlotsBloc>().add(const LoadSlots());
      },
      child: ListView.builder(
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final day = grouped.keys.elementAt(index);
          final daySlots = grouped[day]!;
          final date = daySlots.first.startAt.toLocal();
          final weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Text(
                  '${date.day}.${date.month} — ${weekDays[date.weekday - 1]}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              ...daySlots.map((slot) => SlotCard(
                    slot: slot,
                    onBook: () {
                      Navigator.of(context).pushNamed(
                        '/booking',
                        arguments: slot,
                      );
                    },
                  )),
            ],
          );
        },
      ),
    );
  }
}
