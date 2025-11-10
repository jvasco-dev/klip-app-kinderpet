import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';

class CommonDaycareEventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback? onTap;

  const CommonDaycareEventCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
            title,
            style: const TextStyle(
              color: AppColors.brownText,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle, // 'Check-in: $checkInTime',
            style: const TextStyle(color: AppColors.brownText),
          ),
          trailing: const Icon(Icons.pets, color: AppColors.dogOrange),
        ),
      ),
    );
  }
}