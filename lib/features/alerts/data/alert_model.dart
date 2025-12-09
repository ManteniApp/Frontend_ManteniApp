enum AlertType { kilometraje, fecha, estado, mantenimiento }
enum AlertStatus { proxima, vencida, actual, resuelta }

class AlertModel {
  final String id;
  final AlertType tipo;
  final String descripcion;
  final String detalle;
  AlertStatus estado;
  bool leida;
  
  // Información de la moto asociada
  final String motoId;
  final String motoNombre;
  final String? mantenimientoId;
  
  final DateTime? fechaObjetivo;
  final int? kmObjetivo;
  final DateTime fechaCreacion;

  AlertModel({
    required this.id,
    required this.tipo,
    required this.descripcion,
    required this.detalle,
    required this.motoId,
    required this.motoNombre,
    this.mantenimientoId,
    this.fechaObjetivo,
    this.kmObjetivo,
    required this.estado,
    this.leida = false,
    required this.fechaCreacion, required String titulo, String? maintenanceId, required int priority, required String motorcycleId,
  });

  get maintenanceId => null;

  get motorcycleId => null;
}