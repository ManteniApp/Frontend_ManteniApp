import 'package:flutter/material.dart';

class ChangePasswordSheet extends StatefulWidget {
  final Function(String newPassword) onPasswordChanged;

  const ChangePasswordSheet({Key? key, required this.onPasswordChanged})
      : super(key: key);

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;

  String? _message; // Mensaje que se muestra dentro del modal
  Color _messageColor = Colors.red;

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void _updatePassword() async {
    final newPassword = newPasswordController.text.trim();

    if (!_isValidPassword(newPassword)) {
      setState(() {
        _message = 'La nueva contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un símbolo.';
        _messageColor = Colors.red;
      });
      return;
    }

    // Mostrar mensaje de éxito dentro del modal antes de cerrar
    setState(() {
      _message = 'Contraseña actualizada correctamente.';
      _messageColor = Colors.green;
    });

    // Esperar un momento para que el usuario vea el mensaje
    await Future.delayed(const Duration(milliseconds: 700));

    // Llamar al callback del padre para actualizar la contraseña y cerrar
    widget.onPasswordChanged(newPassword);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cambiar \n Contraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Campos de texto
            _buildPasswordField(
              controller: currentPasswordController,
              hint: 'Contraseña actual',
              obscure: _obscureOld,
              toggle: () => setState(() => _obscureOld = !_obscureOld),
            ),
            const SizedBox(height: 15),
            _buildPasswordField(
              controller: newPasswordController,
              hint: 'Nueva contraseña',
              obscure: _obscureNew,
              toggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 12),

            // Mensaje (error o éxito) dentro del modal
            if (_message != null) ...[
              Text(
                _message!,
                style: TextStyle(color: _messageColor),
              ),
              const SizedBox(height: 12),
            ],

            // Botón de confirmar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007AFF),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
