import 'package:flutter/material.dart';
import 'package:kinder_pet/core/config/theme.dart';
import 'package:kinder_pet/shared/widgets/index.dart';
import 'package:kinder_pet/features/dashboard/presentation/screens/PetCard.dart';

class DaycareDashboardScreen extends StatelessWidget {
  const DaycareDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // backgroundImage: AssetImage('assets/user_avatar.png'),
              ),
            ),
          ),
        ],
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(top: 25, bottom: 10),
          child: const Text(
            'Daycare Pets',
            style: TextStyle(
              color: AppColors.brownText,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Simulado
        itemBuilder: (context, index) {
          return const PetCard(
            name: 'Luna',
            checkInTime: '08:30 AM',
            imagePath: 'assets/pets/luna.png',
          );
        },
      ),
    );
  }
}
