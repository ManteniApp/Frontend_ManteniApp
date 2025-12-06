import '../../domain/entities/recommendation_entity.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../datasources/recommendation_remote_data_source.dart';
import '../datasources/recommendation_mock_data_source.dart';

/// ⚠️ CONFIGURACIÓN: Cambiar a false cuando el backend esté listo
const bool USE_MOCK_DATA = false;

/// Implementación del repositorio de recomendaciones
class MaintenanceRecommendationRepositoryImpl
    implements MaintenanceRecommendationRepository {
  final RecommendationRemoteDataSource? remoteDataSource;
  final RecommendationMockDataSource? mockDataSource;

  MaintenanceRecommendationRepositoryImpl({
    this.remoteDataSource,
    this.mockDataSource,
  }) : assert(
         remoteDataSource != null || mockDataSource != null,
         'Debe proporcionar al menos un data source',
       );

  @override
  Future<List<MaintenanceRecommendationEntity>> getAllRecommendations() async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getAllRecommendations();
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>>
  getTechnicalRecommendations() async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getTechnicalRecommendations();
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones técnicas: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>>
  getGeneralRecommendations() async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getGeneralRecommendations();
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>>
  getSafetyRecommendations() async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getSafetyRecommendations();
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones de seguridad: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>>
  getPerformanceRecommendations() async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getPerformanceRecommendations();
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones de rendimiento: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>> getTechnicalByType(
    String type,
  ) async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getTechnicalByType(type);
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones técnicas por tipo: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>> getRecommendationsByCategory(
    String category,
  ) async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getRecommendationsByCategory(category);
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones por categoría: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>> getRecommendationsByPriority(
    String priority,
  ) async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getRecommendationsByPriority(priority);
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones por prioridad: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>>
  getUpcomingRecommendations() async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getUpcomingRecommendations();
      }
    } catch (e) {
      throw Exception('Error al obtener próximas recomendaciones: $e');
    }
  }

  @override
  Future<List<MaintenanceRecommendationEntity>>
  getRecommendationsByMaintenanceType(String type) async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getGeneralRecommendations();
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getRecommendationsByMaintenanceType(
          type,
        );
      }
    } catch (e) {
      throw Exception(
        'Error al obtener recomendaciones por tipo de mantenimiento: $e',
      );
    }
  }

  @override
  Future<bool> deleteRecommendation(String id) async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Simulando eliminación MOCK');
        return true;
      } else {
        print('📡 [Repository] Eliminando recomendación del backend');
        return await remoteDataSource!.deleteRecommendation(id);
      }
    } catch (e) {
      throw Exception('Error al eliminar recomendación: $e');
    }
  }

  @override
  @Deprecated('Usar getAllRecommendations() o getGeneralRecommendations()')
  Future<List<MaintenanceRecommendationEntity>> getRecommendationsForMotorcycle(
    String motorcycleId,
  ) async {
    try {
      if (USE_MOCK_DATA) {
        print('🎭 [Repository] Usando datos MOCK para moto $motorcycleId');
        final mock = mockDataSource ?? RecommendationMockDataSource();
        return await mock.getRecommendationsForMotorcycle(motorcycleId);
      } else {
        print('📡 [Repository] Usando datos REALES del backend');
        return await remoteDataSource!.getRecommendationsForMotorcycle(
          motorcycleId,
        );
      }
    } catch (e) {
      throw Exception('Error al obtener recomendaciones: $e');
    }
  }
}
