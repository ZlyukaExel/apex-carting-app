# Баг 3: Debug сборка на Android — fit overflowed by 23 pixels в разделе фильтров

## Описание
На главном экране "Апекс — заезды" в Debug сборке на Android появляется ошибка `Bottom overflowed by 23 pixels` (или `fit overflowed by 23 pixels`) в разделе с фильтрами "сегодня", "неделя", "выходные" и т.д.

## Причина
В `lib/features/slots/widgets/slot_filters.dart` три группы фильтров расположены в `Row`-виджетах без обработки overflow:

1. **Строка дат:** `FilterChip("Сегодня")` + `FilterChip("Неделя")` + `FilterChip("Выходные")` + `Spacer()` + `IconButton(calendar)`
2. **Строка типов трасс:** `FilterChip("Все трассы")` + `FilterChip("Новичковая")` + `FilterChip("Спортивная")`
3. **Строка доступности:** `FilterChip("Только свободные")` + `Spacer()` + `FilledButton("Применить")`

На窄ких экранах (Android-устройства с шириной ~360dp) суммарная ширина `FilterChip` + отступов превышает доступную ширину. Flutter в Debug-режиме выбрасывает `OverflowError`, так как `Row` по умолчанию не переносит элементы.

## Решение
Заменить `Row` на `Wrap` для строк фильтров. `Wrap` автоматически переносит чипы на следующую строку, если они не помещаются по ширине, что корректно работает на любых размерах экрана.

Файл: `lib/features/slots/widgets/slot_filters.dart`
