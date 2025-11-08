import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/dashboard/presentation/bloc/daycare_event_bloc.dart';
import 'package:kinder_pet/features/dashboard/presentation/widgets/qr_scanner_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateDaycareEventButton extends StatefulWidget {
  const CreateDaycareEventButton({super.key});

  @override
  State<CreateDaycareEventButton> createState() =>
      _CreateDaycareEventButtonState();
}

class _CreateDaycareEventButtonState extends State<CreateDaycareEventButton> {
  bool _isPressed = false;
  bool _isCreatingEvent = false;

  Future<void> _startQRScanner(BuildContext context) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
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
      // ✅ Se garantiza que el valor es un JSON tipo Map
      final decoded = jsonDecode(scannedValue);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('QR content is not a valid JSON map');
      }
      _showConfirmDialog(context, decoded);
    } catch (e) {
      debugPrint('❌ Error decoding QR JSON: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid QR format')));
    }
  }

  void _showConfirmDialog(BuildContext context, Map<String, dynamic> data) {
    final daycareBloc = context.read<DaycareEventBloc>();

    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: daycareBloc,
        child: _ConfirmDialog(
          data: data,
          onConfirm: () {
            setState(() => _isCreatingEvent = true);
          },
        ),
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
            foregroundColor: Colors.white, // ✅ texto blanco visible
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
            context.read<DaycareEventBloc>().add(CreateDaycareEvent(petId));
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
