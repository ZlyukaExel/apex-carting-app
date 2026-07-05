import 'package:flutter/material.dart';

class EquipmentSelector extends StatelessWidget {
  final int rentalCount;
  final int maxRental;
  final int pricePerItem;
  final ValueChanged<int> onChanged;

  const EquipmentSelector({
    super.key,
    required this.rentalCount,
    required this.maxRental,
    required this.pricePerItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Аренда экипировки',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '$pricePerItem ₽ / комплект. Доступно: $maxRental',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _roundButton(
              icon: Icons.remove,
              onTap: rentalCount > 0 ? () => onChanged(rentalCount - 1) : null,
            ),
            const SizedBox(width: 16),
            Text(
              '$rentalCount',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            _roundButton(
              icon: Icons.add,
              onTap: rentalCount < maxRental
                  ? () => onChanged(rentalCount + 1)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              'комплект(ов)',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, color: onTap == null ? Colors.grey[400] : null),
        ),
      ),
    );
  }
}
