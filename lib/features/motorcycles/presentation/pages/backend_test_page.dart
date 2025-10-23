import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/auth_service.dart';
import 'package:frontend_manteniapp/features/motorcycles/data/datasources/motorcycle_remote_data_source.dart';
import 'package:frontend_manteniapp/features/motorcycles/data/models/motorcycle_model.dart';

/// 🧪 Página de Prueba de Integración con Backend
///
/// Esta página te permite probar fácilmente la conexión con el backend:
/// 1. Hacer login
/// 2. Ver motocicletas
/// 3. Registrar una motocicleta nueva
///
/// Para usar:
/// 1. Configura la URL del backend en lib/core/network/api_config.dart
/// 2. Ejecuta tu backend
/// 3. Navega a esta página desde tu app
class BackendTestPage extends StatefulWidget {
  const BackendTestPage({Key? key}) : super(key: key);

  @override
  State<BackendTestPage> createState() => _BackendTestPageState();
}

class _BackendTestPageState extends State<BackendTestPage> {
  final AuthService _authService = AuthService();
  final MotorcycleRemoteDataSource _motorcycleService =
      MotorcycleRemoteDataSourceImpl();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  List<MotorcycleModel> _motorcycles = [];
  String _statusMessage = 'No autenticado';

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  /// Verifica si ya hay una sesión activa
  Future<void> _checkAuthentication() async {
    final isAuth = await _authService.isAuthenticated();
    setState(() {
      _isAuthenticated = isAuth;
      _statusMessage = isAuth ? '✅ Autenticado' : '❌ No autenticado';
    });

    if (isAuth) {
      final email = await _authService.getUserEmail();
      setState(() {
        _statusMessage = '✅ Autenticado como: $email';
      });
      _loadMotorcycles();
    }
  }

  /// Realiza el login
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage('⚠️ Completa todos los campos', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '⏳ Iniciando sesión...';
    });

    try {
      final token = await _authService.login(email, password);

      if (token != null) {
        setState(() {
          _isAuthenticated = true;
          _statusMessage = '✅ Login exitoso';
        });
        _showMessage('✅ Login exitoso');
        _loadMotorcycles();
      } else {
        setState(() {
          _statusMessage = '❌ Credenciales incorrectas';
        });
        _showMessage('❌ Credenciales incorrectas', isError: true);
      }
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error: $e';
      });
      _showMessage('❌ Error: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Carga las motocicletas desde el backend
  Future<void> _loadMotorcycles() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '⏳ Cargando motocicletas...';
    });

    try {
      final motorcycles = await _motorcycleService.getAllMotorcycles();
      setState(() {
        _motorcycles = motorcycles;
        _statusMessage = '✅ ${motorcycles.length} motocicleta(s) encontrada(s)';
      });
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error al cargar: $e';
      });
      _showMessage('❌ Error: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Registra una motocicleta de prueba
  Future<void> _registerTestMotorcycle() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '⏳ Registrando motocicleta...';
    });

    final testMotorcycle = MotorcycleModel(
      brand: 'Yamaha',
      model: 'MT-07',
      year: DateTime.now().year,
      displacement: 689,
      mileage: 0,
    );

    try {
      final created = await _motorcycleService.registerMotorcycle(
        testMotorcycle,
      );

      setState(() {
        _statusMessage = '✅ Motocicleta registrada: ${created.id}';
      });
      _showMessage('✅ Motocicleta registrada exitosamente');
      _loadMotorcycles(); // Recargar lista
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Error al registrar: $e';
      });
      _showMessage('❌ Error: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Cierra la sesión
  Future<void> _handleLogout() async {
    await _authService.logout();
    setState(() {
      _isAuthenticated = false;
      _motorcycles = [];
      _statusMessage = '✅ Sesión cerrada';
    });
    _showMessage('✅ Sesión cerrada');
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Test Backend Integration'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Estado de conexión
                  Card(
                    color: _isAuthenticated ? Colors.green[50] : Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            _isAuthenticated ? Icons.check_circle : Icons.error,
                            color: _isAuthenticated ? Colors.green : Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _statusMessage,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Formulario de login (si no está autenticado)
                  if (!_isAuthenticated) ...[
                    const Text(
                      '🔐 Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _handleLogin,
                      icon: const Icon(Icons.login),
                      label: const Text('Iniciar Sesión'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],

                  // Controles si está autenticado
                  if (_isAuthenticated) ...[
                    const Text(
                      '🏍️ Motocicletas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _loadMotorcycles,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Recargar'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _registerTestMotorcycle,
                            icon: const Icon(Icons.add),
                            label: const Text('Registrar'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12),
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar Sesión'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        backgroundColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Lista de motocicletas
                    if (_motorcycles.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'No hay motocicletas registradas',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ..._motorcycles.map(
                        (moto) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                moto.brand[0].toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              '${moto.brand} ${moto.model}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Año: ${moto.year} | ${moto.displacement}cc | ${moto.mileage} km',
                            ),
                            trailing: const Icon(Icons.motorcycle),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
