enum AlertType { kilometraje, fecha, estado }
enum AlertStatus { proxima, vencida, actual }

class AlertModel {
  final String id;
  final AlertType tipo;
  final String descripcion;
  AlertStatus estado;
  
  final DateTime? fechaObjetivo;
  final int? kmObjetivo;

  AlertModel({
    required this.id,
    required this.tipo,
    required this.descripcion,
    this.fechaObjetivo,
    this.kmObjetivo,
    required this.estado,
  });
}
