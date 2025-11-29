class Maintenance {
  final int? id;
  final int motoId;
  final DateTime fecha;
  final String tipo;
  final String? descripcion;
  final int? kilometraje;
  final double? costo;

  Maintenance({
    this.id,
    required this.motoId,
    required this.fecha,
    required this.tipo,
    this.descripcion,
    this.kilometraje,
    this.costo,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json) {
    print('🔄 Maintenance.fromJson llamado con: $json');
    
    // DEBUG ESPECIAL PARA COSTO
    final costoRaw = json['costo'];
    print('💰 Costo raw: "$costoRaw" (tipo: ${costoRaw.runtimeType})');
    
    double? costoParsed;
    if (costoRaw != null) {
      if (costoRaw is double) {
        costoParsed = costoRaw;
      } else if (costoRaw is int) {
        costoParsed = costoRaw.toDouble();
      } else if (costoRaw is String) {
        // ¡ESTA ES LA LÍNEA PROBLEMÁTICA!
        // NO usar .toDouble() en String, usar double.tryParse
        costoParsed = double.tryParse(costoRaw.replaceAll(',', '.'));
        print('💰 String convertido a double: $costoParsed');
      }
    }
    
    print('💰 Costo final parsed: $costoParsed');

    return Maintenance(
      id: json['id'],
      motoId: json['moto_id'],
      fecha: DateTime.parse(json['fecha']),
      tipo: json['tipo'],
      descripcion: json['descripcion'],
      kilometraje: json['kilometraje'],
      costo: costoParsed, // Usar la versión convertida
    );
  }

  Map<String, dynamic> toJson() {
    print('📤 Maintenance.toJson llamado');
    print('   - Costo a serializar: $costo (${costo.runtimeType})');
    
    return {
      if (id != null) 'id': id,
      'moto_id': motoId,
      'fecha': fecha.toIso8601String().split('T')[0],
      'tipo': tipo,
      'descripcion': descripcion,
      'kilometraje': kilometraje,
      'costo': costo,
    };
  }
}