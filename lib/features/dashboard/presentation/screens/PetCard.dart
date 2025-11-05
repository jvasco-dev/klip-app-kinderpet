import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';

class PetCard extends StatelessWidget {
  final String name;
  final DateTime checkInTime;
  final String imagePath;

  const PetCard({
    super.key,
    required this.name,
    required this.checkInTime,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.softWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.brownText.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // 🐶 Imagen circular de la mascota
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.lightBeigeAccent,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 16),

          // 🐾 Información textual
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.brownText,
                    fontWeight: FontWeight.bold,
                    // fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ingreso: $checkInTime',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.hardText,
                    // fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // 🕓 Icono decorativo de estado o acción
          const Icon(Icons.pets, color: AppColors.dogOrange, size: 28),
        ],
      ),
    );
  }
}
