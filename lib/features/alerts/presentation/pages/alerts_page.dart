import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/alert_evalution_service.dart';
import 'package:frontend_manteniapp/core/services/firebase_push_service.dart';
import 'package:frontend_manteniapp/features/alerts/data/alert_model.dart';
import 'package:frontend_manteniapp/features/alerts/presentation/widgets/alerta_ditail_dialog.dart';
import 'package:frontend_manteniapp/features/maintenance_history/presentation/providers/maintenance_history_provider.dart';
import 'package:frontend_manteniapp/features/motorcycles/presentation/providers/motorcycle_provider.dart';
import 'package:frontend_manteniapp/features/notifications/data/notification_model.dart';
import 'package:frontend_manteniapp/features/notifications/state/notification_provier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../state/alert_provider.dart';
import '../widgets/alert_tile.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late AlertEvaluationService _alertService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _alertService = AlertEvaluationService(context);
      _evaluateExistingMaintenances(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final alertProvider = context.watch<AlertProvider>();
    final notificationProvider = context.watch<NotificationProvider>();
    final alerts = alertProvider.alertasActivas;

    return Scaffold(
      appBar: AppBar(
        title: Text("Alertas activas (${alerts.length})"),
        backgroundColor: const Color.fromARGB(255, 30, 125, 202),
        foregroundColor: Colors.white,
        elevation: 3,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _evaluateExistingMaintenances(context);
            },
            tooltip: 'Actualizar',
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Colors.white),
            onPressed: () {
              _autoEvaluateAlerts(context);
            },
            tooltip: 'Evaluar automáticamente',
          ),
        ],
      ),
      body: _buildScrollableContent(alerts, alertProvider, notificationProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTestOptions(context);
        },
        backgroundColor: const Color.fromARGB(255, 30, 125, 202),
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.build_circle),
      ),
    );
  }

  Widget _buildScrollableContent(
    List<AlertModel> alerts, 
    AlertProvider alertProvider, 
    NotificationProvider notificationProvider
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          if (alerts.isEmpty) _buildTestSection(),
          
          _buildStatsCard(alertProvider, notificationProvider),
          
          _buildAlertsSection(alerts),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTestSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.grey.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_motion, size: 36, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sistema de Alertas Automáticas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blueGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'El sistema evaluará automáticamente tus mantenimientos y creará alertas cuando sea necesario.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          // En la sección de botones, reemplaza con:
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton(
                icon: Icons.search,
                label: 'Evaluar Mantenimientos',
                color: Colors.blue,
                onPressed: () => _evaluateExistingMaintenances(context),
              ),
              _buildActionButton(
                icon: Icons.auto_awesome,
                label: 'Actualizar Alertas',
                color: Colors.green,
                onPressed: () => _refreshAlerts(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  
  // Agrega este método:
  void _refreshAlerts(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
            
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🔄 Actualizando estado de alertas...')),           );

            // Re-evaluar las alertas existentes
      alertProvider.evaluarTodasLasAlertas(
        notificationProvider,
        kmActual: _getCurrentKmFromProvider(context),
        fechaActual: DateTime.now(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Alertas actualizadas'),
          backgroundColor: Colors.green,
       ),
      );
    }
    int _getCurrentKmFromProvider(BuildContext context) {
      final motorcycleProvider = context.read<MotorcycleProvider>();
        if (motorcycleProvider.motorcycles.isNotEmpty) {
          return motorcycleProvider.motorcycles.first.mileage;
       }
     return 0;
    }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildStatsCard(AlertProvider alertProvider, NotificationProvider notificationProvider) {
    final alertasActivas = alertProvider.alertasActivas.length;
    final totalNotificaciones = notificationProvider.notificaciones.length;
    final notificacionesNoLeidas = notificationProvider.notificaciones.where((n) => !n.leida).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, size: 20, color: Colors.blueGrey),
                SizedBox(width: 8),
                Text(
                  'Resumen del Sistema',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blueGrey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Alertas Activas', 
                  '$alertasActivas',
                  alertasActivas > 0 ? Colors.orange : Colors.green,
                  alertasActivas > 0 ? Icons.warning : Icons.check_circle,
                ),
                _buildStatItem(
                  'Notificaciones', 
                  '$totalNotificaciones',
                  totalNotificaciones > 0 ? Colors.blue : Colors.grey,
                  Icons.notifications,
                ),
                _buildStatItem(
                  'Por Leer', 
                  '$notificacionesNoLeidas',
                  notificacionesNoLeidas > 0 ? Colors.red : Colors.green,
                  Icons.mark_email_unread,
                ),
              ],
            ),
            if (alertasActivas == 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '¡Todo al día! No hay alertas pendientes',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAlertsSection(List<AlertModel> alerts) {
    if (alerts.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.shade100),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green.shade600),
            const SizedBox(height: 16),
            Text(
              '¡Todo al día!',
              style: TextStyle(
                fontSize: 20, 
                color: Colors.green.shade700, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No hay alertas activas en este momento.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.warning_amber, size: 20, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Alertas Activas',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...alerts.map((alert) => 
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: AlertTile(
                alerta: alert,
                onMarcarLeida: () {
                  context.read<AlertProvider>().marcarComoLeida(alert.id);
                },
                onResolver: () {
                  context.read<AlertProvider>().marcarComoResuelta(alert.id);
                },
                onVerDetalle: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDetailDialog(
                      alerta: alert,
                    ),
                  );
                },
              ),
            )
          ).toList(),
        ],
      ),
    );
  }

  void _evaluateExistingMaintenances(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔍 Evaluando mantenimientos existentes...')),
    );

    _alertService.evaluateExistingMaintenances().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Mantenimientos evaluados - Alertas generadas automáticamente'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _autoEvaluateAlerts(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🤖 Ejecutando evaluación automática...')),
    );

    _alertService.evaluateMaintenanceAlerts().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Evaluación automática completada'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _loadRealTestData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎯 Cargando datos reales de prueba...')),
    );

    _alertService.createRealTestData().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Datos reales de prueba creados'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _createDirectTestAlert(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    alertProvider.crearAlertaDirectaPrueba();

    final notification = AppNotification(
      id: 'direct_notif_${DateTime.now().millisecondsSinceEpoch}',
      titulo: '🔔 Alerta de Prueba Directa',
      descripcion: 'Alerta de prueba creada directamente',
      fecha: DateTime.now(), tipo: 'test',
    );

    notificationProvider.agregarNotificacion(notification);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Alerta de prueba directa creada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _createTestNotification(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    final notification = AppNotification(
      id: 'test_notif_${DateTime.now().millisecondsSinceEpoch}',
      titulo: '📢 Notificación de Prueba',
      descripcion: 'Creada el ${DateFormat('HH:mm:ss').format(DateTime.now())}',
      fecha: DateTime.now(), tipo: 'test',
    );

    notificationProvider.agregarNotificacion(notification);

    FirebasePushService.showMaintenanceAlert(
      title: '📢 Notificación de Prueba',
      body: 'Esta es una notificación de prueba del sistema',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Notificación de prueba creada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDebugInfo(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final maintenanceProvider = Provider.of<MaintenanceHistoryProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bug_report, color: Colors.purple),
            SizedBox(width: 8),
            Text('Información de Debug'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDebugItem('📊 Alertas totales', '${alertProvider.alerts.length}'),
              _buildDebugItem('🚨 Alertas activas', '${alertProvider.alertasActivas.length}'),
              _buildDebugItem('📋 Mantenimientos', '${maintenanceProvider.maintenances.length}'),
              const SizedBox(height: 16),
              const Text('📝 Lista de alertas:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...alertProvider.alerts.take(5).map((alert) => Text(
                ' • ${alert.descripcion} (${alert.estado})',
                style: TextStyle(
                  color: alert.estado == AlertStatus.actual ? Colors.grey : 
                         alert.estado == AlertStatus.proxima ? Colors.orange : 
                         alert.estado == AlertStatus.vencida ? Colors.red : Colors.green,
                ),
              )).toList(),
              if (alertProvider.alerts.length > 5)
                Text('... y ${alertProvider.alerts.length - 5} más'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // 🔥 PANEL DE OPCIONES DE PRUEBA COMPLETO
  void _showTestOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header del panel
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.build_circle, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Opciones de Prueba',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Grid de opciones
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    _buildTestOptionCard(
                      icon: Icons.add_alert,
                      title: 'Alerta Directa',
                      description: 'Crear alerta de prueba inmediata',
                      color: Colors.red,
                      onTap: () {
                        Navigator.pop(context);
                        _createDirectTestAlert(context);
                      },
                    ),
                    _buildTestOptionCard(
                      icon: Icons.notifications,
                      title: 'Notificación',
                      description: 'Enviar notificación de prueba',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                        _createTestNotification(context);
                      },
                    ),
                    _buildTestOptionCard(
                      icon: Icons.search,
                      title: 'Evaluar Mantenimientos',
                      description: 'Revisar mantenimientos pendientes',
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        _evaluateExistingMaintenances(context);
                      },
                    ),
                    _buildTestOptionCard(
                      icon: Icons.play_arrow,
                      title: 'Datos Reales',
                      description: 'Cargar datos de prueba realistas',
                      color: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        _loadRealTestData(context);
                      },
                    ),
                    _buildTestOptionCard(
                      icon: Icons.bug_report,
                      title: 'Debug Info', description: '', onTap: () {  }, color: Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  _buildTestOptionCard({required IconData icon, required String title, required String description, required Null Function() onTap, required MaterialColor color }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  
