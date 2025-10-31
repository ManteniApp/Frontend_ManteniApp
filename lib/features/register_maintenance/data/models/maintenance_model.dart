import 'package:frontend_manteniapp/features/register_maintenance/domain/entities/maintenance_entity.dart';

class MaintenanceModel extends Maintenance {
  MaintenanceModel({
    super.id,
    required super.motoId,
    required super.fecha,
    required super.tipo,
    super.descripcion,
    super.kilometraje,
    super.costo,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'],
      motoId: json['moto_id'],
      fecha: DateTime.parse(json['fecha']),
      tipo: json['tipo'],
      descripcion: json['descripcion'],
      kilometraje: json['kilometraje'],
      costo: json['costo']?.toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
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

  MaintenanceModel copyWith({
    int? id,
    int? motoId,
    DateTime? fecha,
    String? tipo,
    String? descripcion,
    int? kilometraje,
    double? costo,
  }) {
    return MaintenanceModel(
      id: id ?? this.id,
      motoId: motoId ?? this.motoId,
      fecha: fecha ?? this.fecha,
      tipo: tipo ?? this.tipo,
      descripcion: descripcion ?? this.descripcion,
      kilometraje: kilometraje ?? this.kilometraje,
      costo: costo ?? this.costo,
    );
  }
}