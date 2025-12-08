import 'package:flutter/material.dart';
import '../../domain/entities/maintenance_entity.dart';

class EditMaintenanceModal extends StatefulWidget {
  final MaintenanceEntity maintenance;
  final Function(MaintenanceEntity) onSave;

  const EditMaintenanceModal({
    super.key,
    required this.maintenance,
    required this.onSave,
  });

  @override
  State<EditMaintenanceModal> createState() => _EditMaintenanceModalState();
}

class _EditMaintenanceModalState extends State<EditMaintenanceModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _costController;
  late TextEditingController _descriptionController;
  late String _selectedType;
  late DateTime _selectedDate;
  late List<String> _maintenanceTypes;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.maintenance.type;
    _selectedDate = widget.maintenance.date;

    // Lista base de tipos de mantenimiento
    _maintenanceTypes = [
      'Cambio de aceite',
      'Cambio de llantas',
      'Revisión general',
      'Cambio de frenos',
      'Cambio de cadena',
      'Alineación y balanceo',
      'Cambio de filtros',
      'Mantenimiento eléctrico',
      'Otro',
    ];

    // Si el tipo actual no está en la lista, agregarlo
    if (!_maintenanceTypes.contains(_selectedType)) {
      _maintenanceTypes.insert(0, _selectedType);
    }

    _costController = TextEditingController(
      text: widget.maintenance.cost.toStringAsFixed(2),
    );
    _descriptionController = TextEditingController(
      text: widget.maintenance.description ?? '',
    );
  }

  @override
  void dispose() {
    _costController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      // ⚠️ El backend solo permite actualizar: descripción y costo
      // No se puede cambiar: tipo, fecha y notas
      final updatedMaintenance = widget.maintenance.copyWith(
        cost: double.parse(_costController.text),
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );
      widget.onSave(updatedMaintenance);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Editar Mantenimiento',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: Colors.grey[600],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ⚠️ Nota informativa
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  border: Border.all(color: Colors.amber[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Solo se puede editar el costo y la descripción',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tipo de mantenimiento (DESHABILITADO)
              Text(
                'Tipo de mantenimiento',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items: _maintenanceTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged:
                    null, // ⚠️ DESHABILITADO - backend no permite cambiar tipo
              ),

              const SizedBox(height: 20),

              // Fecha (DESHABILITADA)
              Text(
                'Fecha',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Fecha (DESHABILITADA)
              Text(
                'Fecha',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDate(_selectedDate),
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Costo
              Text(
                'Costo',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _costController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el costo';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingresa un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Descripción
              Text(
                'Descripción',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  hintText: 'Describe el mantenimiento realizado',
                ),
              ),
              const SizedBox(height: 20),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Guardar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
