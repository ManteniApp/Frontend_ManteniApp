import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/settings_tile.dart';
import '../widgets/custom_button.dart';
import '../widgets/change_password_sheet.dart';
import '../widgets/terminos_condiciones.dart';

class PerfilUser extends StatefulWidget {
  const PerfilUser({super.key});

  @override
  State<PerfilUser> createState() => _PerfilUserState();
}

class _PerfilUserState extends State<PerfilUser> {
  bool isEditing = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController =
      TextEditingController(text: 'Laura');
  final TextEditingController phoneController =
      TextEditingController(text: '321 637 1722');
  final TextEditingController emailController =
      TextEditingController(text: 'laura123@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'Laura123@');

  String? emailError;
  String? phoneError;

  // Validaciones
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }

  // Selección de imagen
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: Color(0xFF1E88E5)),
              title: const Text('Elegir desde galería'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF1E88E5)),
              title: const Text('Tomar una foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text('Cancelar'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    setState(() {
      emailError = _isValidEmail(email) ? null : 'Correo inválido';
      phoneError = _isValidPhone(phone) ? null : 'Teléfono inválido (10 dígitos)';
    });

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Ingresa un correo válido.'), 
          closeIconColor: Colors.red),
      );
      return;
    }

    if (!_isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              ' La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un símbolo.'), 
          closeIconColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isValidPhone(phone)){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Ingresa un teléfono válido con 10 digitos.'), 
          closeIconColor: Colors.red),
      );
      return;
    }

    setState(() => isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(' Cambios guardados correctamente.')),
    );
  }

  // Mostrar ventana flotante para cambiar contraseña
  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangePasswordSheet(
        onPasswordChanged: (newPassword) {
          // Actualiza el controlador de contraseña sin mostrar SnackBar en la pantalla principal
          setState(() {
            passwordController.text = newPassword;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Cierra teclado
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1E88E5).withOpacity(0.20),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        Text(
                          nameController.text,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        PersonalInfoCard(
                          isEditing: isEditing,
                          nameController: nameController,
                          phoneController: phoneController,
                          emailController: emailController,
                          onEditPressed: () => setState(() => isEditing = true),
                          onCancelPressed: () => setState(() => isEditing = false),
                          onSavePressed: _saveChanges,
                        ),
                        const SizedBox(height: 5),
                        SettingsTile(
                          onTermsPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TerminosCondiciones(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: 'Cambiar contraseña',
                          backgroundColor: Colors.grey[200]!,
                          textColor: Colors.black,
                          onPressed: () => _showChangePasswordSheet(context),
                        ),
                        const SizedBox(height: 15),
                        CustomButton(
                          text: 'Cerrar sesión',
                          backgroundColor: const Color(0xFF1E88E5),
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // Imagen de perfil editable
                  Positioned(
                    top: 0,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1E88E5),
                              width: 4,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const AssetImage('assets/images/lau.jpg') as ImageProvider,
                            radius: 100,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _showImagePickerOptions(context),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF1E88E5),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.camera_alt,
                                  size: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
