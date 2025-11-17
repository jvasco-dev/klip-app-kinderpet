import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomSpaCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Map<String, int> appointmentsByDay;
  final Function(DateTime) onDaySelected;

  const CustomSpaCalendar({
    super.key,
    required this.selectedDate,
    required this.appointmentsByDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBeigeAccent, // Fondo suave y cálido
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 730)),
        focusedDay: selectedDate,
        selectedDayPredicate: (day) => isSameDay(selectedDate, day),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.monday,

        // HEADER
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            color: AppColors.brownText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left,
            color: AppColors.dogOrange,
            size: 28,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: AppColors.dogOrange,
            size: 28,
          ),
          headerPadding: const EdgeInsets.symmetric(vertical: 16),
        ),

        // DÍAS DE LA SEMANA (Lun, Mar...)
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: const TextStyle(
            color: AppColors.warmBrown,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          weekendStyle: const TextStyle(
            color: AppColors.goldenTan,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),

        // ESTILO GENERAL DEL CALENDARIO
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: const TextStyle(
            color: AppColors.hardText,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
          weekendTextStyle: const TextStyle(
            color: AppColors.goldenTan,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),

          // Día actual
          todayDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: AppColors.dogOrange, width: 2.5),
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: AppColors.dogOrange,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),

          // Día seleccionado
          selectedDecoration: const BoxDecoration(
            color: AppColors.dogOrange,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        // BADGE DE CITAS (número de citas por día)
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final key = "${date.year}-${date.month}-${date.day}";
            final count = appointmentsByDay[key] ?? 0;
            if (count == 0) return null;

            return Positioned(
              bottom: 6,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: count >= 5
                      ? AppColors
                            .softAlert // Rojo si está lleno
                      : AppColors.dogOrange, // Naranja normal
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            );
          },

          // Día seleccionado (con animación)
          selectedBuilder: (context, date, _) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.dogOrange,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            );
          },

          // Día actual
          todayBuilder: (context, date, _) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.dogOrange, width: 2.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: const TextStyle(
                    color: AppColors.dogOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            );
          },
        ),

        onDaySelected: (selectedDay, focusedDay) {
          onDaySelected(selectedDay);
        },
      ),
    );
  }
}
