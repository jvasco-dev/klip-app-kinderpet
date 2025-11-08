import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/features/dashboard/presentation/bloc/daycare_event_bloc.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String checkInTime;
  final String imagePath;
  final String eventId;
  final VoidCallback? onFinish;

  const PetCard({
    super.key,
    required this.name,
    required this.checkInTime,
    required this.imagePath,
    required this.eventId,
    this.onFinish,
  });

  void _showAnimatedEndEventDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Finish daycare',
      barrierColor: Colors.black54, // fondo semitransparente
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, _) {
        final curvedValue = Curves.easeOutBack.transform(animation.value) - 1.0;

        return Transform.scale(
          scale: 1 + curvedValue * 0.05,
          child: Opacity(
            opacity: animation.value,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: AppColors.warmBeige,
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Finish Daycare Event',
                      style: TextStyle(
                        color: AppColors.brownText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Do you want to end the daycare for $name?',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.brownText,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Cancel button
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.brownText,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),

                        // Confirm button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (onFinish != null) {
                              onFinish!();
                            } else {
                              context.read<DaycareEventBloc>().add(
                                EndDaycareEvent(eventId),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Daycare for $name has ended 🐶',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dogOrange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'End',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAnimatedEndEventDialog(context),
      child: Card(
        color: AppColors.lightBeigeAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 28,
          ),
          title: Text(
            name,
            style: const TextStyle(
              color: AppColors.brownText,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            'Check-in: $checkInTime',
            style: const TextStyle(color: AppColors.brownText),
          ),
          trailing: const Icon(Icons.pets, color: AppColors.dogOrange),
        ),
      ),
    );
  }
}
