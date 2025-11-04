import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/shared/widgets/index.dart';
import 'package:kinder_pet/features/dashboard/presentation/screens/PetCard.dart';

class DaycareDashboardScreen extends StatelessWidget {
  const DaycareDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      drawer: const CommonDrawer(), // Menú lateral
      appBar: AppBar(
        backgroundColor: AppColors.warmBeige,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.brownText),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                // Navegar a configuración de perfil
              },
              child: const CircleAvatar(
                backgroundColor: AppColors.lightBeigeAccent,
                radius: 18,
                child: Icon(Icons.person, color: AppColors.brownText),
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Daycare Pets',
          style: TextStyle(
            color: AppColors.brownText,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Pets active daycare',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.hardText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: 5, // Simulado
                separatorBuilder: (_, _)=> const SizedBox(height: 12,),
                itemBuilder: (context, index) {
                  // En el futuro aquí vendrán los datos dinámicos del backend
                  return const PetCard(
                    name: 'Dobby',
                    checkInTime: '08:30 AM',
                    imagePath: 'assets/pets/luna.png',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
