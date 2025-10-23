import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/motorcycle_provider.dart';
import '../widgets/simple_form_field.dart';

class RegisterMotorcyclePage extends StatefulWidget {
  const RegisterMotorcyclePage({super.key});

  @override
  State<RegisterMotorcyclePage> createState() => _RegisterMotorcyclePageState();
}

class _RegisterMotorcyclePageState extends State<RegisterMotorcyclePage> {
  final _formKey = GlobalKey<FormState>();

  // Datos del formulario
  String? marca;
  String? modelo;
  String? placa; // 👈 Agregado
  int? ano;
  String? cilindraje;
  int? kilometraje;

  // Lista de cilindrajes disponibles
  final List<String> cilindrajesDisponibles = [
    '50cc',
    '110cc',
    '125cc',
    '150cc',
    '200cc',
    '250cc',
    '300cc',
    '400cc',
    '500cc',
    '600cc',
    '650cc',
    '750cc',
    '800cc',
    '900cc',
    '1000cc',
    '1200cc',
    '1300cc',
    '1400cc',
    '1500cc',
    '1600cc',
    '1800cc',
    '2000cc',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo con header e ilustración
            Column(
              children: [
                // Header y parte superior
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Header con logo
                      _buildHeader(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                // Ilustración del mecánico con moto
                _buildIllustration(context),
                // Espacio para que la ilustración se vea completa
                const SizedBox(height: 100),
              ],
            ),

            // Contenedor del formulario posicionado desde abajo
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                // margin: removido para ocupar toda la pantalla
                padding: const EdgeInsets.all(24),
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height *
                      0.65, // Máximo 65% de la pantalla
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF007AFF,
                      ).withOpacity(0.3), // Sombra azul #007AFF
                      blurRadius: 25,
                      offset: const Offset(0, -8),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: const Color(
                        0xFF007AFF,
                      ).withOpacity(0.1), // Sombra secundaria más sutil
                      blurRadius: 15,
                      offset: const Offset(0, -3),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título
                      _buildTitle(context),
                      const SizedBox(height: 30),
                      // Formulario
                      _buildForm(context),
                      const SizedBox(height: 20), // Reducido de 40 a 20
                      // Botón Siguiente
                      _buildNextButton(context),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Botón de volver en la esquina superior izquierda
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF007AFF),
              size: 20,
            ),
          ),
        ),
        // Espacio expansible para centrar el logo y texto
        Expanded(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo real de ManteniApp
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Image.asset(
                    'assets/images/logoMA.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback si no encuentra la imagen
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.build,
                          color: Colors.white,
                          size: 18,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'ManteniApp',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Espacio invisible para mantener el balance visual
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 200, // Aumentado para dar más espacio a la imagen completa
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFFE8F4FD), const Color(0xFFF8FBFF)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/images/imgRegistro.png',
          fit: BoxFit
              .contain, // Cambiado para que se ajuste completamente sin recortar
          errorBuilder: (context, error, stackTrace) {
            // Fallback más parecido al Figma
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFFE8F4FD), const Color(0xFFF8FBFF)],
                ),
              ),
              child: Stack(
                children: [
                  // Mecánico placeholder más realista
                  Positioned(
                    right: 40,
                    bottom: 20,
                    child: Container(
                      width: 60,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3E50),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  // Moto placeholder
                  Positioned(
                    left: 20,
                    bottom: 10,
                    child: Container(
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Registra Tu Moto',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo Marca
          SimpleFormField(
            icon: Icons.label_outline,
            label: 'Marca',
            value: marca,
            onTap: () async {
              final result = await SelectionBottomSheet.showTextInput(
                context: context,
                title: 'Marca de la motocicleta',
                hint: 'Ej: Honda, Yamaha, Suzuki...',
                initialValue: marca,
              );
              if (result != null && result.isNotEmpty) {
                setState(() {
                  marca = result;
                });
              }
            },
          ),

          // Campo Modelo
          SimpleFormField(
            icon: Icons.motorcycle,
            label: 'Modelo',
            value: modelo,
            onTap: () async {
              final result = await SelectionBottomSheet.showTextInput(
                context: context,
                title: 'Modelo de la motocicleta',
                hint: 'Ej: CBR 600, YZF-R3, Ninja...',
                initialValue: modelo,
              );
              if (result != null && result.isNotEmpty) {
                setState(() {
                  modelo = result;
                });
              }
            },
          ),

          // Campo Placa (NUEVO) 👈
          SimpleFormField(
            icon: Icons.pin,
            label: 'Placa',
            value: placa,
            onTap: () async {
              final result = await SelectionBottomSheet.showTextInput(
                context: context,
                title: 'Placa de la motocicleta',
                hint: 'Ej: ABC123',
                initialValue: placa,
              );
              if (result != null && result.isNotEmpty) {
                setState(() {
                  placa = result.toUpperCase(); // Convertir a mayúsculas
                });
              }
            },
          ),

          // Campo Año
          SimpleFormField(
            icon: Icons.calendar_today_outlined,
            label: 'Año',
            value: ano?.toString(),
            onTap: () async {
              final result = await SelectionBottomSheet.showDateSelection(
                context: context,
                title: 'Año de fabricación',
                initialDate: ano != null ? DateTime(ano!) : null,
              );
              if (result != null) {
                setState(() {
                  ano = result.year;
                });
              }
            },
          ),

          // Campo Cilindraje
          SimpleFormField(
            icon: Icons.tune,
            label: 'Cilindraje',
            value: cilindraje,
            onTap: () async {
              final result = await SelectionBottomSheet.showDropdownSelection(
                context: context,
                title: 'Selecciona el cilindraje',
                options: cilindrajesDisponibles,
                selectedValue: cilindraje,
              );
              if (result != null) {
                setState(() {
                  cilindraje = result;
                });
              }
            },
          ),

          // Campo Kilometraje
          SimpleFormField(
            icon: Icons.speed,
            label: 'Kilometraje',
            value: kilometraje != null ? '$kilometraje km' : null,
            onTap: () async {
              final result = await SelectionBottomSheet.showTextInput(
                context: context,
                title: 'Kilometraje actual',
                hint: 'Ej: 15000',
                initialValue: kilometraje?.toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              );
              if (result != null && result.isNotEmpty) {
                setState(() {
                  kilometraje = int.tryParse(result);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Consumer<MotorcycleProvider>(
      builder: (context, provider, child) {
        return SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: provider.isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
              ),
            ),
            child: provider.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Siguiente',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        );
      },
    );
  }

  void _submitForm() async {
    // Validar que todos los campos estén llenos
    if (marca == null || marca!.isEmpty) {
      _showError('Por favor ingresa la marca');
      return;
    }
    if (modelo == null || modelo!.isEmpty) {
      _showError('Por favor ingresa el modelo');
      return;
    }
    if (placa == null || placa!.isEmpty) {
      _showError('Por favor ingresa la placa');
      return;
    }
    if (ano == null) {
      _showError('Por favor selecciona el año');
      return;
    }
    if (cilindraje == null || cilindraje!.isEmpty) {
      _showError('Por favor selecciona el cilindraje');
      return;
    }
    if (kilometraje == null) {
      _showError('Por favor ingresa el kilometraje');
      return;
    }

    final provider = Provider.of<MotorcycleProvider>(context, listen: false);

    final success = await provider.registerMotorcycleWithParams(
      marca: marca!,
      modelo: modelo!,
      placa: placa!, // 👈 Agregado
      ano: ano!,
      cilindraje: cilindraje!,
      kilometraje: kilometraje!,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Motocicleta registrada exitosamente!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Resetear formulario
        setState(() {
          marca = null;
          modelo = null;
          placa = null; // 👈 Agregado
          ano = null;
          cilindraje = null;
          kilometraje = null;
        });
      } else {
        _showError(provider.errorMessage ?? 'Error al registrar motocicleta');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
