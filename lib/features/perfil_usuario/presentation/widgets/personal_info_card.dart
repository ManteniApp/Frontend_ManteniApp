import 'package:flutter/material.dart';

class PersonalInfoCard extends StatelessWidget {
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final VoidCallback onEditPressed;
  final VoidCallback onCancelPressed;
  final VoidCallback onSavePressed;

  const PersonalInfoCard({
    super.key,
    required this.isEditing,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.onEditPressed,
    required this.onCancelPressed,
    required this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Título y botones de edición
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Info Personal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildEditButtons(),
            ],
          ),
          const SizedBox(height: 20),

          // Cada campo dentro de un contenedor con sombra azul
          _buildStyledInfoRow(Icons.person_outline, 'Usuario', nameController),
          const SizedBox(height: 15),
          _buildStyledInfoRow(Icons.phone_outlined, 'Teléfono', phoneController),
          const SizedBox(height: 15),
          _buildStyledInfoRow(Icons.email_outlined, 'Correo', emailController),
        ],
      ),
    );
  }

  // Contenedores con sombra azul para cada fila
  Widget _buildStyledInfoRow(IconData icon, String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF007AFF)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 5),
                isEditing
                    ? TextField(
                        controller: controller,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: UnderlineInputBorder(),
                        ),
                      )
                    : Text(
                        controller.text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Botones de edición
  Widget _buildEditButtons() {
    if (isEditing) {
      return Row(
        children: [
          GestureDetector(
            onTap: onCancelPressed,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF007AFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSavePressed,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF007AFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onEditPressed,
      child: const Icon(Icons.edit, color: Colors.grey),
    );
  }
}
