// perfil_user_placeholder.dart
import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/profile_service.dart';
import 'package:frontend_manteniapp/features/perfil_usuario/presentation/pages/perfil_user.dart';

class PerfilUserPlaceholder extends StatelessWidget {
  const PerfilUserPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: ProfileService.getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'No se pudo cargar el perfil',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Usuario no encontrado',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Volver'),
                  ),
                ],
              ),
            ),
          );
        }

        final userId = snapshot.data!;
        return PerfilUser(userId: userId);
      },
    );
  }
}