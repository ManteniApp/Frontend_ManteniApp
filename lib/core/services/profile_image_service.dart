import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageService {
  static const String _profileImageKey = 'profile_image';
  static const String _defaultImagePath = 'assets/img/default_avatar.png';

  // Guardar la imagen (ya sea URL o path local)
  static Future<void> saveProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, imagePath);
  }

  // Obtener la imagen guardada
  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImageKey);
  }

  // Eliminar la imagen (restaurar por defecto)
  static Future<void> removeProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileImageKey);
  }

  // Verificar si hay una imagen personalizada
  static Future<bool> hasCustomImage() async {
    final image = await getProfileImage();
    return image != null && image.isNotEmpty && image != _defaultImagePath;
  }

  // Seleccionar imagen de la galería
  static Future<String?> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );
      
      if (image != null) {
        return image.path;
      }
      return null;
    } catch (e) {
      print('Error al seleccionar imagen: $e');
      return null;
    }
  }

  // Tomar foto con cámara
  static Future<String?> takePhotoWithCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );
      
      if (image != null) {
        return image.path;
      }
      return null;
    } catch (e) {
      print('Error al tomar foto: $e');
      return null;
    }
  }
}