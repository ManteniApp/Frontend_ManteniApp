import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/personal_info_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/change_password_sheet.dart';
import '../widgets/settings_tile.dart';
import '../widgets/terminos_condiciones.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/image_picker_sheet.dart';

class PerfilUser extends StatefulWidget {
  final String? userId;
  const PerfilUser({super.key, this.userId});

  @override
  State<PerfilUser> createState() => _PerfilUserState();
}

class _PerfilUserState extends State<PerfilUser> {
  bool isEditing = false;
  bool isLoading = true;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final ProfileService _profileService = ProfileService();
  String? errorMessage;
  String? currentUserId;

  // Key para forzar actualización del ProfileAvatar
  final GlobalKey<ProfileAvatarState> _profileAvatarKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('userId');

    if (widget.userId != null && int.tryParse(widget.userId!) != null) {
      currentUserId = widget.userId!;
    } else if (storedId != null && int.tryParse(storedId) != null) {
      currentUserId = storedId;
    } else {
      setState(() {
        isLoading = false;
        errorMessage =
            'No se encontró información del usuario. Inicia sesión nuevamente.';
      });
      return;
    }

    await _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _profileService.getUserProfile();

      setState(() {
        nameController.text = user.name;
        phoneController.text = user.phone;
        emailController.text = user.email;
        isLoading = false;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'userName',
        nameController.text,
      ); // 👈 guardamos el nombre
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar perfil: $e';
      });
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ImagePickerSheet(
        onImageUpdated: () {
          // Forzar actualización del avatar
          _profileAvatarKey.currentState?.refreshImage();
          setState(() {}); // Actualizar UI completa
        },
      ),
    );
  }

  // ... (mantén el resto de tus métodos _saveChanges, _logout, _deleteAccount, _changePassword igual)

  Future<void> _saveChanges() async {
    try {
      final success = await _profileService.updateBasicProfile(
        nameController.text,
        phoneController.text,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Perfil actualizado correctamente'),
          ),
        );
        setState(() => isEditing = false);
      } else {
        throw Exception('No se pudo actualizar el perfil');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('userToken');

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text(
          '¿Seguro que deseas eliminar tu cuenta? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _profileService.deleteAccount();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
      }
    }
  }

  Future<void> _changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final success = await _profileService.changePassword(
        currentPassword,
        newPassword,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Contraseña cambiada correctamente'),
          ),
        );
      } else {
        throw Exception('No se pudo cambiar la contraseña');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
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
                          onCancelPressed: () =>
                              setState(() => isEditing = false),
                          onSavePressed: _saveChanges,
                        ),
                        const SizedBox(height: 5),
                        SettingsTile(
                          onTermsPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TerminosCondiciones(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: 'Cambiar contraseña',
                          backgroundColor: Colors.grey[200]!,
                          textColor: Colors.black,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => ChangePasswordSheet(
                                onPasswordChanged: _changePassword,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomButton(
                          text: 'Cerrar sesión',
                          backgroundColor: const Color(0xFF1E88E5),
                          textColor: Colors.white,
                          onPressed: _logout,
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: 'Eliminar cuenta',
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          onPressed: _deleteAccount,
                        ),
                      ],
                    ),
                  ),
                  // ProfileAvatar con key para controlarlo
                  Positioned(
                    top: 0,
                    child: ProfileAvatar(
                      key: _profileAvatarKey,
                      size: 120,
                      editable: true,
                      onTap: _showImagePicker,
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
