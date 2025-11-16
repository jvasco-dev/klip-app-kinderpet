import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';

class CustomSpaCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Map<String, int> appointmentsByDay;
  final ValueChanged<DateTime> onDaySelected;

  const CustomSpaCalendar({
    super.key,
    required this.selectedDate,
    required this.appointmentsByDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateTime(selectedDate.year, selectedDate.month);
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);

    // Primer día de la semana ajustado para que Lunes=0
    final firstWeekday = (firstDayOfMonth.weekday + 6) % 7;

    final daysInMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    ).day;

    // total celdas: días previos + días del mes + días para completar la última fila
    final baseCells = firstWeekday + daysInMonth;
    final extraToFill = (baseCells % 7) == 0 ? 0 : (7 - (baseCells % 7));
    final totalCells = baseCells + extraToFill;

    // Cálculo de proporción de celda para minimizar overflow
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalOuterPadding = 24.0;
    const gridSpacing = 12.0;
    final availableWidth = screenWidth - horizontalOuterPadding;
    final cellWidth = (availableWidth - (7 - 1) * gridSpacing) / 7;
    final desiredCellHeight = cellWidth * 0.95;
    double childAspectRatio = cellWidth / desiredCellHeight;
    // clamp para evitar valores extremos en pantallas pequeñas/grandes
    if (childAspectRatio.isInfinite || childAspectRatio.isNaN) {
      childAspectRatio = 1.0;
    }
    childAspectRatio = childAspectRatio.clamp(0.7, 1.2);

    return Column(
      children: [
        const SizedBox(height: 12),
        // Nombre del mes centrado (opcional, si ya tienes otro header lo puedes eliminar)
        Text(
          '${_monthName(selectedDate.month)} ${selectedDate.year}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.brownText,
          ),
        ),
        const SizedBox(height: 10),

        // Días de la semana (L M X J V S D)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: const [
              Expanded(child: Center(child: _DayHeader('L'))),
              Expanded(child: Center(child: _DayHeader('M'))),
              Expanded(child: Center(child: _DayHeader('X'))),
              Expanded(child: Center(child: _DayHeader('J'))),
              Expanded(child: Center(child: _DayHeader('V'))),
              Expanded(child: Center(child: _DayHeader('S'))),
              Expanded(child: Center(child: _DayHeader('D'))),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Grid de días
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            itemCount: totalCells,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              // celdas previas al mes (mes anterior)
              if (index < firstWeekday) {
                final prevDate = firstDayOfMonth.subtract(
                  Duration(days: firstWeekday - index),
                );
                return _CalendarDay(
                  date: prevDate,
                  isCurrentMonth: false,
                  count: 0,
                  selected: _isSameDay(prevDate, selectedDate),
                  onTap: null,
                );
              }

              final day = index - firstWeekday + 1;

              // si el índice cae en la zona de extra (mes siguiente) devolvemos celdas del siguiente mes
              if (day > daysInMonth) {
                final nextDay = day - daysInMonth;
                final nextDate = DateTime(
                  currentMonth.year,
                  currentMonth.month + 1,
                  nextDay,
                );
                return _CalendarDay(
                  date: nextDate,
                  isCurrentMonth: false,
                  count: 0,
                  selected: _isSameDay(nextDate, selectedDate),
                  onTap: null,
                );
              }

              // día dentro del mes actual
              final date = DateTime(currentMonth.year, currentMonth.month, day);
              final key = "${date.year}-${date.month}-${date.day}";
              final count = appointmentsByDay[key] ?? 0;

              return _CalendarDay(
                date: date,
                isCurrentMonth: true,
                count: count,
                selected: _isSameDay(date, selectedDate),
                onTap: () => onDaySelected(date),
              );
            },
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthName(int month) {
    const names = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return names[month];
  }
}

/// Header pequeño para cada columna
class _DayHeader extends StatelessWidget {
  final String label;
  const _DayHeader(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.brownText,
      ),
    );
  }
}

/// Celda del calendario — usa LayoutBuilder + FittedBox para evitar overflow
class _CalendarDay extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool selected;
  final int count;
  final VoidCallback? onTap;

  const _CalendarDay({
    super.key,
    required this.date,
    this.isCurrentMonth = true,
    this.selected = false,
    this.count = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayStr = date.day.toString();
    final countStr = "$count / 3";

    // Colores base (usa tu AppColors)
    Color bgColor = Colors.white;
    Color borderColor = AppColors.dogOrange;
    Color textColor = Colors.black;

    if (!isCurrentMonth) {
      bgColor = AppColors.dogOrange.withOpacity(0.12);
      borderColor = Colors.transparent;
      textColor = Colors.black45;
    }

    if (selected) {
      bgColor = AppColors.dogOrange;
      textColor = Colors.white;
      borderColor = AppColors.dogOrange;
    }

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // tamaños relativos para que todo quepa sin overflow
          final maxH = constraints.maxHeight;
          final dayBoxHeight = maxH * 0.55; // espacio para número
          final countBoxHeight = maxH * 0.25; // espacio para contador

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
                width: selected ? 2.0 : 1.2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: dayBoxHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      dayStr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: countBoxHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      countStr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white70 : AppColors.dogOrange,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
