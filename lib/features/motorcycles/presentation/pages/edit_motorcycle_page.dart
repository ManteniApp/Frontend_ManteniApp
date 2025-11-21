import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/datasources/motorcycle_remote_data_source.dart';
import '../../data/models/motorcycle_model.dart';

class EditMotorcyclePage extends StatefulWidget {
  final MotorcycleModel motorcycle;

  const EditMotorcyclePage({super.key, required this.motorcycle});

  @override
  State<EditMotorcyclePage> createState() => _EditMotorcyclePageState();
}

class _EditMotorcyclePageState extends State<EditMotorcyclePage> {
  final _formKey = GlobalKey<FormState>();
  final MotorcycleRemoteDataSourceImpl _dataSource =
      MotorcycleRemoteDataSourceImpl();

  // Controladores
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _kilometrajeController = TextEditingController();

  bool _isSaving = false;
  late MotorcycleModel _motorcycle;

  @override
  void initState() {
    super.initState();
    _motorcycle = widget.motorcycle;
    _loadFormData();
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _placaController.dispose();
    _anoController.dispose();
    _kilometrajeController.dispose();
    super.dispose();
  }

  void _loadFormData() {
    _marcaController.text = _motorcycle.brand;
    _modeloController.text = _motorcycle.model;
    _placaController.text = _motorcycle.licensePlate ?? '';
    _anoController.text = _motorcycle.year.toString();
    _kilometrajeController.text = _motorcycle.mileage.toString();
  }

  Future<void> _updateMotorcycle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Crear modelo actualizado (preservando campos no editables)
      final updatedMotorcycle = MotorcycleModel(
        id: _motorcycle.id,
        brand: _marcaController.text.trim(),
        model: _modeloController.text.trim(),
        imageUrl:
            _motorcycle.imageUrl, // No editable - preservar imagen original
        licensePlate: _placaController.text.trim().isEmpty
            ? null
            : _placaController.text.trim(),
        year: int.parse(_anoController.text.trim()),
        displacement: _motorcycle.displacement, // No editable
        mileage: int.parse(_kilometrajeController.text.trim()),
        createdAt: _motorcycle.createdAt,
        updatedAt: DateTime.now(),
      );

      await _dataSource.updateMotorcycle(updatedMotorcycle);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Motocicleta actualizada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al actualizar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Motocicleta'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Actualizar datos de tu motocicleta',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Marca
                          _buildTextField(
                            label: 'Marca',
                            controller: _marcaController,
                            hint: 'Ej: Yamaha',
                            icon: Icons.branding_watermark,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'La marca es requerida';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Modelo
                          _buildTextField(
                            label: 'Modelo',
                            controller: _modeloController,
                            hint: 'Ej: MT-07',
                            icon: Icons.motorcycle,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El modelo es requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Placa
                          _buildTextField(
                            label: 'Placa (Opcional)',
                            controller: _placaController,
                            hint: 'Ej: ABC123',
                            icon: Icons.confirmation_number,
                            validator: (value) {
                              if (value != null &&
                                  value.trim().isNotEmpty &&
                                  value.trim().length < 5) {
                                return 'La placa debe tener al menos 5 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Año
                          _buildTextField(
                            label: 'Año',
                            controller: _anoController,
                            hint: 'Ej: 2023',
                            icon: Icons.calendar_today,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El año es requerido';
                              }
                              final year = int.tryParse(value);
                              if (year == null) {
                                return 'Ingresa un año válido';
                              }
                              final currentYear = DateTime.now().year;
                              if (year < 1900 || year > currentYear + 1) {
                                return 'Ingresa un año entre 1900 y ${currentYear + 1}';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Cilindraje (No editable) - Solo si está disponible
                          if (_motorcycle.displacement > 0) ...[
                            _buildLockedField(
                              label: 'Cilindraje',
                              value: '${_motorcycle.displacement}cc',
                              icon: Icons.speed,
                              message: 'El cilindraje no puede ser modificado',
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Kilometraje
                          _buildTextField(
                            label: 'Kilometraje',
                            controller: _kilometrajeController,
                            hint: 'Ej: 5000',
                            icon: Icons.speed,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El kilometraje es requerido';
                              }
                              final km = int.tryParse(value);
                              if (km == null || km < 0) {
                                return 'Ingresa un kilometraje válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),

                          // Botón Actualizar
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _updateMotorcycle,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Actualizar Motocicleta',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF2196F3)),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedField({
    required String label,
    required String value,
    required IconData icon,
    required String message,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const Spacer(),
              Icon(Icons.lock, color: Colors.grey[600], size: 18),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
