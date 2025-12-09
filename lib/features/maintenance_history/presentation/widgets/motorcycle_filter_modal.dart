import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../motorcycles/presentation/providers/motorcycle_provider.dart';

class MotorcycleFilterModal extends StatefulWidget {
  final String? selectedMotorcycleId;
  final Function(String?) onApply;

  const MotorcycleFilterModal({
    super.key,
    this.selectedMotorcycleId,
    required this.onApply,
  });

  @override
  State<MotorcycleFilterModal> createState() => _MotorcycleFilterModalState();
}

class _MotorcycleFilterModalState extends State<MotorcycleFilterModal> {
  String? _selectedId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedMotorcycleId;
    _loadMotorcycles();
  }

  /// Cargar las motocicletas del usuario desde el backend
  Future<void> _loadMotorcycles() async {
    final motorcycleProvider = context.read<MotorcycleProvider>();
    await motorcycleProvider.loadMotorcycles();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedId = null;
    });
  }

  void _applyFilter() {
    widget.onApply(_selectedId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final motorcycleProvider = context.watch<MotorcycleProvider>();
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 100),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtrar por motocicleta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 16),

    return DraggableScrollableSheet(
      initialChildSize: 0.3, 
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filtrar por motocicleta',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Lista de motocicletas
                _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Consumer<MotorcycleProvider>(
                        builder: (context, motorcycleProvider, child) {
                          final motorcycles = motorcycleProvider.motorcycles;

                          if (motorcycles.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.motorcycle_outlined,
                                    size: 48,
                                    color: Colors.grey[400],
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage:
                                        motorcycle.imageUrl.isNotEmpty
                                        ? NetworkImage(motorcycle.imageUrl)
                                        : null,
                                    child: motorcycle.imageUrl.isEmpty
                                        ? Icon(
                                            Icons.motorcycle,
                                            color: Colors.grey[600],
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No tienes motocicletas registradas',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          return Column(
                            children: [
                              ...motorcycles.map((motorcycle) {
                                final isSelected = _selectedId == motorcycle.id;

                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedId = motorcycle.id;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF2196F3)
                                            : Colors.grey[300]!,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      color: isSelected
                                          ? const Color(0xFF2196F3)
                                              .withOpacity(0.1)
                                          : Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.motorcycle,
                                          color: isSelected
                                              ? const Color(0xFF2196F3)
                                              : Colors.grey[600],
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${motorcycle.brand} ${motorcycle.model}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: isSelected
                                                      ? const Color(0xFF2196F3)
                                                      : Colors.black87,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                motorcycle.licensePlate ??
                                                    'Sin placa',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(
                                            Icons.check_circle,
                                            color: Color(0xFF2196F3),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 20), // Espacio extra
                            ],
                          );
                        },
                      ),
                const SizedBox(height: 24),
                    );
                  },
                ),
          const SizedBox(height: 16),

                // Botones (ahora están dentro del scroll)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clearSelection,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Limpiar',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _applyFilter,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Aplicar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Espacio extra para que los botones no queden pegados al final
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 
                    ? MediaQuery.of(context).viewInsets.bottom 
                    : 16),
              ],
            ),
          ),
        );
      },
    );
  }

  static void show(
    BuildContext context, {
    String? selectedMotorcycleId,
    required Function(String?) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MotorcycleFilterModal(
        selectedMotorcycleId: selectedMotorcycleId,
        onApply: onApply,
      ),
    );
  }
}