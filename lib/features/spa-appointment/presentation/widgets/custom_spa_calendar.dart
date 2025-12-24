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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.lightBeigeAccent,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
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

        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: AppColors.brownText,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: AppColors.dogOrange,
            size: 28,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: AppColors.dogOrange,
            size: 28,
          ),
          headerPadding: EdgeInsets.symmetric(vertical: 14),
        ),

        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: AppColors.warmBrown,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          weekendStyle: TextStyle(
            color: AppColors.goldenTan,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),

        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: const TextStyle(
            color: AppColors.hardText,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          weekendTextStyle: const TextStyle(
            color: AppColors.goldenTan,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.dogOrange, width: 2.5),
          ),
          todayTextStyle: const TextStyle(
            color: AppColors.dogOrange,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
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

        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, date, events) {
            final key = "${date.year}-${date.month}-${date.day}";
            final count = appointmentsByDay[key] ?? 0;
            if (count == 0) return null;

            return Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                  maxWidth: 24,
                  maxHeight: 24,
                ),
                decoration: BoxDecoration(
                  color: _getMarkerColor(count),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      _formatAppointmentCount(count),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },

          selectedBuilder: (context, date, _) =>
              _buildDayCircle(date, AppColors.dogOrange, Colors.white),
          todayBuilder: (context, date, _) => _buildDayCircle(
            date,
            Colors.transparent,
            AppColors.dogOrange,
            border: true,
            isToday: true,
          ),
          defaultBuilder: (context, date, _) => _buildDefaultDay(date),
        ),

        onDaySelected: (day, _) => onDaySelected(day),
      ),
    );
  }

  Widget _buildDayCircle(
    DateTime date,
    Color bgColor,
    Color textColor, {
    bool border = false,
    bool isToday = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border
            ? Border.all(color: AppColors.dogOrange, width: isToday ? 3.0 : 2.5)
            : null,
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: AppColors.dogOrange.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            color: textColor,
            fontWeight: isToday ? FontWeight.w800 : FontWeight.bold,
            fontSize: isToday ? 18 : 17,
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultDay(DateTime date) {
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;

    return Container(
      margin: const EdgeInsets.all(6),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            color: isWeekend ? AppColors.goldenTan : AppColors.hardText,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Color _getMarkerColor(int count) {
    if (count >= 10) return AppColors.softAlert;
    if (count >= 5) return Colors.deepOrange;
    return AppColors.dogOrange;
  }

  String _formatAppointmentCount(int count) {
    if (count >= 20) return '20+';
    if (count >= 15) return '15+';
    if (count >= 10) return '10+';
    return count.toString();
  }
}
