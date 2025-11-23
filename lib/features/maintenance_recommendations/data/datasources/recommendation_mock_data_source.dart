import '../models/recommendation_model.dart';

/// Data source MOCK para recomendaciones de mantenimiento
/// ⚠️ Este data source devuelve datos simulados para desarrollo
/// Cambiar a RecommendationRemoteDataSourceImpl cuando el backend esté listo
class RecommendationMockDataSource {
  /// Simula un delay de red
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  /// Obtiene recomendaciones GENERALES simuladas
  Future<List<MaintenanceRecommendationModel>>
  getGeneralRecommendations() async {
    print('🎭 [MOCK] Obteniendo recomendaciones generales...');
    await _simulateNetworkDelay();

    final mockData = [
      {
        "id": "1",
        "componentName": "Aceite del motor",
        "category": "Lubricación",
        "description": "Cambio periódico de aceite y filtro",
        "frequencyKm": 3000,
        "frequencyMonths": 6,
        "explanation":
            "El aceite lubrica las partes móviles del motor, reduce la fricción y el desgaste, y ayuda a mantener el motor limpio. Un aceite viejo pierde sus propiedades lubricantes y puede causar daños graves.",
        "iconName": "oil_barrel",
        "priority": "crítico",
        "warningSignals": [
          "Ruidos extraños en el motor",
          "Nivel de aceite bajo",
          "Aceite oscuro o con partículas",
          "Humo excesivo del escape",
        ],
      },
      {
        "id": "2",
        "componentName": "Frenos (pastillas y discos)",
        "category": "Seguridad",
        "description": "Revisión y cambio de sistema de frenos",
        "frequencyKm": 10000,
        "frequencyMonths": 12,
        "explanation":
            "El sistema de frenos es crucial para tu seguridad. Las pastillas se desgastan con el uso y los discos pueden rayarse o deformarse. Una revisión periódica previene accidentes.",
        "iconName": "disc_full",
        "priority": "crítico",
        "warningSignals": [
          "Ruido chirriante al frenar",
          "Vibración en el manillar al frenar",
          "Frenado menos efectivo",
          "Pedal o maneta esponjosos",
        ],
      },
      {
        "id": "3",
        "componentName": "Llantas (neumáticos)",
        "category": "Seguridad",
        "description": "Revisión de presión, desgaste y estado",
        "frequencyKm": 5000,
        "frequencyMonths": 6,
        "explanation":
            "Las llantas son el único punto de contacto con el suelo. Un desgaste excesivo, presión incorrecta o daños pueden causar pérdida de control, especialmente en condiciones húmedas.",
        "iconName": "tire_repair",
        "priority": "alto",
        "warningSignals": [
          "Banda de rodadura desgastada (<1.6mm)",
          "Grietas o cortes en el caucho",
          "Deformaciones o bultos",
          "Pérdida frecuente de presión",
        ],
      },
      {
        "id": "4",
        "componentName": "Filtro de aire",
        "category": "Motor",
        "description": "Limpieza o cambio del filtro de aire",
        "frequencyKm": 6000,
        "frequencyMonths": 12,
        "explanation":
            "El filtro de aire evita que partículas de polvo y suciedad entren al motor. Un filtro sucio reduce el rendimiento, aumenta el consumo de combustible y puede dañar el motor.",
        "iconName": "air",
        "priority": "medio",
        "warningSignals": [
          "Pérdida de potencia",
          "Mayor consumo de combustible",
          "Dificultad para acelerar",
          "Filtro visiblemente sucio",
        ],
      },
      {
        "id": "5",
        "componentName": "Batería",
        "category": "Eléctrico",
        "description": "Revisión de carga y estado de la batería",
        "frequencyKm": null,
        "frequencyMonths": 24,
        "explanation":
            "La batería alimenta el sistema eléctrico de la moto. Con el tiempo pierde capacidad de carga. Una batería en mal estado puede dejarte varado o causar problemas eléctricos.",
        "iconName": "battery_charging_full",
        "priority": "medio",
        "warningSignals": [
          "Arranque difícil",
          "Luces tenues",
          "Batería con más de 2 años",
          "Corrosión en los bornes",
        ],
      },
      {
        "id": "6",
        "componentName": "Cadena de transmisión",
        "category": "Transmisión",
        "description": "Limpieza, lubricación y tensado",
        "frequencyKm": 500,
        "frequencyMonths": 1,
        "explanation":
            "La cadena transmite la potencia del motor a la rueda trasera. Una cadena sucia, seca o mal tensada se desgasta rápidamente y puede romperse, causando daños costosos.",
        "iconName": "link",
        "priority": "alto",
        "warningSignals": [
          "Ruido metálico",
          "Cadena muy suelta o muy tensa",
          "Oxidación visible",
          "Eslabones rígidos o dañados",
        ],
      },
      {
        "id": "7",
        "componentName": "Bujías",
        "category": "Motor",
        "description": "Revisión y cambio de bujías",
        "frequencyKm": 8000,
        "frequencyMonths": 12,
        "explanation":
            "Las bujías generan la chispa que enciende la mezcla de combustible. Bujías gastadas causan arranques difíciles, pérdida de potencia y mayor consumo de combustible.",
        "iconName": "bolt",
        "priority": "medio",
        "warningSignals": [
          "Arranque difícil",
          "Motor inestable en ralentí",
          "Pérdida de potencia",
          "Mayor consumo de combustible",
        ],
      },
      {
        "id": "8",
        "componentName": "Líquido de frenos",
        "category": "Seguridad",
        "description": "Cambio de líquido de frenos",
        "frequencyKm": null,
        "frequencyMonths": 24,
        "explanation":
            "El líquido de frenos transmite la presión del pedal/maneta a las pastillas. Con el tiempo absorbe humedad, reduciendo su efectividad y pudiendo causar corrosión en el sistema.",
        "iconName": "water_drop",
        "priority": "alto",
        "warningSignals": [
          "Líquido oscuro o sucio",
          "Frenado menos efectivo",
          "Pedal/maneta esponjosos",
          "Nivel bajo del líquido",
        ],
      },
      {
        "id": "9",
        "componentName": "Suspensión",
        "category": "Chasis",
        "description": "Revisión de amortiguadores y horquilla",
        "frequencyKm": 15000,
        "frequencyMonths": 24,
        "explanation":
            "La suspensión absorbe las irregularidades del camino y mantiene las ruedas en contacto con el suelo. Una suspensión en mal estado afecta el control, la comodidad y el desgaste de otros componentes.",
        "iconName": "plumbing",
        "priority": "medio",
        "warningSignals": [
          "Fugas de aceite",
          "Rebotes excesivos",
          "Ruidos al pasar baches",
          "Desgaste irregular de llantas",
        ],
      },
      {
        "id": "10",
        "componentName": "Sistema de refrigeración",
        "category": "Motor",
        "description": "Revisión de refrigerante y radiador",
        "frequencyKm": 10000,
        "frequencyMonths": 12,
        "explanation":
            "Mantiene el motor a temperatura óptima. Un sistema de refrigeración deficiente puede causar sobrecalentamiento y daños graves al motor.",
        "iconName": "thermostat",
        "priority": "alto",
        "warningSignals": [
          "Temperatura alta",
          "Nivel bajo de refrigerante",
          "Fugas visibles",
          "Ventilador no funciona",
        ],
      },
    ];

    print('✅ [MOCK] ${mockData.length} recomendaciones generales generadas');
    return mockData
        .map((json) => MaintenanceRecommendationModel.fromJson(json))
        .toList();
  }

  /// Obtiene recomendaciones ESPECÍFICAS para una moto simuladas
  Future<List<MaintenanceRecommendationModel>> getRecommendationsForMotorcycle(
    String motorcycleId,
  ) async {
    print('🎭 [MOCK] Obteniendo recomendaciones para moto $motorcycleId...');
    await _simulateNetworkDelay();

    // Por ahora, devolver las mismas recomendaciones generales
    // En el futuro, el backend podría personalizar según el modelo de moto
    final generalRecommendations = await getGeneralRecommendations();

    print(
      '✅ [MOCK] ${generalRecommendations.length} recomendaciones específicas generadas',
    );
    return generalRecommendations;
  }
}
