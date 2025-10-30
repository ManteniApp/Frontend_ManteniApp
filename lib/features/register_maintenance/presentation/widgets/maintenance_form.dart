import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/maintenance_provider.dart';

class MaintenanceForm extends StatefulWidget {
  final MaintenanceProvider provider;
  final List<Map<String, dynamic>> motos;

  const MaintenanceForm({
    super.key,
    required this.provider,
    required this.motos,
  });

  @override
  State<MaintenanceForm> createState() => _MaintenanceFormState();
}

class _MaintenanceFormState extends State<MaintenanceForm> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMotoDropdown(),
          const SizedBox(height: 20),
          _buildTipoDropdown(),
          const SizedBox(height: 20),
          _buildDatePicker(context),
          const SizedBox(height: 20),
          _buildKilometrajeField(),
          const SizedBox(height: 20),
          _buildCostoField(),
          const SizedBox(height: 20),
          _buildDescripcionField(),
          const SizedBox(height: 30),
          if (widget.provider.error != null) _buildErrorWidget(),
          const SizedBox(height: 10),
          _buildSaveButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMotoDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonFormField<String>(
          value: widget.provider.selectedMotoId?.toString(),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Motocicleta',
            labelStyle: TextStyle(color: Colors.grey[600]),
          ),
          items: widget.motos.map((moto) {
            return DropdownMenuItem<String>(
              value: moto['id']?.toString(),
              child: Text('${moto['marca']} ${moto['modelo']}'),
            );
          }).toList(),
          onChanged: (String? newValue) {
            widget.provider.setSelectedMoto(newValue);
          },
        ),
      ),
    );
  }

  Widget _buildTipoDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonFormField<String>(
          value: widget.provider.selectedTipo,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Tipo de mantenimiento',
            labelStyle: TextStyle(color: Colors.grey[600]),
          ),
          items: widget.provider.tiposMantenimiento.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.provider.setSelectedTipo,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: Colors.grey[600]),
        title: Text(
          widget.provider.selectedDate != null
              ? DateFormat('dd/MM/yyyy').format(widget.provider.selectedDate!)
              : 'Seleccionar fecha',
          style: TextStyle(
            color: widget.provider.selectedDate != null ? Colors.black : Colors.grey,
          ),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        onTap: () => _selectDate(context),
      ),
    );
  }

  Widget _buildKilometrajeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Kilometraje',
            labelStyle: TextStyle(color: Colors.grey[600]),
            suffixText: 'km',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              widget.provider.setKilometraje(int.tryParse(value));
            } else {
              widget.provider.setKilometraje(null);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCostoField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Costo',
            labelStyle: TextStyle(color: Colors.grey[600]),
            prefixText: '\$',
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
            final costo = double.tryParse(value.replaceAll(',', '.'));
            widget.provider.setCosto(costo);
            print('💰 Costo ingresado: "$value" -> $costo');
          } else {
            widget.provider.setCosto(null);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDescripcionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          maxLines: 3,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Descripción del mantenimiento',
            labelStyle: TextStyle(color: Colors.grey[600]),
            alignLabelWithHint: true,
          ),
          onChanged: widget.provider.setDescripcion,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.provider.error!,
              style: TextStyle(color: Colors.red[700]),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: widget.provider.clearError,
          ),
        ],
      ),
    );
  }

  
  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.provider.isFormValid && 
                         !widget.provider.isLoading && 
                         !_isProcessing
              ? const Color(0xFF1E88E5) // ← CAMBIADO A AZUL
              : Colors.grey.shade400,
          foregroundColor: Colors.white, // ← CAMBIADO A BLANCO
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
        onPressed: (widget.provider.isFormValid && 
                   !widget.provider.isLoading && 
                   !_isProcessing)
            ? () async {
                if (_isProcessing) return;
                
                setState(() {
                  _isProcessing = true;
                });
                
                print('🔄 Botón presionado - Iniciando creación...');
                final success = await widget.provider.createMaintenance();
                
                if (mounted) {
                  setState(() {
                    _isProcessing = false;
                  });
                }
              
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Mantenimiento registrado exitosamente'),
                      backgroundColor: Colors.green.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  widget.provider.clearForm();
                  Navigator.pop(context, true);
                } else if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${widget.provider.error}'),
                      backgroundColor: Colors.red.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              }
            : null,
        child: widget.provider.isLoading || _isProcessing
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'GUARDAR MANTENIMIENTO',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != widget.provider.selectedDate) {
      widget.provider.setSelectedDate(picked);
    }
  }
}