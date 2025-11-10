import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';

/// Common dialog genérico que puede aceptar cualquier tipo de Bloc.
/// Ejemplo de uso:
/// commonShowDialog<DaycareEventBloc>(...)
Future<void> commonShowDialog<B extends StateStreamableSource<Object?>>({
  required BuildContext context,
  required String title,
  required String description,
  required VoidCallback onConfirm,
  required String textButtonReject,
  required String textButtonAccept,
}) async {
  final blocContext = BlocProvider.of<B>(context);

  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: AppColors.lightBeigeAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.brownText,
          ),
        ),
        content: Text(
          description,
          style: const TextStyle(color: AppColors.brownText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              textButtonReject,
              style: const TextStyle(color: AppColors.softAlert),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dogOrange,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Asegura que el contexto del Bloc esté disponible
              onConfirm();
            },
            child: Text(
              textButtonAccept,
              style: const TextStyle(color: AppColors.lightBeigeAccent),
            ),
          ),
        ],
      );
    },
  );
}
