// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/services/alert_evalution_service.dart';
import 'package:frontend_manteniapp/core/services/firebase_push_service.dart';
import 'package:frontend_manteniapp/features/alerts/data/alert_model.dart';
import 'package:frontend_manteniapp/features/maintenance_history/presentation/providers/maintenance_history_provider.dart';
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
    _alertService = AlertEvaluationService(context);
    
    // 🔥 EVALUAR MANTENIMIENTOS AUTOMÁTICAMENTE AL INICIAR
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _evaluateExistingMaintenances(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: () {
              _autoEvaluateAlerts(context);
            },
            tooltip: 'Evaluar automáticamente',
          ),
        ],
      ),
      // 🔥 CAMBIO PRINCIPAL: Usar SingleChildScrollView en lugar de Column
      body: _buildScrollableContent(alerts, alertProvider, notificationProvider),
      // 🔥 BOTÓN FLOTANTE PARA PRUEBAS
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTestOptions(context);
        },
        child: const Icon(Icons.build),
      ),
    );
  }

  // 🔥 NUEVO MÉTODO: Contenido scrollable
  Widget _buildScrollableContent(
    List<AlertModel> alerts, 
    AlertProvider alertProvider, 
    NotificationProvider notificationProvider
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80), // 🔥 Espacio para el footer
      child: Column(
        children: [
          // 🔥 SECCIÓN DE PRUEBAS - Solo visible si no hay alertas
          if (alerts.isEmpty) _buildTestSection(),
          
          // 🔥 SECCIÓN DE ESTADÍSTICAS
          _buildStatsCard(alertProvider, notificationProvider),
          
          // 🔥 LISTA DE ALERTAS
          _buildAlertsSection(alerts),
          
          // 🔥 ESPACIO EXTRA PARA EVITAR CHOQUE CON FOOTER
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTestSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.auto_awesome_motion, size: 48, color: Colors.blue),
            const SizedBox(height: 10),
            const Text(
              'Sistema de Alertas Automáticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'El sistema evaluará automáticamente tus mantenimientos y creará alertas cuando sea necesario.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _evaluateExistingMaintenances(context),
                  icon: const Icon(Icons.search),
                  label: const Text('Evaluar Mantenimientos'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _loadRealTestData(context),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Datos de Prueba'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(AlertProvider alertProvider, NotificationProvider notificationProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '📊 Resumen',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Alertas Activas', 
                  '${alertProvider.alertasActivas.length}',
                  alertProvider.alertasActivas.isNotEmpty ? Colors.orange : Colors.grey
                ),
                _buildStatItem(
                  'Total Notificaciones', 
                  '${notificationProvider.notificaciones.length}',
                  Colors.blue
                ),
                _buildStatItem(
                  'Por Leer', 
                  '${notificationProvider.notificaciones.where((n) => !n.leida).length}',
                  notificationProvider.notificaciones.any((n) => !n.leida) ? Colors.red : Colors.green
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
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
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              '¡Todo al día!',
              style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'No hay alertas activas en este momento.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Alertas Activas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true, // 🔥 IMPORTANTE: Para scroll anidado
          physics: const NeverScrollableScrollPhysics(), // 🔥 Evitar conflicto de scroll
          itemCount: alerts.length,
          itemBuilder: (_, i) => AlertTile(alerta: alerts[i]),
        ),
      ],
    );
  }

  void _showTestOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Opciones de Prueba',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _createDirectTestAlert(context);
                  },
                  icon: const Icon(Icons.add_alert),
                  label: const Text('Alerta Directa'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _createTestNotification(context);
                  },
                  icon: const Icon(Icons.notifications),
                  label: const Text('Notificación'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _evaluateExistingMaintenances(context);
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Evaluar Mantenimientos'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _loadRealTestData(context);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Datos Reales'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showDebugInfo(context);
                  },
                  icon: const Icon(Icons.bug_report),
                  label: const Text('Debug'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 MÉTODOS DE PRUEBA
  void _createDirectTestAlert(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    final testAlert = AlertModel(
      id: 'direct_test_${DateTime.now().millisecondsSinceEpoch}',
      tipo: AlertType.fecha,
      descripcion: '🚨 ALERTA DE PRUEBA: Creada el ${DateFormat('HH:mm:ss').format(DateTime.now())}',
      fechaObjetivo: DateTime.now().add(const Duration(days: 5)),
      estado: AlertStatus.proxima,
    );

    alertProvider.agregarAlerta(testAlert);

    final notification = AppNotification(
      id: 'direct_notif_${DateTime.now().millisecondsSinceEpoch}',
      titulo: '🔔 Alerta de Prueba',
      descripcion: testAlert.descripcion,
      fecha: DateTime.now(),
    );

    notificationProvider.agregarNotificacion(notification);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Alerta de prueba creada')),
    );
  }

  void _createTestNotification(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

    final notification = AppNotification(
      id: 'test_notif_${DateTime.now().millisecondsSinceEpoch}',
      titulo: '📢 Notificación de Prueba',
      descripcion: 'Creada el ${DateFormat('HH:mm:ss').format(DateTime.now())}',
      fecha: DateTime.now(),
    );

    notificationProvider.agregarNotificacion(notification);

    FirebasePushService.showMaintenanceAlert(
      title: '📢 Notificación de Prueba',
      body: 'Esta es una notificación de prueba del sistema',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Notificación de prueba creada')),
    );
  }

  // 🔥 EVALUACIÓN AUTOMÁTICA DE MANTENIMIENTOS
  void _evaluateExistingMaintenances(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔍 Evaluando mantenimientos existentes...')),
    );

    _alertService.evaluateExistingMaintenances().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Mantenimientos evaluados - Alertas generadas automáticamente')),
      );
    });
  }

  // 🔥 EVALUACIÓN AUTOMÁTICA COMPLETA
  void _autoEvaluateAlerts(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🤖 Ejecutando evaluación automática...')),
    );

    _alertService.evaluateMaintenanceAlerts().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Evaluación automática completada')),
      );
    });
  }

  void _loadRealTestData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎯 Cargando datos reales de prueba...')),
    );

    _alertService.createRealTestData().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Datos reales de prueba creados')),
      );
    });
  }

  void _showDebugInfo(BuildContext context) {
    final alertProvider = Provider.of<AlertProvider>(context, listen: false);
    final maintenanceProvider = Provider.of<MaintenanceHistoryProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔍 Información de Debug'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📊 Alertas totales: ${alertProvider.alerts.length}'),
              Text('🚨 Alertas activas: ${alertProvider.alertasActivas.length}'),
              Text('📋 Mantenimientos: ${maintenanceProvider.maintenances.length}'),
              const SizedBox(height: 16),
              const Text('📝 Lista de alertas:'),
              ...alertProvider.alerts.map((alert) => Text(
                ' - ${alert.descripcion} (${alert.estado})',
                style: TextStyle(
                  color: alert.estado == AlertStatus.actual ? Colors.grey : Colors.black,
                ),
              )).toList(),
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
}