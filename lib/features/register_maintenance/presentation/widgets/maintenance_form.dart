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
          _buildHeaderImage(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 30),
          _buildMotoDropdown(),
          const SizedBox(height: 20),
          _buildTipoDropdown(),
          const SizedBox(height: 20),
          _buildKilometrajeField(),
          const SizedBox(height: 20),
          _buildDatePicker(context),
          const SizedBox(height: 20),
          _buildCostoField(),
          const SizedBox(height: 20),
          _buildDescripcionField(),
          const SizedBox(height: 30),
          if (widget.provider.error != null) _buildErrorWidget(),
          const SizedBox(height: 10),
          _buildConfirmButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 120, // Reducido para mejor proporción
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E88E5).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          'assets/img/mecanico.png',
          fit: BoxFit.contain, // Cambiado a contain para ver imagen completa
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.two_wheeler,
                size: 60,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        Text(
          'Registra Tu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          'Mantenimiento',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMotoDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E88E5).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonFormField<String>(
          value: widget.provider.selectedMotoId?.toString(),
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Motocicleta',
            labelStyle: TextStyle(color: Colors.grey),
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
            color: const Color(0xFF1E88E5).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonFormField<String>(
          value: widget.provider.selectedTipo,
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Tipo de mantenimiento',
            labelStyle: TextStyle(color: Colors.grey),
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
            color: const Color(0xFF1E88E5).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: Colors.grey),
        title: Text(
          widget.provider.selectedDate != null
              ? DateFormat('dd/MM/yyyy').format(widget.provider.selectedDate!)
              : 'Fecha',
          style: TextStyle(
            color: widget.provider.selectedDate != null ? Colors.black : Colors.grey,
            fontSize: 16,
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
            color: const Color(0xFF1E88E5).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Kilometraje',
            labelStyle: TextStyle(color: Colors.grey),
            suffixText: 'km',
            suffixStyle: TextStyle(color: Colors.grey),
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
            color: const Color(0xFF1E88E5).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Costo',
            labelStyle: TextStyle(color: Colors.grey),
            prefixText: '\$ ',
            prefixStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
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
            color: const Color(0xFF1E88E5).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          maxLines: 3,
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelText: 'Descripción',
            labelStyle: TextStyle(color: Colors.grey),
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
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.provider.error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: widget.provider.clearError,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.provider.isFormValid && 
                         !widget.provider.isLoading && 
                         !_isProcessing
              ? const Color(0xFF1E88E5)
              : Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          shadowColor: const Color(0xFF1E88E5).withOpacity(0.5),
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
                      backgroundColor: Colors.green,
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
                      backgroundColor: Colors.red,
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
                'Guardar Mantenimiento',
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