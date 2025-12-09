import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/profile_image_service.dart';

class ImagePickerSheet extends StatelessWidget {
  final Function() onImageUpdated;

  const ImagePickerSheet({super.key, required this.onImageUpdated});

  Future<void> _handleImageSelection(Future<String?> imageFuture, BuildContext context) async {
    try {
      final imagePath = await imageFuture;
      if (imagePath != null) {
        await ProfileImageService.saveProfileImage(imagePath);
        onImageUpdated();
        Navigator.pop(context);
        
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Foto de perfil actualizada'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> _handleRemoveImage(BuildContext context) async {
    try {
      await ProfileImageService.removeProfileImage();
      onImageUpdated();
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text('Foto de perfil eliminada'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.photo_camera, color: Color(0xFF1E88E5), size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Cambiar foto de perfil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Opciones
            _buildOption(
              context,
              icon: Icons.photo_library,
              title: 'Elegir de la galería',
              subtitle: 'Selecciona una imagen de tu galería',
              color: const Color(0xFF1E88E5),
              onTap: () => _handleImageSelection(
                ProfileImageService.pickImageFromGallery(), 
                context
              ),
            ),
            
            _buildOption(
              context,
              icon: Icons.camera_alt,
              title: 'Tomar una foto',
              subtitle: 'Usa la cámara para tomar una foto',
              color: Colors.green,
              onTap: () => _handleImageSelection(
                ProfileImageService.takePhotoWithCamera(), 
                context
              ),
            ),
            
            // Solo mostrar opción de eliminar si hay imagen personalizada
            FutureBuilder<bool>(
              future: ProfileImageService.hasCustomImage(),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return _buildOption(
                    context,
                    icon: Icons.delete,
                    title: 'Eliminar foto actual',
                    subtitle: 'Volver a la imagen por defecto',
                    color: Colors.red,
                    onTap: () => _handleRemoveImage(context),
                  );
                }
                return const SizedBox();
              },
            ),
            
            // Botón cancelar
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: BorderSide(color: Colors.grey[300]!),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.chevron_right, color: color, size: 18),
      ),
      onTap: onTap,
    );
  }
}