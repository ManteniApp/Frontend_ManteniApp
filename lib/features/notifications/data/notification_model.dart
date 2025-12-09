class AppNotification {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final String tipo;
  bool leida;
  final Map<String, dynamic>? dataPayload; // Datos adicionales de la notificación

  AppNotification({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
    this.leida = false,
    this.dataPayload,
  });

  // Constructor desde notificación remota
  factory AppNotification.fromRemoteMessage(Map<String, dynamic> message) {
    final data = message['data'] ?? {};
    final notification = message['notification'] ?? {};
    
    return AppNotification(
      id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: notification['title'] ?? data['titulo'] ?? 'Nueva notificación',
      descripcion: notification['body'] ?? data['descripcion'] ?? '',
      fecha: DateTime.now(),
      tipo: data['tipo'] ?? 'general',
      dataPayload: data,
    );
  }
}