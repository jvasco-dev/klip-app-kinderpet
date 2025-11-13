import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kinder_pet/features/spa-appointment/cubit/spa_appointment_cubit.dart';
import 'package:kinder_pet/features/spa-appointment/presentation/pages/spa_day_appointments_screen.dart';

class SpaAppointmentsCalendarView extends StatefulWidget {
  const SpaAppointmentsCalendarView({super.key});

  @override
  State<SpaAppointmentsCalendarView> createState() =>
      _SpaAppointmentsCalendarViewState();
}

class _SpaAppointmentsCalendarViewState
    extends State<SpaAppointmentsCalendarView> {
  DateTime _focused = DateTime.now();

  List<DateTime> _daysInMonth(DateTime base) {
    final first = DateTime(base.year, base.month, 1);
    final last = DateTime(base.year, base.month + 1, 0);
    final leading = first.weekday - 1;
    final total = last.day + leading;
    return List.generate(
      total,
      (i) => first.subtract(Duration(days: leading - i)),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<SpaAppointmentCubit>().loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final monthName = DateFormat.MMMM('es_CO').format(_focused);
    final days = _daysInMonth(_focused);

    return Column(
      children: [
        // Header del mes
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavButton(
                icon: Icons.chevron_left,
                onPressed: () => setState(() {
                  _focused = DateTime(_focused.year, _focused.month - 1, 1);
                }),
              ),
              Text(
                '${monthName[0].toUpperCase()}${monthName.substring(1)} ${_focused.year}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              _NavButton(
                icon: Icons.chevron_right,
                onPressed: () => setState(() {
                  _focused = DateTime(_focused.year, _focused.month + 1, 1);
                }),
              ),
            ],
          ),
        ),

        // Días de la semana
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _WeekDayLabel('L'),
              _WeekDayLabel('M'),
              _WeekDayLabel('X'),
              _WeekDayLabel('J'),
              _WeekDayLabel('V'),
              _WeekDayLabel('S'),
              _WeekDayLabel('D'),
            ],
          ),
        ),

        // Calendario
        Expanded(
          child: BlocBuilder<SpaAppointmentCubit, SpaAppointmentState>(
            builder: (context, state) {
              final appointments = state is SpaAppointmentLoaded
                  ? state.appointments
                  : <dynamic>[];
              final Map<String, int> counts = {};
              for (final a in appointments) {
                final key = a.date.toIso8601String().split('T').first;
                counts[key] = (counts[key] ?? 0) + 1;
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: days.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (ctx, idx) {
                  final d = days[idx];
                  final isCurrentMonth = d.month == _focused.month;
                  final key = d.toIso8601String().split('T').first;
                  final count = counts[key] ?? 0;
                  final available = count < 3;
                  final isToday = DateUtils.isSameDay(d, DateTime.now());

                  final backgroundColor = isToday
                      ? colorScheme.primary
                      : isCurrentMonth
                      ? colorScheme.surface
                      : colorScheme.surfaceVariant;

                  final borderColor = available
                      ? colorScheme.primaryContainer
                      : colorScheme.errorContainer;

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isCurrentMonth
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<SpaAppointmentCubit>(),
                                  child: SpaDayAppointmentsScreen(date: d),
                                ),
                              ),
                            );
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          if (isToday)
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                        ],
                        border: Border.all(color: borderColor, width: 1.4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                '${d.day}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isToday
                                      ? colorScheme.onPrimary
                                      : isCurrentMonth
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            if (!available)
                              Text(
                                'FULL',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isToday
                                      ? colorScheme.onPrimary
                                      : colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else
                              Text(
                                '$count / 3',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isToday
                                      ? colorScheme.onPrimary
                                      : colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// Widgets auxiliares reutilizables
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _NavButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(icon, color: colorScheme.primary),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _WeekDayLabel extends StatelessWidget {
  final String text;
  const _WeekDayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
