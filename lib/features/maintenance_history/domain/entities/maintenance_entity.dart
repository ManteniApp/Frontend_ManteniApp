/// Entidad que representa un mantenimiento en el dominio
class MaintenanceEntity {
  final String? id;
  final String type; // Tipo: General, Eléctrico, Mecánico, etc.
  final DateTime date;
  final double cost;
  final String motorcycleName; // Nombre de la moto (ej: "AKT NKD 125")
  final String? motorcycleId;
  final String? description;
  final String? notes;
  final DateTime? createdAt;

  const MaintenanceEntity({
    this.id,
    required this.type,
    required this.date,
    required this.cost,
    required this.motorcycleName,
    this.motorcycleId,
    this.description,
    this.notes,
    this.createdAt,
  });

  MaintenanceEntity copyWith({
    String? id,
    String? type,
    DateTime? date,
    double? cost,
    String? motorcycleName,
    String? motorcycleId,
    String? description,
    String? notes,
    DateTime? createdAt,
  }) {
    return MaintenanceEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      cost: cost ?? this.cost,
      motorcycleName: motorcycleName ?? this.motorcycleName,
      motorcycleId: motorcycleId ?? this.motorcycleId,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'MaintenanceEntity(id: $id, type: $type, date: $date, cost: $cost, motorcycleName: $motorcycleName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaintenanceEntity &&
        other.id == id &&
        other.type == type &&
        other.motorcycleName == motorcycleName;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode ^ motorcycleName.hashCode;
}
