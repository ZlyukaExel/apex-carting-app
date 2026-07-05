import 'package:flutter/material.dart';

class SlotFilters extends StatefulWidget {
  final String? selectedTrackType;
  final bool? onlyAvailable;
  final void Function({String? trackType, bool? onlyAvailable, DateTime? dateFrom, DateTime? dateTo}) onApply;

  const SlotFilters({
    super.key,
    this.selectedTrackType,
    this.onlyAvailable,
    required this.onApply,
  });

  @override
  State<SlotFilters> createState() => _SlotFiltersState();
}

class _SlotFiltersState extends State<SlotFilters> {
  String? _trackType;
  bool? _onlyAvailable;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    _trackType = widget.selectedTrackType;
    _onlyAvailable = widget.onlyAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // фильтр по дате
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _dateChip('Сегодня', 0),
                const SizedBox(width: 8),
                _dateChip('Неделя', 7),
                const SizedBox(width: 8),
                _dateChip('Выходные', null, isWeekend: true),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: _pickCustomRange,
                  tooltip: 'Свой диапазон',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // фильтр по типу трассы
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip(
                  label: 'Все трассы',
                  selected: _trackType == null,
                  onSelected: (_) => setState(() => _trackType = null),
                ),
                const SizedBox(width: 8),
                _filterChip(
                  label: 'Новичковая',
                  selected: _trackType == 'novice',
                  onSelected: (_) => setState(() => _trackType = 'novice'),
                ),
                const SizedBox(width: 8),
                _filterChip(
                  label: 'Спортивная',
                  selected: _trackType == 'experienced',
                  onSelected: (_) => setState(() => _trackType = 'experienced'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // только свободные
          Row(
            children: [
              FilterChip(
                label: const Text('Только свободные'),
                selected: _onlyAvailable == true,
                onSelected: (v) => setState(() => _onlyAvailable = v ? true : null),
              ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () {
                  widget.onApply(
                    trackType: _trackType,
                    onlyAvailable: _onlyAvailable,
                    dateFrom: _dateFrom,
                    dateTo: _dateTo,
                  );
                },
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Применить'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateChip(String label, int? days, {bool isWeekend = false}) {
    final now = DateTime.now();
    final DateTime? from;
    final DateTime? to;

    if (isWeekend) {
      final nextSaturday = now.weekday > 6
          ? now.add(Duration(days: 7 - now.weekday + 6))
          : now.add(Duration(days: DateTime.saturday - now.weekday));
      from = DateTime(nextSaturday.year, nextSaturday.month, nextSaturday.day);
      to = DateTime(nextSaturday.year, nextSaturday.month, nextSaturday.day + 1);
    } else if (days != null) {
      from = DateTime(now.year, now.month, now.day);
      to = from.add(Duration(days: days));
    } else {
      return const SizedBox.shrink();
    }

    final isSelected = _dateFrom == from && _dateTo == to;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (v) {
        setState(() {
          _dateFrom = v ? from : null;
          _dateTo = v ? to : null;
        });
      },
    );
  }

  Future<void> _pickCustomRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        _dateFrom = picked.start;
        _dateTo = picked.end;
      });
    }
  }

  Widget _filterChip({
    required String label,
    required bool selected,
    required void Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
    );
  }
}
