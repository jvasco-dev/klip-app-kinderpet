import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinder_pet/core/config/theme.dart';

class SpaScreen extends StatefulWidget {
  const SpaScreen({super.key});

  @override
  State<SpaScreen> createState() => _SpaScreenState();
}

class _SpaScreenState extends State<SpaScreen> {
  DateTime _focusedDay = DateTime.now();

  List<DateTime> _generateMonthDays(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);

    // Calcula días del mes anterior que deben mostrarse al inicio
    final leadingDays = firstDayOfMonth.weekday - 1;
    final totalDays = lastDayOfMonth.day + leadingDays;

    return List.generate(totalDays, (index) {
      return firstDayOfMonth.subtract(Duration(days: leadingDays - index));
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthDays = _generateMonthDays(_focusedDay);
    final monthName = DateFormat.MMMM('es_CO').format(_focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          // 🔹 Encabezado con mes y botones de navegación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: AppColors.brownText,
                ),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month - 1,
                      1,
                    );
                  });
                },
              ),
              Text(
                '${monthName[0].toUpperCase()}${monthName.substring(1)} ${_focusedDay.year}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brownText,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: AppColors.brownText,
                ),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month + 1,
                      1,
                    );
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🔹 Días de la semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _DayLabel(label: 'L'),
              _DayLabel(label: 'M'),
              _DayLabel(label: 'X'),
              _DayLabel(label: 'J'),
              _DayLabel(label: 'V'),
              _DayLabel(label: 'S'),
              _DayLabel(label: 'D'),
            ],
          ),

          const SizedBox(height: 8),

          // 🔹 Días del mes
          Expanded(
            child: GridView.builder(
              itemCount: monthDays.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final day = monthDays[index];
                final isCurrentMonth = day.month == _focusedDay.month;
                final isToday = DateUtils.isSameDay(day, DateTime.now());

                return Container(
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.brownText.withOpacity(0.8)
                        : isCurrentMonth
                        ? AppColors.softWhite
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isToday
                          ? Colors.white
                          : isCurrentMonth
                          ? AppColors.brownText
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;

  const _DayLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.brownText,
          ),
        ),
      ),
    );
  }
}
