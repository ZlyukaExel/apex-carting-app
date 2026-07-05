import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bloc/slots_state.dart';

class SlotCard extends StatelessWidget {
  final SlotModel slot;
  final VoidCallback? onBook;

  const SlotCard({
    super.key,
    required this.slot,
    this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM, HH:mm');
    final isAvailable = slot.isAvailable;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Время, статус, тип трассы
            Row(
              children: [
                Icon(Icons.schedule, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(slot.startAt.toLocal()),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                _buildTrackTypeBadge(slot.trackType),
                const Spacer(),
                if (!isAvailable)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Нет мест',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Название трассы и маршал
            Text(
              slot.trackName,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              slot.trackDescription,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 8),
            // Маршал
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Маршал: ${slot.marshalName}',
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            const SizedBox(height: 4),
            // Свободные места
            Row(
              children: [
                const Icon(Icons.directions_car, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Свободно: ${slot.freeKarts} / ${slot.totalKarts} картов',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.shopping_bag, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Экипировка: ${slot.freeRentalEquipment}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Цена и кнопка
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${slot.price} ₽ / место',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                    ),
                    Text(
                      'Аренда экип.: ${slot.rentalPrice} ₽',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: isAvailable ? onBook : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 40),
                  ),
                  child: Text(isAvailable ? 'Забронировать' : 'Нет мест'),
                ),
              ],
            ),
            // Место встречи
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    slot.meetingPoint,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackTypeBadge(String type) {
    final isNovice = type == 'novice';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isNovice ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isNovice ? 'Новичок' : 'Спорт',
        style: TextStyle(
          color: isNovice ? Colors.green[700] : Colors.orange[700],
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
