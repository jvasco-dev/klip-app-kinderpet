import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/dashboard/presentation/bloc/daycare_event_bloc.dart';
import 'package:kinder_pet/features/dashboard/presentation/pages/qr_scanner_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateDaycareEventButton extends StatefulWidget {
  const CreateDaycareEventButton({super.key});

  @override
  State<CreateDaycareEventButton> createState() =>
      _CreateDaycareEventButtonState();
}

class _CreateDaycareEventButtonState extends State<CreateDaycareEventButton> {
  bool _isCreatingEvent = false;

  Future<void> _startQRScanner(BuildContext context) async {
    // Log para validar suposición: verificar permisos de cámara
    print('DEBUG: Solicitando permiso de cámara');

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      // Log para validar suposición: verificar si el contexto sigue montado
      print(
        'DEBUG: Permiso de cámara denegado, verificando si el contexto está montado',
      );

      if (!context.mounted) {
        print('DEBUG: Contexto no montado, evitando ScaffoldMessenger');
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required')),
      );
      return;
    }

    final scannedValue = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    if (scannedValue == null || !context.mounted) return;

    try {
      final decoded = jsonDecode(scannedValue);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('QR content is not a valid JSON map');
      }
      if (context.mounted) {
        _showConfirmDialog(context, decoded);
      }
    } catch (e) {
      debugPrint('❌ Error decoding QR JSON: $e');

      // Log para validar suposición: verificar si el contexto sigue montado después del error
      print(
        'DEBUG: Error al decodificar QR, verificando si el contexto está montado',
      );

      if (!context.mounted) {
        print('DEBUG: Contexto no montado, evitando ScaffoldMessenger');
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid QR format')));
    }
  }

  void _showConfirmDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        data: data,
        onConfirm: () {
          setState(() => _isCreatingEvent = true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DaycareEventBloc, DaycareEventState>(
      listener: (context, state) {
        if (_isCreatingEvent && state is DaycareEventSuccess) {
          setState(() => _isCreatingEvent = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Daycare event created successfully!'),
            ),
          );
          context.read<DaycareEventBloc>().add(FetchDaycareEvents());
        }

        if (_isCreatingEvent && state is DaycareEventError) {
          setState(() => _isCreatingEvent = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
        }
      },
      child: FloatingActionButton(
        backgroundColor: AppColors.dogOrange,
        onPressed: () async {
          HapticFeedback.lightImpact();
          await _startQRScanner(context);
        },
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onConfirm;

  const _ConfirmDialog({required this.data, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final petId = data['id'];
    final petName = data['name'] ?? 'Unknown';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Confirm Daycare Event',
        style: TextStyle(
          color: AppColors.brownText,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Do you want to create a daycare event for $petName?',
        style: const TextStyle(color: AppColors.brownText),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.brownText),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.dogOrange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();

            /// 👉 Aquí ya ES SEGURO usar el Bloc,
            /// porque el diálogo está bajo el provider correcto.
            context.read<DaycareEventBloc>().add(CreateDaycareEvent(petId));
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
