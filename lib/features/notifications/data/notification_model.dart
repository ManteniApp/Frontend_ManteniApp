class AppNotification {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  bool leida;

  AppNotification({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    this.leida = false,
  });
}
