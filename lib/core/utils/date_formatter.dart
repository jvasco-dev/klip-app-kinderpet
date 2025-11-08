import 'package:intl/intl.dart';

/// Formatea una fecha [date] al formato local de Bogotá, Colombia.
/// Ejemplo: "08/11/2025 04:15 p. m."
String formatDateToColombia(DateTime date) {
  // Convierte a hora local (Bogotá = UTC-5)
  final localDate = date.toUtc().subtract(const Duration(hours: 5));

  // Formato con idioma español y zona horaria de Colombia
  final formatter = DateFormat('dd/MM/yyyy hh:mm a', 'es_CO');

  return formatter.format(localDate);
}
